import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart' as sensors;

class AccelerometerPage extends StatefulWidget {
  @override
  _AccelerometerPageState createState() => _AccelerometerPageState();
}

class _AccelerometerPageState extends State<AccelerometerPage> {
  double _x = 0.0;
  double _y = 0.0;
  double _z = 0.0;

  StreamSubscription<sensors.AccelerometerEvent>? _accelerometerSubscription;

  @override
  void initState() {
    super.initState();
    _listenToAccelerometer();
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  Future<void> _listenToAccelerometer() async {
    _accelerometerSubscription = sensors.accelerometerEvents.listen((sensors.AccelerometerEvent event) {
      setState(() {
        _x = event.x;
        _y = event.y;
        _z = event.z;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accelerometer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('X: $_x'),
            Text('Y: $_y'),
            Text('Z: $_z'),
          ],
        ),
      ),
    );
  }
}