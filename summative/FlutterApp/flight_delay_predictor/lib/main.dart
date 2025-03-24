// main.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

void main() {
  runApp(FlightDelayApp());
}

class FlightDelayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flight Delay Predictor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flight Delay Predictor'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.flight,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to Flight Delay Predictor',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Predict your flight delay with machine learning',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PredictionPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Text(
                'Make a Prediction',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PredictionPage extends StatefulWidget {
  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dayOfMonthController = TextEditingController();
  final TextEditingController _dayOfWeekController = TextEditingController();
  final TextEditingController _opCarrierAirlineIdController = TextEditingController();
  final TextEditingController _originAirportIdController = TextEditingController();
  final TextEditingController _destAirportIdController = TextEditingController();
  final TextEditingController _depTimeController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _depHourController = TextEditingController();
  final TextEditingController _distancePerHourController = TextEditingController();
  final TextEditingController _opUniqueCarrierController = TextEditingController();
  final TextEditingController _opCarrierController = TextEditingController();
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destController = TextEditingController();
  final TextEditingController _depTimeBlkController = TextEditingController();
  final TextEditingController _timeOfDayController = TextEditingController();
  final TextEditingController _distanceGroupController = TextEditingController();

  bool _isLoading = false;
  String _predictionResult = '';
  String _errorMessage = '';

  Future<void> _makeApiRequest() async {
    setState(() {
      _isLoading = true;
      _predictionResult = '';
      _errorMessage = '';
    });

    try {
      // Replace with your actual API endpoint
      var url = Uri.parse('https://linear-regression-model-pbj2.onrender.com/predict');
      
      var requestBody = {
        "day_of_month": int.parse(_dayOfMonthController.text),
        "day_of_week": int.parse(_dayOfWeekController.text),
        "op_carrier_airline_id": int.parse(_opCarrierAirlineIdController.text),
        "origin_airport_id": int.parse(_originAirportIdController.text),
        "dest_airport_id": int.parse(_destAirportIdController.text),
        "dep_time": double.parse(_depTimeController.text),
        "distance": double.parse(_distanceController.text),
        "dep_hour": int.parse(_depHourController.text),
        "distance_per_hour": double.parse(_distancePerHourController.text),
        "op_unique_carrier": _opUniqueCarrierController.text,
        "op_carrier": _opCarrierController.text,
        "origin": _originController.text,
        "dest": _destController.text,
        "dep_time_blk": _depTimeBlkController.text,
        "time_of_day": _timeOfDayController.text,
        "distance_group": _distanceGroupController.text
      };

      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        
        setState(() {
          _predictionResult = 'Predicted Delay: ${result["predicted_delay_duration"]}\n'
              'Delayed Departure Time: ${result["delayed_departure_time"]}';
          _isLoading = false;
        });
        
        // Navigate to results page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(
              predictionResult: _predictionResult,
              inputData: requestBody,
            ),
          ),
        );
      } else {
        var errorData = jsonDecode(response.body);
        setState(() {
          _errorMessage = 'Error: ${errorData["detail"]}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _dayOfMonthController.dispose();
    _dayOfWeekController.dispose();
    _opCarrierAirlineIdController.dispose();
    _originAirportIdController.dispose();
    _destAirportIdController.dispose();
    _depTimeController.dispose();
    _distanceController.dispose();
    _depHourController.dispose();
    _distancePerHourController.dispose();
    _opUniqueCarrierController.dispose();
    _opCarrierController.dispose();
    _originController.dispose();
    _destController.dispose();
    _depTimeBlkController.dispose();
    _timeOfDayController.dispose();
    _distanceGroupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flight Delay Prediction'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Enter Flight Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              
              // Numerical inputs group
              Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Flight Date and Time:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      
                      _buildTextField(
                        controller: _dayOfMonthController,
                        labelText: 'Day of Month (1-31)',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter day of month';
                          }
                          int? day = int.tryParse(value);
                          if (day == null || day < 1 || day > 31) {
                            return 'Day must be between 1 and 31';
                          }
                          return null;
                        },
                      ),
                      
                      _buildTextField(
                        controller: _dayOfWeekController,
                        labelText: 'Day of Week (1-7, where 1 is Monday)',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter day of week';
                          }
                          int? day = int.tryParse(value);
                          if (day == null || day < 1 || day > 7) {
                            return 'Day must be between 1 and 7';
                          }
                          return null;
                        },
                      ),
                      
                      _buildTextField(
                        controller: _depTimeController,
                        labelText: 'Departure Time (HHMM format, e.g. 1430 for 2:30 PM)',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter departure time';
                          }
                          double? time = double.tryParse(value);
                          if (time == null || time < 0 || time > 2359) {
                            return 'Time must be between 0000 and 2359';
                          }
                          return null;
                        },
                      ),
                      
                      _buildTextField(
                        controller: _depHourController,
                        labelText: 'Departure Hour (0-23)',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter departure hour';
                          }
                          int? hour = int.tryParse(value);
                          if (hour == null || hour < 0 || hour > 23) {
                            return 'Hour must be between 0 and 23';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              // Flight route details
              Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Flight Route:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      
                      _buildTextField(
                        controller: _originController,
                        labelText: 'Origin Airport Code (e.g. LAX)',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter origin airport code';
                          }
                          if (value.length != 3) {
                            return 'Airport code should be 3 letters';
                          }
                          return null;
                        },
                      ),
                      
                      _buildTextField(
                        controller: _originAirportIdController,
                        labelText: 'Origin Airport ID',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter origin airport ID';
                          }
                          return null;
                        },
                      ),
                      
                      _buildTextField(
                        controller: _destController,
                        labelText: 'Destination Airport Code (e.g. JFK)',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter destination airport code';
                          }
                          if (value.length != 3) {
                            return 'Airport code should be 3 letters';
                          }
                          return null;
                        },
                      ),
                      
                      _buildTextField(
                        controller: _destAirportIdController,
                        labelText: 'Destination Airport ID',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter destination airport ID';
                          }
                          return null;
                        },
                      ),
                      
                      _buildTextField(
                        controller: _distanceController,
                        labelText: 'Distance (miles)',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter distance';
                          }
                          double? distance = double.tryParse(value);
                          if (distance == null || distance < 0) {
                            return 'Distance must be positive';
                          }
                          return null;
                        },
                      ),
                      
                      _buildTextField(
                        controller: _distancePerHourController,
                        labelText: 'Distance Per Hour',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter distance per hour';
                          }
                          return null;
                        },
                      ),
                      
                      _buildTextField(
                        controller: _distanceGroupController,
                        labelText: 'Distance Group (Short, Medium, Long)',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter distance group';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              // Airline details
              Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Airline Information:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      
                      _buildTextField(
                        controller: _opUniqueCarrierController,
                        labelText: 'Unique Carrier Code (e.g. AA)',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter carrier code';
                          }
                          return null;
                        },
                      ),
                      
                      _buildTextField(
                        controller: _opCarrierController,
                        labelText: 'Carrier Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter carrier name';
                          }
                          return null;
                        },
                      ),
                      
                      _buildTextField(
                        controller: _opCarrierAirlineIdController,
                        labelText: 'Carrier Airline ID',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter carrier airline ID';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              // Other categoricals
              Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Additional Information:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      
                      _buildTextField(
                        controller: _depTimeBlkController,
                        labelText: 'Departure Time Block (e.g. 0800-0859)',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter departure time block';
                          }
                          return null;
                        },
                      ),
                      
                      _buildTextField(
                        controller: _timeOfDayController,
                        labelText: 'Time of Day (Morning, Afternoon, Evening, Night)',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter time of day';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                
              SizedBox(height: 20),
              
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            _makeApiRequest();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Predict Flight Delay', style: TextStyle(fontSize: 18)),
                ),
              ),
              
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final String predictionResult;
  final Map<String, dynamic> inputData;

  ResultPage({required this.predictionResult, required this.inputData});

  @override
  Widget build(BuildContext context) {
    // Format the prediction result into something more user-friendly
    List<String> resultLines = predictionResult.split('\n');
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Prediction Results'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              elevation: 6,
              color: Colors.blue[100],
              margin: EdgeInsets.only(bottom: 24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.flight_takeoff,
                      size: 48,
                      color: Colors.blue[800],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Flight Delay Prediction',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    SizedBox(height: 20),
                    for (var line in resultLines)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          line,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            Text(
              'Flight Details Used:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            
            // Display a summary of input data
            Card(
              elevation: 4,
              margin: EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Flight Route', '${inputData["origin"]} → ${inputData["dest"]}'),
                    _buildInfoRow('Scheduled Departure', _formatTime(inputData["dep_time"].toString())),
                    _buildInfoRow('Day', 'Day ${inputData["day_of_month"]}, Weekday ${inputData["day_of_week"]}'),
                    _buildInfoRow('Airline', inputData["op_carrier"]),
                    _buildInfoRow('Distance', '${inputData["distance"]} miles'),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Make Another Prediction'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label + ':',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String timeStr) {
    try {
      double time = double.parse(timeStr);
      int hours = (time ~/ 100) % 24;
      int minutes = (time % 100).toInt();
      
      String period = hours >= 12 ? 'PM' : 'AM';
      hours = hours % 12;
      if (hours == 0) hours = 12;
      
      return '$hours:${minutes.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return timeStr;
    }
  }
}