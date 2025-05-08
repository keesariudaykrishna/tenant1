import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/utils.dart';

// class HomeController extends GetxController {
//   final RxList<Map<String, dynamic>> apartments = <Map<String, dynamic>>[].obs;
//   final RxList<Map<String, dynamic>> filteredApartments =
//       <Map<String, dynamic>>[].obs;
//   late Box<dynamic> apartmentBox; // Use dynamic for type flexibility
//   final RxString selectedType = ''.obs;
//   final RxString selectedBeds = ''.obs;
//   var userRole = ''.obs;

//   // Load userRole from SharedPreferences
//   Future<void> loadUserRole() async {
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     userRole.value =
//         sp.getString('userRole') ?? ''; // Default to empty string if not found
//   }

//   // Define house types as RxList for data binding
//   final RxList<String> houseTypesHome =
//       houseTypes2.obs; // Replace houseTypes2 with actual data
//   final RxList<String> houseTypesSearch =
//       houseTypes.obs; // Replace houseTypes with actual data

//   @override
//   void onInit() async {
//     super.onInit();
//     loadUserRole();

//     // Open Hive box for apartments
//     apartmentBox = await Hive.openBox('apartmentsBox');
//     fetchApartments();
//   }

//   void fetchApartments() async {
//     final DatabaseReference database =
//         FirebaseDatabase.instance.ref('apartments');

//     // Listen for Firebase database changes
//     database.onValue.listen((event) async {
//       final data = event.snapshot.value;

//       if (data is Map<dynamic, dynamic>) {
//         apartments.clear(); // Clear existing list

//         data.forEach((key, value) {
//           if (value is Map<dynamic, dynamic>) {
//             try {
//               // Convert Firebase data to Map<String, dynamic>
//               final apartment = Map<String, dynamic>.from(value);

//               // Check if the apartment is available before adding it
//               if (apartment['available'] == true) {
//                 apartments.add(apartment);

//                 // Store in Hive
//                 apartmentBox.put(key, apartment);
//               }
//             } catch (e) {
//               debugPrint("Error converting Firebase data: $e");
//             }
//           }
//         });

//         // Update filtered apartments
//         filteredApartments.value = List<Map<String, dynamic>>.from(apartments);
//       }
//     });

//     // Load cached apartments from Hive for offline use
//     loadCachedApartments();
//   }

//   void loadCachedApartments() {
//     apartments.clear(); // Clear the list before adding cached data

//     // Iterate over Hive box values and safely convert them
//     for (var item in apartmentBox.values) {
//       try {
//         if (item is Map<dynamic, dynamic>) {
//           apartments.add(Map<String, dynamic>.from(item));
//         } else if (item is Map<String, dynamic>) {
//           apartments.add(item);
//         } else {
//           debugPrint("Unexpected cached data format: $item");
//         }
//       } catch (e) {
//         debugPrint("Error processing cached apartment: $e");
//       }
//     }

//     // Update filtered apartments
//     filteredApartments.value = List<Map<String, dynamic>>.from(apartments);
//   }

//   //! Filter apartments by type
//   void filterByType(String type) {
//     if (selectedType.value == type) {
//       selectedType.value = '';
//       filteredApartments.value = List<Map<String, dynamic>>.from(apartments);
//     } else {
//       selectedType.value = type;
//       filteredApartments.value = apartments
//           .where((apartment) =>
//               apartment['roomType'] == selectedType.value &&
//               apartment['available'] == true)
//           .toList();
//     }
//   }

//   //! Search apartments by query (address or description)
//   void searchApartmentsByQuery(String query) {
//     String searchLowerQuery = query.toLowerCase();

//     if (query.isEmpty) {
//       filteredApartments.value = selectedType.isEmpty
//           ? List<Map<String, dynamic>>.from(apartments)
//           : apartments
//               .where((apartment) => apartment['roomType'] == selectedType.value)
//               .toList();
//     } else {
//       filteredApartments.value = apartments.where((apartment) {
//         final matchesType =
//             selectedType.isEmpty || apartment['roomType'] == selectedType.value;
//         final matchesQuery = (apartment['description'] ?? '')
//                 .toLowerCase()
//                 .contains(searchLowerQuery) ||
//             (apartment['address'] ?? '')
//                 .toLowerCase()
//                 .contains(searchLowerQuery);
//         return matchesType && matchesQuery;
//       }).toList();
//     }
//   }

//   //! search with multiple parameters
//   void searchApartments(
//     String searchQuery,
//     String minPrice,
//     String maxPrice,
//     String location,
//     String roomType,
//     String numberOfBeds,
//   ) {
//     double? min = double.tryParse(minPrice);
//     double? max = double.tryParse(maxPrice);
//     String searchLowerQuery = searchQuery.toLowerCase();
//     String searchLocation = location.toLowerCase();

