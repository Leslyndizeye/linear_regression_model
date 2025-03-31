# Flight Delay Prediction Project

## Overview
This project provides a complete solution for flight delay prediction, helping travelers and airlines anticipate disruptions and improve operational efficiency. The system includes a model, API and a Flutter mobile application that allows users to check potential flight delays based on various parameters.

## Project Components

### 1. Flight Delay Prediction API
The API provides predictions on whether flights will be delayed based on flight information parameters.

- **Public API Endpoint**: [https://linear-regression-model-pbj2.onrender.com/predict](https://linear-regression-model-pbj2.onrender.com/predict)
- **Swagger UI Documentation**: [https://linear-regression-model-pbj2.onrender.com/docs](https://linear-regression-model-pbj2.onrender.com/docs)

### 2. Flutter Mobile Application
A user-friendly mobile application that allows users to input flight details and receive delay predictions.

## Dataset and Model

The project uses flight data from 2019 and 2020 with approximately 2 million records.

**Source**: [Kaggle - Flight Delay Prediction](https://www.kaggle.com/datasets/divyansh22/flight-delay-prediction)

**Model Performance:**
| Model              | Accuracy | Precision | Recall | F1 Score | AUC    | Log Loss | MSE    | MAE    | R²      |
|--------------------|----------|-----------|--------|----------|--------|----------|--------|--------|---------|
| Linear Regression  | 0.8582   | 0.8027    | 0.0830 | 0.1504   | 0.7869 | 0.4705   | 0.1146 | 0.2353 | 0.1070  |
| Decision Tree      | 0.8291   | 0.4606    | 0.7606 | 0.5737   | 0.8876 | 0.3867   | 0.1709 | 0.1709 | -0.3315 |
| Random Forest      | 0.6414   | 0.2621    | 0.7553 | 0.3891   | 0.7808 | 0.6012   | 0.3586 | 0.3586 | -1.7942 |

**Best Model**: Decision Tree (Highest AUC: 0.8876 with F1 Score of 0.5737)

## How to Run the Project

### Setup API (For Development)
1. Clone the repository
2. Install requirements:
   ```
   pip install -r requirements.txt
   ```
3. Run the Jupyter notebook:
   ```
   multivariate.ipynb
   ```

### Using the API
The API is already deployed and accessible at:
- [https://linear-regression-model-pbj2.onrender.com](https://linear-regression-model-pbj2.onrender.com)

To test the API:
1. Navigate to the Swagger UI: [https://linear-regression-model-pbj2.onrender.com/docs](https://linear-regression-model-pbj2.onrender.com/docs)
2. Use the interactive interface to send requests and receive predictions

### Running the Flutter Mobile App

#### Prerequisites
- Flutter SDK installed (version 2.0 or higher)
- Android Studio or Xcode for emulation/device deployment
- An active internet connection

#### Installation Steps
1. Clone the repository
2. Navigate to the Flutter app directory:
   ```bash
   cd summative/FlutterApp/flight_delay_predictor
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

#### Building the App
- For Android:
  ```bash
  flutter build apk
  ```
- For iOS:
  ```bash
  flutter build ios
  ```

## Demo
[YouTube Video Demo](https://www.youtube.com/watch?si=zbKMe8Zc6gjI3N8k&v=_t-_O-kZy8Y&feature=youtu.be) (5 min demonstration)

## API Usage
### Input JSON Format
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

### Response Format
```json
{
    "predicted_delay_duration": "10.0 min",
    "delayed_departure_time": "08:58"
}
```

## Project Structure
```
flight_delay_predictor/
├── API/                     # API implementation files
├── FlutterApp/              # Mobile application
│   └── flight_delay_predictor/
│       ├── lib/             # Flutter app source code
│       │   └── main.dart    # App entry point
│       └── ...
└── linear_regression/       # Model training and analysis
    └── ...
```

## Future Improvements
- Incorporate real-time weather and traffic data
- Analyze seasonal and holiday effects on flight punctuality
- Explore additional mathematical techniques for better insights
- Add user authentication to the mobile app
- Implement push notifications for flight status updates
