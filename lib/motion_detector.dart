import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:rxdart/rxdart.dart'; // Add this package for debounce functionality
import 'dart:math'; // Import dart:math library

// Constants
const double _motionDetectionThreshold = 2.0;
const int _debounceDuration = 500; // Debounce duration in milliseconds

class MotionDetectorPage extends StatefulWidget {
  @override
  _MotionDetectorPageState createState() => _MotionDetectorPageState();
}

class _MotionDetectorPageState extends State<MotionDetectorPage> {
  String _motionDetected = '';
  final _debounceStream = PublishSubject<void>(); // Debounce stream

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen(_handleAccelerometerEvent);
  }

  void _handleAccelerometerEvent(AccelerometerEvent event) {
    if (_isMotionDetected(event)) {
      setState(() {
        _motionDetected = 'Motion detected!';
      });
      _debounceStream.add(null); // Trigger debounce
    } else {
      setState(() {
        _motionDetected = '';
      });
    }
  }

  bool _isMotionDetected(AccelerometerEvent event) {
    // Calculate magnitude of acceleration vector using Euclidean norm
    double magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
    return magnitude > _motionDetectionThreshold;
  }

  void _triggerAlert() {
    // Implement the logic to trigger a notification or alert
    _debounceStream.debounceTime(Duration(milliseconds: _debounceDuration)).listen((_) {
      _showNotification('Motion detected!');
    });
  }

  void _showNotification(String message) {
    // Implement the logic to show a notification
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      print('Error showing notification: $e');
      // Log the error for debugging purposes
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Motion Detector'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_motionDetected),
          ],
        ),
      ),
    );
  }
}