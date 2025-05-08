// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:latlong2/latlong.dart';

// import '../../../utils/utils.dart';

// class MapsController extends GetxController {
//   var isLoading = false.obs;
//   var markers = <LatLng>[].obs;
//   Map<String, dynamic> data = {};
//   final DatabaseReference _databaseRef =
//       FirebaseDatabase.instance.ref("apartments");

//   var latitude = 31.2800.obs;
//   var longitude = 74.19000.obs;
//   Future<void> getCurrentLocation() async {
//     try {
//       if (!await Geolocator.isLocationServiceEnabled()) {
//         throw Exception("Location services are disabled.");
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           throw Exception("Location permissions are denied.");
//         }
//       }
//       if (permission == LocationPermission.deniedForever) {
//         throw Exception("Location permissions are permanently denied.");
//       }

//       final Position position = await Geolocator.getCurrentPosition(
//         locationSettings:
//             const LocationSettings(accuracy: LocationAccuracy.high),
//       );

//       latitude.value = position.latitude;
//       longitude.value = position.longitude;
//     } catch (e) {
//       Utils().errorSnackBar('Error fetching location: $e');
//     } finally {}
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     fetchApartments();
//     // print('length:${markers.length} and  :maker data$markers');
//   }

//   // Future<void> fetchApartments() async {
//   //   try {
//   //     isLoading.value = true;

//   //     DataSnapshot snapshot = await _databaseRef.get();
//   //     if (snapshot.exists) {
//   //       List<LatLng> locations = [];
//   //       for (var child in snapshot.children) {
//   //         data = Map<String, dynamic>.from(child.value as Map);

//   //         // Ensure that the latitude and longitude are doubles
//   //         double? lat = data['lag'] != null
//   //             ? double.tryParse(data['lag'].toString())
//   //             : null;
//   //         double? log = data['log'] != null
//   //             ? double.tryParse(data['log'].toString())
//   //             : null;

//   //         if (lat != null && log != null) {
//   //           locations.add(LatLng(lat, log));
//   //         }
//   //       }
//   //       markers.assignAll(locations);
//   //       // print(markers);
//   //     } else {
//   //       Get.snackbar('Error', 'No data found in the database.');
//   //     }
//   //   } catch (e) {
//   //     debugPrint(e.toString());
//   //     Get.snackbar('Error', 'Failed to fetch apartments: $e');
//   //   } finally {
//   //     isLoading.value = false;
//   //   }
//   // }
//   Future<void> fetchApartments() async {
//     try {
//       isLoading.value = true;

//       DataSnapshot snapshot = await _databaseRef.get();
//       if (snapshot.exists) {
//         print(
//             "Raw Data: ${snapshot.value}"); // Print the raw data from Firebase

//         List<LatLng> locations = [];
//         for (var child in snapshot.children) {
//           Map<String, dynamic> data =
//               Map<String, dynamic>.from(child.value as Map);

//           // Debugging: Print lag and log values as strings
//           print("Raw Lag: ${data['lag']}, Raw Log: ${data['log']}");

//           // Make sure 'lag' and 'log' are in the correct order (latitude, longitude)
//           double? lat = data['lag'] != null
//               ? double.tryParse(data['lag'].toString())
//               : null;
//           double? log = data['log'] != null
//               ? double.tryParse(data['log'].toString())
//               : null;

//           // Debugging: Print parsed lag and log values
//           print("Parsed Lag: $lat, Parsed Log: $log");

//           // If valid, add LatLng to locations
//           if (lat != null && log != null) {
//             locations.add(LatLng(lat, log));
//           }
//         }

//         // Print the locations list after adding to the list
//         print("Locations after adding to list: $locations");

//         markers.assignAll(
//             locations); // Assign the final list of markers to the observable list
//       } else {
//         Get.snackbar('Error', 'No data found in the database.');
//       }
//     } catch (e) {
//       debugPrint(e.toString());
//       Get.snackbar('Error', 'Failed to fetch apartments: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Map<String, dynamic> getHouseDetails(LatLng location) {
//     // You would probably fetch this data from Firebase or another source.
//     // For now, we're using a hardcoded example.

//     return {
//       'imageUrl': 'https://example.com/house_image.jpg',
//       'price': '300,000',
//       'description': 'A beautiful 3-bedroom house in the city center.',
//     };
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:latlong2/latlong.dart';
// import '../../../utils/utils.dart';

// class MapsController extends GetxController {
//   var isLoading = false.obs;
//   var markers = <Map<dynamic, dynamic>>[].obs;
//   final DatabaseReference _databaseRef =
//       FirebaseDatabase.instance.ref("apartments");

//   var latitude = 31.2800.obs; // Default latitude value
//   var longitude = 74.19000.obs; // Default longitude value

//   Future<void> getCurrentLocation() async {
//     try {
//       if (!await Geolocator.isLocationServiceEnabled()) {
//         throw Exception("Location services are disabled.");
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           throw Exception("Location permissions are denied.");
//         }
//       }
//       if (permission == LocationPermission.deniedForever) {
//         throw Exception("Location permissions are permanently denied.");
//       }

//       final Position position = await Geolocator.getCurrentPosition(
//         locationSettings:
//             const LocationSettings(accuracy: LocationAccuracy.high),
//       );

