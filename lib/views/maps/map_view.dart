// import 'dart:async';
// import 'package:apartment_rentals/res/app_widgets/app_bar.dart';
// import 'package:apartment_rentals/views/details/details_view.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:get/get.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:geolocator/geolocator.dart';
// import '../../view_models/controllers/map/map_view_model.dart';

// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});

//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   final MapsController mapController = Get.put(MapsController());
//   StreamSubscription<Position>? _locationStream;

//   @override
//   void initState() {
//     super.initState();
//     mapController.getCurrentLocation();
//     _startLocationUpdates();
//   }

//   void _startLocationUpdates() {
//     _locationStream = Geolocator.getPositionStream(
//       locationSettings: const LocationSettings(
//         accuracy: LocationAccuracy.high,
//         distanceFilter: 10,
//       ),
//     ).listen((Position position) {
//       mapController.latitude.value = position.latitude;
//       mapController.longitude.value = position.longitude;
//     });
//   }

//   @override
//   void dispose() {
//     _locationStream?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: MyAppBar(
//         title: 'Maps',
//         showBackButton: false,
//       ),
//       body: Obx(() {
//         if (mapController.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (mapController.markers.isEmpty) {
//           return const Center(child: Text("No apartments available."));
//         }

//         LatLng currentLocation = LatLng(
//           mapController.latitude.value,
//           mapController.longitude.value,
//         );

//         return FlutterMap(
//           options: MapOptions(
//             initialCenter: currentLocation,
//             initialZoom: 15,
//             interactionOptions: const InteractionOptions(
//               flags: InteractiveFlag.all,
//             ),
//           ),
//           children: [
//             TileLayer(
//               urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//               subdomains: ['a', 'b', 'c'],
//             ),
//             CircleLayer(
//               circles: [
//                 CircleMarker(
//                   point: currentLocation,
//                   color: Colors.blue.withOpacity(0.3),
//                   borderStrokeWidth: 2,
//                   borderColor: Colors.blue,
//                   useRadiusInMeter: true,
//                   radius: 500, // Circle radius in meters
//                 ),
//               ],
//             ),
//             MarkerLayer(
//               markers: mapController.markers.map((data) {
//                 return Marker(
//                   point: data['location'], // LatLng of the apartment
//                   width: 60,
//                   height: 60,
//                   child: GestureDetector(
//                     onTap: () => _showApartmentDetails(context, data),
//                     child: const Icon(
//                       Icons.house,
//                       color: Colors.red,
//                       size: 30,
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//             // Marker for the current location
//             MarkerLayer(
//               markers: [
//                 Marker(
//                   point: currentLocation,
//                   width: 60,
//                   height: 60,
//                   child: Icon(
//                     Icons.location_on,
//                     color: Colors.green,
//                     size: 40,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         );
//       }),
//     );
//   }

