import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class LocationTrackerPage extends StatefulWidget {
  @override
  _LocationTrackerPageState createState() => _LocationTrackerPageState();
}

class _LocationTrackerPageState extends State<LocationTrackerPage> {
  late Position _currentPosition; // Initialize _currentPosition as late
  List<Geofence> _geofences = [];
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _createGeofences();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  void _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
      } else if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied');
      } else {
        _startLocationTracking();
      }
    } else {
      _startLocationTracking();
    }
  }

  void _startLocationTracking() {
    _positionStreamSubscription = Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _checkGeofences(position);
    });
  }

  void _createGeofences() {
    // Define geofences here
    _geofences = [
      Geofence(
        identifier: 'Home',
        latitude: 40.7128,
        longitude: -74.0060,
        radius: 500,
        transitionType: TransitionType.enter,
      ),
      Geofence(
        identifier: 'Work',
        latitude: 40.7643,
        longitude: -73.9712,
        radius: 300,
        transitionType: TransitionType.exit,
      ),
    ];
  }

  void _checkGeofences(Position currentPosition) {
    for (Geofence geofence in _geofences) {
      double distanceInMeters = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        geofence.latitude,
        geofence.longitude,
      );

      if (distanceInMeters <= geofence.radius) {
        if (geofence.transitionType == TransitionType.enter) {
          _showNotification('Entered ${geofence.identifier}');
        } else {
          _showNotification('Exited ${geofence.identifier}');
        }
      }
    }
  }

  void _showNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Tracker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Latitude: ${_currentPosition?.latitude ?? 'N/A'}'),
            Text('Longitude: ${_currentPosition?.longitude ?? 'N/A'}'),
            ElevatedButton(
              child: Text('Trigger Action'),
              onPressed: () {
                // Implement additional actions here
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Geofence {
  final String identifier;
  final double latitude;
  final double longitude;
  final double radius;
  final TransitionType transitionType;

  Geofence({
    required this.identifier,
    required this.latitude,
    required this.longitude,
    required this.radius,
    this.transitionType = TransitionType.enter,
  });
}

enum TransitionType { enter, exit }