//       latitude.value = position.latitude;
//       longitude.value = position.longitude;
//     } catch (e) {
//       Utils().errorSnackBar('Error fetching location: $e');
//     }
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     fetchApartments();
//   }

//   Future<void> fetchApartments() async {
//     try {
//       isLoading.value = true;

//       DataSnapshot snapshot = await _databaseRef.get();
//       if (snapshot.exists) {
//         List<Map<String, dynamic>> locations = [];
//         for (var child in snapshot.children) {
//           Map<String, dynamic> data =
//               Map<String, dynamic>.from(child.value as Map);

//           double? lat = data['lag'] != null
//               ? double.tryParse(data['lag'].toString())
//               : null;
//           double? log = data['log'] != null
//               ? double.tryParse(data['log'].toString())
//               : null;

//           if (lat != null && log != null) {
//             locations.add({
//               'location': LatLng(lat, log),
//               'uuid': data['uuid'],
//               'price': data['price'],
//               'address': data['address'],
//               'description': data['description'],
//             });
//           }
//         }
//         markers.assignAll(locations);
//       } else {
//         Get.snackbar('Error', 'No data found in the database.');
//       }
//     } catch (e) {
//       debugPrint(e.toString());
//       Get.snackbar('Error', 'Failed to fetch apartments: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:latlong2/latlong.dart';
import '../../../utils/utils.dart';

class MapsController extends GetxController {
  var isLoading = false.obs;
  var allMarkers = <Map<String, dynamic>>[].obs; // All markers
  var filteredMarkers = <Map<String, dynamic>>[].obs; // Markers within radius
  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref("apartments");

  var latitude = 31.2800.obs; // Default latitude value
  var longitude = 74.19000.obs; // Default longitude value
  var currentRadius = 500.0.obs; // Current search radius in meters
  final double maxRadius = 10000.0; // Maximum search radius (10km)
  final double radiusIncrement = 500.0; // Incremental radius increase
  var filterRadius = 500.0.obs; // Radius controlled by the slider

  final Distance _distanceCalculator = const Distance(); // Distance helper

  var showAllApartments =
      false.obs; // Flag to track if user wants to show all apartments

  @override
  void onInit() {
    super.onInit();
    fetchApartments();
  }

  void updateFilterRadius(double radius) {
    filterRadius.value = radius;
    filterMarkersByRadius(); // Reapply filtering whenever the radius changes
  }

  Future<void> getCurrentLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw Exception("Location services are disabled.");
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permissions are denied.");
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permissions are permanently denied.");
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high),
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;

      // Filter markers after updating location
      searchForApartments();
    } catch (e) {
      Utils().errorSnackBar('Error fetching location: $e');
    }
  }

  Future<void> fetchApartments() async {
    try {
      isLoading.value = true;

      DataSnapshot snapshot = await _databaseRef.get();
      if (snapshot.exists) {
        List<Map<String, dynamic>> locations = [];
        for (var child in snapshot.children) {
          Map<String, dynamic> data =
              Map<String, dynamic>.from(child.value as Map);

          double? lat = data['lag'] != null
              ? double.tryParse(data['lag'].toString())
              : null;
          double? log = data['log'] != null
              ? double.tryParse(data['log'].toString())
              : null;

          if (lat != null && log != null) {
            locations.add({
              'location': LatLng(lat, log),
              'uuid': data['uuid'],
              'imageUrl': data['imageUrl'],
              'address': data['address'],
              'floor': data['floor'],
            });
          }
        }
        allMarkers.assignAll(locations);

        // Apply filtering based on current location
        searchForApartments();
      } else {
        Get.snackbar('Error', 'No data found in the database.');
      }
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar('Error', 'Failed to fetch apartments: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void searchForApartments() {
    // Start with the initial radius
    currentRadius.value = 500.0;
    filterMarkersByRadius();
  }

  void filterMarkersByRadius() {
    final LatLng currentLocation = LatLng(latitude.value, longitude.value);

    // Filter markers within the current radius
    final List<Map<String, dynamic>> filtered = allMarkers.where((marker) {
      final double distance = _distanceCalculator.as(
        LengthUnit.Meter,
        currentLocation,
        marker['location'], // Apartment location
      );
      return distance <= currentRadius.value; // Keep markers within the radius
    }).toList();

    if (filtered.isNotEmpty || currentRadius.value >= 10000) {
      // If apartments are found or the max radius (10km) is reached
      filteredMarkers.assignAll(filtered);
    } else {
      // If no apartments are found, increase the radius
      currentRadius.value += radiusIncrement;

      // If radius reaches 10km and no apartments are found, show no markers
      if (currentRadius.value > 10000) {
        filteredMarkers.assignAll([]); // No apartments within 10km
      } else {
        filterMarkersByRadius(); // Continue filtering with a larger radius
      }
    }
  }

  // Toggle the flag to show all apartments
  void toggleShowAllApartments(bool value) {
    showAllApartments.value = value;
    if (value) {
      filteredMarkers.assignAll(allMarkers);
    } else {
      filterMarkersByRadius(); // Apply radius-based filtering
    }
  }
}