//   void _showApartmentDetails(BuildContext context, Map<dynamic, dynamic> data) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Container(
//             width: double.infinity,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 InkWell(
//                   onTap: () {
//                     Get.to(()=> ApartmentDetailsScreen(apartmentId: data['uuid']));
//                   },
//                   child: Text(
//                     data['address'] ?? 'Apartment',
//                     style: const TextStyle(
//                         fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text('Price: \$${data['price'] ?? 'N/A'}'),
//                 Text('Address: ${data['address'] ?? 'N/A'}'),
//                 // Text('Description: ${data['description'] ?? 'N/A'}'),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'dart:async';
import 'package:apartment_rentals/res/app_widgets/app_bar.dart';
import 'package:apartment_rentals/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../utils/utils.dart';
import '../../view_models/controllers/map/map_view_model.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapsController mapController = Get.put(MapsController());
  StreamSubscription<Position>? _locationStream;
  final Distance _distanceCalculator = const Distance();
  double filterRadius = 500.0; // Start with 500 meters

  @override
  void initState() {
    super.initState();
    mapController.getCurrentLocation();
    _startLocationUpdates();
    _filterMarkers();
    mapController.showAllApartments.value;
  }

  void _startLocationUpdates() {
    _locationStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      mapController.latitude.value = position.latitude;
      mapController.longitude.value = position.longitude;
      _filterMarkers(); // Filter markers when location updates
    });
  }

  void _filterMarkers() {
    final LatLng currentLocation = LatLng(
      mapController.latitude.value,
      mapController.longitude.value,
    );

    // Filter markers based only on the selected filter radius
    final List<Map<String, dynamic>> filteredMarkers =
        mapController.allMarkers.where((data) {
      final double distance = _distanceCalculator.as(
        LengthUnit.Meter,
        currentLocation,
        data['location'], // LatLng of the apartment
      );
      return distance <=
          mapController.filterRadius.value; // Respect slider radius
    }).toList();

    mapController.filteredMarkers.assignAll(filteredMarkers);
  }

  @override
  void dispose() {
    _locationStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Map',
        actions: [
          PopupMenuButton<int>(
            onSelected: (value) {
              if (value == 1) {
                mapController.toggleShowAllApartments(
                    !mapController.showAllApartments.value);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Obx(() {
                  return Row(
                    children: [
                      Checkbox(
                        value: mapController.showAllApartments.value,
                        onChanged: (bool? value) {
                          if (value != null) {
                            mapController.toggleShowAllApartments(value);
                            Navigator.pop(context); // Close the dropdown
                          }
                        },
                      ),
                      const Text('Show all properties'),
                    ],
                  );
                }),
              ),
              PopupMenuItem(
                enabled: false, // Disable interaction for text label
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Text(
                        'Radius: ${mapController.filterRadius.value.toInt()} meters',
                      ),
                    ),
                    Obx(() {
                      return Slider(
                        activeColor: kSecondaryLight2,
                        inactiveColor: kSecondaryLight3.withAlpha(100),
                        value: mapController.filterRadius.value,
                        min: 100,
                        max: 5000,
                        divisions: 49,
                        onChanged: (value) {
                          mapController.updateFilterRadius(value);
                          _filterMarkers();
                        },
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      // appBar:
      // AppBar(
      //   title: const Text('Maps'),
      //   actions: [
      //     Obx(() {
      //       return Padding(
      //         padding: EdgeInsets.all(8.0),
      //         child: Row(
      //           children: [
      //             Checkbox(
      //               value: mapController.showAllApartments.value,
      //               onChanged: (bool? value) {
      //                 if (value != null) {
      //                   mapController.toggleShowAllApartments(value);
      //                 }
      //               },
      //             ),
      //             Text('Show all properties'),
      //           ],
      //         ),
      //       );
      //     }),
      //   ],
      // ),
      body: Obx(() {
        if (mapController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        LatLng currentLocation = LatLng(
          mapController.latitude.value,
          mapController.longitude.value,
        );

        return Column(
          children: [
            // Add a slider to change filter radius
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     children: [
            //       Obx(() {
            //         return Text(
            //           'Filter Radius: ${mapController.filterRadius.value.toInt()} meters',
            //         );
            //       }),
            // Expanded(
            //   child: Obx(() {
            //     return Slider(
            //       activeColor: kSecondaryLight2,
            //       inactiveColor: kSecondaryLight3.withValues(alpha: 100),
            //       secondaryActiveColor: kSecondary,
            //       thumbColor: kSecondary,
            //       value: mapController.filterRadius.value,
            //       min: 100,
            //       max: 5000,
            //       divisions: 49,
            //       onChanged: (value) {
            //         mapController.updateFilterRadius(value);
            //         _filterMarkers();
            //       },
            //     );
            //   }),
            // ),
            //     ],
            //   ),
            // ),

            // Map View
            Expanded(
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: currentLocation,
                  initialZoom: 15,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  ),

                  // TileLayer(
                  //   urlTemplate:
                  //       "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  //   subdomains: ['a', 'b', 'c'],
                  // ),
                  // Circle for current location with dynamic radius
                  Obx(() {
                    return CircleLayer(
                      circles: [
                        CircleMarker(
                          point: currentLocation,
                          color: Colors.blue.withValues(alpha: 0.3),
                          borderStrokeWidth: 2,
                          borderColor: Colors.blue,
                          useRadiusInMeter: true,
                          radius: mapController.filterRadius.value,
                        ),
                      ],
                    );
                  }),
                  // Markers for apartments
                  Obx(() {
                    return MarkerLayer(
                      markers: mapController.filteredMarkers.map((data) {
                        return Marker(
                          point: data['location'],
                          width: 60,
                          height: 60,
                          child: GestureDetector(
                            onTap: () =>
                                MapUtils.showApartmentDetails(context, data),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                  color: Colors.deepOrangeAccent
                                      .withValues(alpha: 120),
                                  border: Border.all(color: kSecondary2)),
                              child: const Icon(
                                Icons.house,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }),
                  // Marker for user's current location
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: currentLocation,
                        width: 60,
                        height: 60,
                        child: Icon(
                          Icons.person_pin_circle_rounded,
                          color: Colors.green,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