//     filteredApartments.value = apartments.where((apartment) {
//       bool matchesPrice = true;
//       bool matchesLocation = true;
//       bool matchesQuery = true;
//       bool matchesRoomType = true;
//       bool matchesNumberOfBeds = true;

//       //! Price range filter
//       double apartmentPrice =
//           double.tryParse(apartment['price'].toString()) ?? 0.0;
//       if (min != null && apartmentPrice < min) matchesPrice = false;
//       if (max != null && apartmentPrice > max) matchesPrice = false;

//       // Location filter
//       if (location.isNotEmpty &&
//           !(apartment['address'] ?? '')
//               .toLowerCase()
//               .contains(searchLocation)) {
//         matchesLocation = false;
//       }

//       // General query filter
//       if (searchQuery.isNotEmpty &&
//           !(apartment['description'] ?? '')
//               .toLowerCase()
//               .contains(searchLowerQuery) &&
//           !(apartment['address'] ?? '')
//               .toLowerCase()
//               .contains(searchLowerQuery)) {
//         matchesQuery = false;
//       }

//       // Room type filter
//       if (roomType.isNotEmpty && apartment['roomType'] != roomType) {
//         matchesRoomType = false;
//       }

//       // Number of beds filter
//       if (numberOfBeds.isNotEmpty) {
//         int apartmentBeds = int.tryParse(apartment['noBed'].toString()) ?? 0;
//         if (numberOfBeds == '6+' && apartmentBeds < 6) {
//           matchesNumberOfBeds = false;
//         }
//         if (numberOfBeds != '6+' && apartmentBeds != int.parse(numberOfBeds)) {
//           matchesNumberOfBeds = false;
//         }
//       }

//       // Final check for availability
//       return matchesPrice &&
//           matchesLocation &&
//           matchesQuery &&
//           matchesRoomType &&
//           matchesNumberOfBeds;
//       // &&
//       // apartment['available'] == true; // Ensure the apartment is available
//     }).toList();
//   }
// }

class HomeController extends GetxController {
  final RxList<Map<String, dynamic>> apartments = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> filteredApartments =
      <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs; // Flag to indicate loading status
  final int fetchLimit = 4; // Number of apartments to load per batch
  int offset = 0; // Keeps track of the offset for pagination

  late Box<dynamic> apartmentBox;
  final RxString selectedType = ''.obs;
  final RxString selectedBeds = ''.obs;
  var userRole = ''.obs;
  // Define house types as RxList for data binding
  final RxList<String> houseTypesHome =
      houseTypes2.obs; // Replace houseTypes2 with actual data
  final RxList<String> houseTypesSearch =
      houseTypes.obs; // Replace houseTypes with actual data

