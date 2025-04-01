import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/property.dart';

class MapScreen extends StatefulWidget {
  final List<Property> properties;

  MapScreen({required this.properties});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  final LatLng _center = LatLng(20.5937, 78.9629); // India center

  Set<Marker> _createMarkers() {
    return widget.properties.map((property) => Marker(
      markerId: MarkerId(property.id),
      position: LatLng(20.5937 + (widget.properties.indexOf(property) * 0.1), 78.9629), // Dummy coords
      infoWindow: InfoWindow(title: property.title, snippet: '£${property.price}/night'),
    )).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map View')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _center, zoom: 5.0),
        onMapCreated: (controller) => _controller = controller,
        markers: _createMarkers(),
      ),
    );
  }
}