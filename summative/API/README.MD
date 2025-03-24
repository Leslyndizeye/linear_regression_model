# Flight Prediction API

This API provides flight delay predictions based on flight information. It accepts input data about flight parameters such as departure time, airports, carrier, and other relevant details, and returns a prediction for whether the flight will be delayed or on time.

### API Endpoint

#### **Prediction API**
**Endpoint URL**: [https://linear-regression-model-pbj2.onrender.com/predict](https://linear-regression-model-pbj2.onrender.com/predict)
note !!! : first add docs on [https://linear-regression-model-pbj2.onrender.com/] for being able to access endpoint url
- This endpoint accepts flight data as a JSON payload and returns the prediction for whether the flight will be delayed or on time.

---

### **Input JSON Format**

The API expects a JSON object with the following fields:

```json
{
    "day_of_month": 22,
    "day_of_week": 3,
    "op_unique_carrier": "MQ",
    "op_carrier_airline_id": 20398,
    "op_carrier": "MQ",
    "origin_airport_id": 11298,
    "origin": "DFW",
    "dest_airport_id": 14783,
    "dest": "SGF",
    "dep_time": 857.0,
    "distance": 364.0,
    "dep_hour": 8.0,
    "distance_per_hour": 45.5,
    "time_of_day": "Morning",
    "distance_group": "Very Short",
    "dep_time_blk": "0800-0859"
}
```

OR

```json
{
    "day_of_month": 22,
    "day_of_week": 3,
    "op_carrier_airline_id": 19790,
    "origin_airport_id": 10397,
    "dest_airport_id": 11298,
    "dep_time": 1400.0,
    "distance": 800.0,
    "dep_hour": 14,
    "distance_per_hour": 57.14,
    "op_unique_carrier": "DL",
    "op_carrier": "DL",
    "origin": "JFK",
    "dest": "LAX",
    "dep_time_blk": "1400-1459",
    "time_of_day": "Afternoon",
    "distance_group": "Medium"
}
```

### **Response Format**

The response will be a JSON object containing the predicted delay duration and delayed departure time (if applicable):

```json
{
    "predicted_delay_duration": "1.0 min",
    "delayed_departure_time": "08:58"
}
```

OR

```json
{
    "predicted_delay_duration": "0.0 min",
    "delayed_departure_time": "On Time"
}
```

---

### **Example Request and Response**

#### **Request Example (Delayed Flight)**

**Endpoint URL**: `POST https://linear-regression-model-pbj2.onrender.com/predict`

```json
{
    "day_of_month": 22,
    "day_of_week": 3,
    "op_unique_carrier": "MQ",
    "op_carrier_airline_id": 20398,
    "op_carrier": "MQ",
    "origin_airport_id": 11298,
    "origin": "DFW",
    "dest_airport_id": 14783,
    "dest": "SGF",
    "dep_time": 857.0,
    "distance": 364.0,
    "dep_hour": 8.0,
    "distance_per_hour": 45.5,
    "time_of_day": "Morning",
    "distance_group": "Very Short",
    "dep_time_blk": "0800-0859"
}
```

**Response Example**:

```json
{
    "predicted_delay_duration": "1.0 min",
    "delayed_departure_time": "08:58"
}
```

---

#### **Request Example (On-Time Flight)**

**Endpoint URL**: `POST https://linear-regression-model-pbj2.onrender.com/predict`

```json
{
    "day_of_month": 22,
    "day_of_week": 3,
    "op_carrier_airline_id": 19790,
    "origin_airport_id": 10397,
    "dest_airport_id": 11298,
    "dep_time": 1400.0,
    "distance": 800.0,
    "dep_hour": 14,
    "distance_per_hour": 57.14,
    "op_unique_carrier": "DL",
    "op_carrier": "DL",
    "origin": "JFK",
    "dest": "LAX",
    "dep_time_blk": "1400-1459",
    "time_of_day": "Afternoon",
    "distance_group": "Medium"
}
```

**Response Example**:

```json
{
    "predicted_delay_duration": "0.0 min",
    "delayed_departure_time": "On Time"
}
```

---

### **Testing with Swagger UI**

To test the API, you can use the Swagger UI interface. Simply go to the following URL:

[https://linear-regression-model-pbj2.onrender.com/docs](https://linear-regression-model-pbj2.onrender.com/docs)

Here, you will be able to send requests to the API and receive responses directly from the Swagger UI interface.

---

### **Deployment**

- The API is hosted at a publicly routable URL to allow for easy access and integration.
- The API should be tested using Swagger UI, which provides an interactive interface for calling the API endpoints.

---

**Note**: The public API URL is hosted at `https://linear-regression-model-pbj2.onrender.com`, and you can interact with the API directly through the provided Swagger UI interface.