  Future<void> loadUserRole() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    userRole.value = sp.getString('userRole') ?? '';
  }

  final RxInt currentPage = 1.obs; // Track current page
  final int recordsPerPage = 4; // Number of records to fetch per page

  // Your other variables like selectedType, selectedBeds, etc.

  void loadMoreApartments() async {
    if (isLoading.value) {
      return; // Prevent loading if data is already being fetched
    }

    isLoading.value = true;
    debugPrint("Loading page: ${currentPage.value}");

    // Fetch the next batch of apartments for the current page
    final newApartments = await fetchApartmentsForPage(currentPage.value);

    // Add the fetched apartments to the list
    filteredApartments.addAll(newApartments);

    debugPrint("Apartments after loading more: ${filteredApartments.length}");

    // Increment the current page for the next load
    currentPage.value++;

    isLoading.value = false;
  }

  Future<List<Map<String, dynamic>>> fetchApartmentsForPage(int page) async {
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay

    // Determine the start and end index for the current page
    int startIndex = (page - 1) * recordsPerPage;
    int endIndex = startIndex + recordsPerPage;

    // Return a sublist based on the current page
    return apartments.sublist(startIndex,
        endIndex > apartments.length ? apartments.length : endIndex);
  }

  @override
  void onInit() async {
    super.onInit();
    loadUserRole();
    apartmentBox = await Hive.openBox('apartmentsBox');
    fetchApartments();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      filteredApartments.value = List<Map<String, dynamic>>.from(apartments);
    });
  }

  void fetchApartments() async {
    final DatabaseReference database =
        FirebaseDatabase.instance.ref('apartments');
    isLoading.value = true;

    database.onValue.listen((event) async {
      final data = event.snapshot.value;

      if (data is Map<dynamic, dynamic>) {
        apartments.clear();
        data.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            try {
              final apartment = Map<String, dynamic>.from(value);

              if (apartment['available'] == true) {
                apartments.add(apartment);
                apartmentBox.put(key, apartment);
              }
            } catch (e) {
              debugPrint("Error converting Firebase data: $e");
            }
          }
        });
        filteredApartments.value = List<Map<String, dynamic>>.from(apartments);
        isLoading.value = false;
      }
    });
    loadCachedApartments();
  }

  void loadCachedApartments() {
    apartments.clear(); // Clear the list before adding cached data

    // Iterate over Hive box values and safely convert them
    for (var item in apartmentBox.values) {
      try {
        if (item is Map<dynamic, dynamic>) {
          apartments.add(Map<String, dynamic>.from(item));
        } else if (item is Map<String, dynamic>) {
          apartments.add(item);
        } else {
          debugPrint("Unexpected cached data format: $item");
        }
      } catch (e) {
        debugPrint("Error processing cached apartment: $e");
      }
    }

    // Update filtered apartments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      filteredApartments.value = List<Map<String, dynamic>>.from(apartments);
    });

    // Print out how many apartments were loaded from cache
    debugPrint("Total apartments loaded from cache: ${apartments.length}");
  }

  void loadMoreApartments2() async {
    if (isLoading.value) {
      return; // Prevent loading if data is already being fetched
    }

    isLoading.value = true;
    debugPrint("Apartments before loading more: ${filteredApartments.length}");

    // Simulate a delay to fetch the next batch of apartments
    final newApartments = await fetchNextBatchOfApartments();

    // Add the new apartments to the list
    filteredApartments.addAll(newApartments);

    debugPrint("Apartments after loading more: ${filteredApartments.length}");

    // Set isLoading to false when data loading is complete
    isLoading.value = false;
  }

  Future<List<Map<String, dynamic>>> fetchNextBatchOfApartments() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay

    // Return a mock list of apartments (this should be replaced with your actual fetching logic)
    return apartments.sublist(
        0, 4); // Just for demonstration, return next 4 apartments
  }

  void filterByType(String type) {
    if (selectedType.value == type) {
      selectedType.value = '';
      filteredApartments.value = List<Map<String, dynamic>>.from(apartments);
    } else {
      selectedType.value = type;
      filteredApartments.value = apartments
          .where((apartment) =>
              apartment['roomType'] == selectedType.value &&
              apartment['available'] == true)
          .toList();
    }
  }

  void searchApartmentsByQuery(String query) {
    String searchLowerQuery = query.toLowerCase();

    if (query.isEmpty) {
      filteredApartments.value = selectedType.isEmpty
          ? List<Map<String, dynamic>>.from(apartments)
          : apartments
              .where((apartment) => apartment['roomType'] == selectedType.value)
              .toList();
    } else {
      filteredApartments.value = apartments.where((apartment) {
        final matchesType =
            selectedType.isEmpty || apartment['roomType'] == selectedType.value;
        final matchesQuery = (apartment['description'] ?? '')
                .toLowerCase()
                .contains(searchLowerQuery) ||
            (apartment['address'] ?? '')
                .toLowerCase()
                .contains(searchLowerQuery);
        return matchesType && matchesQuery;
      }).toList();
    }
  }

  //! search with multiple parameters
  void searchApartments(
    String searchQuery,
    String minPrice,
    String maxPrice,
    String location,
    String roomType,
    String numberOfBeds,
  ) {
    double? min = double.tryParse(minPrice);
    double? max = double.tryParse(maxPrice);
    String searchLowerQuery = searchQuery.toLowerCase();
    String searchLocation = location.toLowerCase();

    filteredApartments.value = apartments.where((apartment) {
      bool matchesPrice = true;
      bool matchesLocation = true;
      bool matchesQuery = true;
      bool matchesRoomType = true;
      bool matchesNumberOfBeds = true;

      //! Price range filter
      double apartmentPrice =
          double.tryParse(apartment['price'].toString()) ?? 0.0;
      if (min != null && apartmentPrice < min) matchesPrice = false;
      if (max != null && apartmentPrice > max) matchesPrice = false;

      // Location filter
      if (location.isNotEmpty &&
          !(apartment['address'] ?? '')
              .toLowerCase()
              .contains(searchLocation)) {
        matchesLocation = false;
      }

      // General query filter
      if (searchQuery.isNotEmpty &&
          !(apartment['description'] ?? '')
              .toLowerCase()
              .contains(searchLowerQuery) &&
          !(apartment['address'] ?? '')
              .toLowerCase()
              .contains(searchLowerQuery)) {
        matchesQuery = false;
      }

      // Room type filter
      if (roomType.isNotEmpty && apartment['roomType'] != roomType) {
        matchesRoomType = false;
      }

      // Number of beds filter
      if (numberOfBeds.isNotEmpty) {
        int apartmentBeds = int.tryParse(apartment['noBed'].toString()) ?? 0;
        if (numberOfBeds == '6+' && apartmentBeds < 6) {
          matchesNumberOfBeds = false;
        }
        if (numberOfBeds != '6+' && apartmentBeds != int.parse(numberOfBeds)) {
          matchesNumberOfBeds = false;
        }
      }

      // Final check for availability
      return matchesPrice &&
          matchesLocation &&
          matchesQuery &&
          matchesRoomType &&
          matchesNumberOfBeds;
      // &&
      // apartment['available'] == true; // Ensure the apartment is available
    }).toList();
  }
}
