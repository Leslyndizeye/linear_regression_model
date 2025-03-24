from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, validator
import joblib
import pandas as pd

# Load the saved model
model = joblib.load('best_flight_delay_model.pkl')

# Define input schema using Pydantic
class FlightData(BaseModel):
    # Numerical features (9 features)
    day_of_month: int
    day_of_week: int
    op_carrier_airline_id: int
    origin_airport_id: int
    dest_airport_id: int
    dep_time: float
    distance: float
    dep_hour: int
    distance_per_hour: float

    # Categorical features (7 features)
    op_unique_carrier: str  # Example: "AA", "DL"
    op_carrier: str  # Example: "AA", "DL"
    origin: str  # Example: "ATL", "DFW"
    dest: str  # Example: "LAX", "JFK"
    dep_time_blk: str  # Example: "0800-0859", "1600-1659"
    time_of_day: str  # Example: "Morning", "Afternoon"
    distance_group: str  # Example: "Short", "Medium"

    # Validators for numerical features
    @validator('day_of_month')
    def validate_day_of_month(cls, value):
        if value < 1 or value > 31:
            raise ValueError('Day of month must be between 1 and 31')
        return value

    @validator('day_of_week')
    def validate_day_of_week(cls, value):
        if value < 1 or value > 7:
            raise ValueError('Day of week must be between 1 and 7')
        return value

    @validator('dep_hour')
    def validate_dep_hour(cls, value):
        if value < 0 or value > 23:
            raise ValueError('Departure hour must be between 0 and 23')
        return value

    @validator('distance')
    def validate_distance(cls, value):
        if value < 0:
            raise ValueError('Distance must be a positive number')
        return value

    @validator('dep_time')
    def validate_dep_time(cls, value):
        if value < 0 or value > 2359:
            raise ValueError('Departure time must be between 0000 and 2359')
        return value

# Initialize FastAPI app
app = FastAPI()

# Add CORS middleware
from fastapi.middleware.cors import CORSMiddleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# Helper function to convert HHMM to minutes
def convert_to_minutes(time):
    """Convert HHMM time format to total minutes since midnight."""
    return (time // 100) * 60 + (time % 100)

# Helper function to convert minutes to HH:MM
def convert_to_hhmm(minutes):
    """Convert total minutes since midnight to HH:MM format."""
    hours = minutes // 60
    minutes = minutes % 60
    return f"{int(hours):02d}:{int(minutes):02d}"  # Add colon between hours and minutes

# Define prediction endpoint
@app.post("/predict")
def predict(data: FlightData):
    try:
        # Convert input data to a DataFrame
        input_data = pd.DataFrame([[
            # Numerical features (9 features)
            data.day_of_month, data.day_of_week, data.op_carrier_airline_id,
            data.origin_airport_id, data.dest_airport_id, data.dep_time,
            data.distance, data.dep_hour, data.distance_per_hour,

            # Categorical features (7 features)
            data.op_unique_carrier, data.op_carrier,
            data.origin, data.dest,
            data.dep_time_blk, data.time_of_day,
            data.distance_group
        ]], columns=[
            # Numerical features
            'DAY_OF_MONTH', 'DAY_OF_WEEK', 'OP_CARRIER_AIRLINE_ID',
            'ORIGIN_AIRPORT_ID', 'DEST_AIRPORT_ID', 'DEP_TIME',
            'DISTANCE', 'DEP_HOUR', 'DISTANCE_PER_HOUR',

            # Categorical features
            'OP_UNIQUE_CARRIER', 'OP_CARRIER',
            'ORIGIN', 'DEST',
            'DEP_TIME_BLK', 'TIME_OF_DAY',
            'DISTANCE_GROUP'
        ])

        # Make prediction (delay duration in minutes)
        predicted_delay = model.predict(input_data)[0]

        # Calculate exact delayed departure time
        scheduled_dep_time_min = convert_to_minutes(data.dep_time)
        delayed_dep_time_min = scheduled_dep_time_min + predicted_delay
        delayed_dep_time = convert_to_hhmm(delayed_dep_time_min)  # Updated to HH:MM format

        # Return the predicted delay duration and exact delayed time
        return {
            "predicted_delay_duration": f"{float(predicted_delay)} min",  # Add "min" to indicate minutes
            "delayed_departure_time": delayed_dep_time  # Now in HH:MM format
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))
# Run the API
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)