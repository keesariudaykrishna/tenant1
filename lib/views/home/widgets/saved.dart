// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, unused_local_variable

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class DirectionPage extends StatefulWidget {
  const DirectionPage({super.key});

  @override
  _DirectionPageState createState() => _DirectionPageState();
}

class _DirectionPageState extends State<DirectionPage> {
  double? _currentLatitude;
  double? _currentLongitude;

  // Target person's house coordinates (Example)
  double targetLatitude = 31.4805; // Replace with person's house latitude
  double targetLongitude = 74.3239; // Replace with person's house longitude

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Function to get current location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      return;
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Permissions are denied
        return;
      }
    }

    // Get current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentLatitude = 31.4671104;
      _currentLongitude = 74.3112704;
      // _currentLatitude = position.latitude;
      // _currentLongitude = position.longitude;
    });
  }

  // Function to open directions in Google Maps or any map app
  Future<void> _openDirections() async {
    if (_currentLatitude != null && _currentLongitude != null) {
      final String destinationLat = targetLatitude.toString();
      final String destinationLon = targetLongitude.toString();

      // Create the URL for Google Maps directions
      final Uri url = Uri.parse(
          'https://www.google.com/maps/dir/?api=1&origin=$_currentLatitude,$_currentLongitude&destination=$destinationLat,$destinationLon');

      // Open directions in Google Maps
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    } else {
      // If current location is not available
      debugPrint('Current location is not available yet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Directions to Target House"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_currentLatitude != null && _currentLongitude != null)
              Column(
                children: [
                  Text(
                      'Current Location: Latitude: $_currentLatitude, Longitude: $_currentLongitude'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _openDirections,
                    child: Text('Get Directions to Target House'),
                  ),
                ],
              )
            else
              CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
