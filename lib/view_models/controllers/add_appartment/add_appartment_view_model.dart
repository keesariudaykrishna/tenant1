// // ignore_for_file: no_leading_underscores_for_local_identifiers, unrelated_type_equality_checks
// import 'dart:convert';
// import 'dart:io';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:firebase_database/firebase_database.dart';
// import 'package:uuid/uuid.dart';
// import 'package:hive/hive.dart';
// import '../../../utils/utils.dart';

// class AddApartmentController extends GetxController {
//   //! Observable variables
//   var imageUrl = ''.obs;
//   var latitude = 0.0.obs;
//   var longitude = 0.0.obs;
//   var errorMessage = ''.obs;

//   //! Image state
//   final image = Rx<File?>(null);

//   //! Firebase Database reference
//   final DatabaseReference _database =
//       FirebaseDatabase.instance.ref('apartments');

//   //! Loading states
//   final _isLoading = false.obs;
//   bool get isLoading => _isLoading.value;
//   set setLoading(bool value) => _isLoading.value = value;

//   final _isLocationLoading = false.obs;
//   bool get isLocationLoading => _isLocationLoading.value;
//   set setLocationLoading(bool value) => _isLocationLoading.value = value;

//   //! Private flag for image picker
//   bool _isPickerActive = false;

//   @override
//   void onInit() {
//     super.onInit();
//     _getCurrentLocation();
//     uploadOfflineData();
//   }

//   //! Remove selected image
//   void removeImage() {
//     image.value = null;
//     imageUrl.value = '';
//   }

//   //! Pick image from gallery
//   Future<void> pickImage(BuildContext context) async {
//     if (_isPickerActive) return;
//     _isPickerActive = true;

//     final ImagePicker picker = ImagePicker();
//     try {
//       final XFile? pickedImage =
//           await picker.pickImage(source: ImageSource.gallery);
//       if (pickedImage != null) {
//         image.value = File(pickedImage.path);
//         update();
//       }
//     } catch (e) {
//       Utils().errorSnackBar('Error picking image: $e');
//     } finally {
//       _isPickerActive = false;
//     }
//   }

//   Future<String> uploadImageToCloudinary(File image) async {
//     final connectivity = await Connectivity().checkConnectivity();

//     if (connectivity == ConnectivityResult.none) {
//       // Offline: Save image locally and return empty URL
//       Utils().errorSnackBar('You are offline. Image will be uploaded later.');
//       return ''; // Return empty string to indicate offline state
//     }

//     try {
//       const String cloudName = "domauasc7";
//       const String uploadPreset = "upload";
//       final String cloudinaryUrl =
//           "https://api.cloudinary.com/v1_1/$cloudName/image/upload";

//       final request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl));
//       request.fields['upload_preset'] = uploadPreset;
//       request.files.add(await http.MultipartFile.fromPath('file', image.path));

//       final response = await request.send();
//       final responseData = await response.stream.bytesToString();
//       final Map<String, dynamic> data = jsonDecode(responseData);

//       if (response.statusCode == 200) {
//         return data['secure_url'];
//       } else {
//         throw Exception(data['error']['message']);
//       }
//     } catch (e) {
//       throw Exception('Failed to upload image: $e');
//     }
//   }

//   //! Get current location
//   Future<void> _getCurrentLocation() async {
//     try {
//       setLocationLoading = true;

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
//       errorMessage.value = e.toString();
//       Utils().errorSnackBar('Error fetching location: $e');
//     } finally {
//       setLocationLoading = false;
//     }
//   }

//   //! Save apartment locally when offline
//   Future<void> saveApartmentLocally({
//     required String description,
//     required String noBed,
//     required String noBath,
//     required String address,
//     required String roomType,
//     required String price,
//     required String houseNumber,
//     required String floor,
//     required String ownerName,
//     required String ownerPhone,
//     required String area,
//     required String livingRoom,
//     required double lag,
//     required double log,
//   }) async {
//     // final box = Hive.box<Map<String, dynamic>>('apartments');
//     final box = await Hive.openBox<Map<String, dynamic>>('apartments');

//     final apartment = {
//       'description': description,
//       'noBed': noBed,
//       'noBath': noBath,
//       'address': address,
//       'roomType': roomType,
//       'price': price,
//       'houseNumber': houseNumber,
//       'floor': floor,
//       'ownerName': ownerName,
//       'ownerPhone': ownerPhone,
//       'lag': longitude,
//       'log': longitude,
//       'area': area,
//       'livingRoom': livingRoom,
//       'imageUrl': image.value?.path ?? '',
//     };
//     await box.add(apartment);
//     Utils().doneSnackBar('Apartment saved locally. Will upload when online.');
//   }

//   //! Upload offline data
//   Future<void> uploadOfflineData() async {
//     // Open the Hive box for offline apartments
//     final box = await Hive.openBox<Map<dynamic, dynamic>>('apartments');

//     // Check for connectivity
//     final connectivity = await Connectivity().checkConnectivity();

//     // If offline, skip the upload process
//     if (connectivity == ConnectivityResult.none) {
//       Utils().errorSnackBar(
//           'No internet connection. Unable to upload offline data.');
//       return;
//     }

//     // Iterate through saved apartments and upload them to Firebase
//     if (box.isNotEmpty) {
//       for (var apartment in box.values) {
//         // Ensure apartment data is cast properly
//         final Map<String, dynamic> apartmentData =
//             apartment.cast<String, dynamic>();

//         // Retrieve the image path from local data
//         final imagePath = apartmentData['imageUrl'] ?? '';
//         String uploadedImageUrl = '';

//         // If an image exists, upload it to Cloudinary
//         if (imagePath.isNotEmpty) {
//           uploadedImageUrl = await uploadImageToCloudinary(File(imagePath));
//         }

//         // Add the apartment data to Firebase
//         await addApartment(
//           description: apartmentData['description'] ?? '',
//           noBed: apartmentData['noBed'] ?? '',
//           noBath: apartmentData['noBath'] ?? '',
//           address: apartmentData['address'] ?? '',
//           roomType: apartmentData['roomType'] ?? '',
//           price: apartmentData['price'] ?? '',
//           houseNumber: apartmentData['houseNumber'] ?? '',
//           floor: apartmentData['floor'] ?? '',
//           ownerName: apartmentData['ownerName'] ?? '',
//           ownerPhone: apartmentData['ownerPhone'] ?? '',
//           lag: apartmentData['lag'] ?? '',
//           log: apartmentData['log'] ?? '',
//           area: apartmentData['area'] ?? '',
//           livingRoom: apartmentData['livingRoom'] ?? '',
//           uploadedImageUrl: uploadedImageUrl,
//         );
//       }

//       // Clear the offline data after successful upload
//       await box.clear();
//       Utils().doneSnackBar('Offline apartments uploaded successfully.');
//     } else {
//       Utils().errorSnackBar('No offline data to upload.');
//     }
//   }

//   //! Add apartment to Firebase
//   Future<void> addApartment({
//     required String description,
//     required String noBed,
//     required String noBath,
//     required String address,
//     required String roomType,
//     required String price,
//     required String houseNumber,
//     required String floor,
//     required String ownerName,
//     required String ownerPhone,
//     required String area,
//     required String livingRoom,
//     required double lag,
//     required double log,
//     String? uploadedImageUrl,
//   }) async {
//     final uuid = Uuid().v4();
//     final DatabaseReference apartmentRef = _database.child(uuid);

//     try {
//       setLoading = true;

//       // Check if the image should be uploaded or not
//       if (uploadedImageUrl == null || uploadedImageUrl.isEmpty) {
//         if (image.value != null) {
//           uploadedImageUrl = await uploadImageToCloudinary(image.value!);
//         } else {
//           Utils().errorSnackBar('No image selected.');
//           setLoading = false;
//           return;
//         }
//       }

//       await apartmentRef.set({
//         'uuid': uuid,
//         'description': description,
//         'noBed': noBed,
//         'noBath': noBath,
//         'address': address,
//         'roomType': roomType,
//         'price': price,
//         'houseNumber': houseNumber,
//         'floor': floor,
//         'ownerName': ownerName,
//         'ownerPhone': ownerPhone,
//         'imageUrl': uploadedImageUrl,
//         'area': area,
//         'livingRoom': livingRoom,
//         'lag': lag,
//         'log': log,
//         'available': true,
//       });

//       Utils().doneSnackBar('Apartment added successfully.');
//     } catch (e) {
//       if (uploadedImageUrl == null || uploadedImageUrl.isEmpty) {
//         // Save locally for offline upload
//         await saveApartmentLocally(
//           description: description,
//           noBed: noBed,
//           noBath: noBath,
//           address: address,
//           roomType: roomType,
//           price: price,
//           houseNumber: houseNumber,
//           floor: floor,
//           lag: lag,
//           log: log,
//           ownerName: ownerName,
//           ownerPhone: ownerPhone,
//           area: area,
//           livingRoom: livingRoom,
//         );
//         Utils()
//             .doneSnackBar('Apartment saved locally. Will upload when online.');
//       } else {
//         Utils().errorSnackBar('Error adding apartment: $e');
//       }
//     } finally {
//       setLoading = false;
//     }
//   }

// //   //! Update apartment in Firebase database
//   Future<void> updateApartment(
//     String apartmentId, {
//     required String description,
//     required String noBed,
//     required String noBath,
//     required String address,
//     required String roomType,
//     required String price,
//     required String houseNumber,
//     required String floor,
//     required String ownerName,
//     required String ownerPhone,
//     required String area,
//     required String livingRoom,
//     File? newImage,
//     String? existingImageUrl,
//   }) async {
//     final DatabaseReference apartmentRef = _database.child(apartmentId);

//     try {
//       setLoading = true;

//       // Upload the new image to Cloudinary if a new image is selected
//       if (newImage != null) {
//         imageUrl.value = await uploadImageToCloudinary(newImage);
//       } else if (existingImageUrl != null) {
//         imageUrl.value = existingImageUrl; // Retain the existing image URL
//       } else {
//         Utils().errorSnackBar('No image selected or available!');
//         setLoading = false;
//         return;
//       }

//       // Update the apartment details in Firebase
//       await apartmentRef.update({
//         'description': description,
//         'noBed': noBed,
//         'noBath': noBath,
//         'address': address,
//         'roomType': roomType,
//         'price': price,
//         'houseNumber': houseNumber,
//         'floor': floor,
//         'ownerName': ownerName,
//         'ownerPhone': ownerPhone,
//         'imageUrl': imageUrl.value,
//         'area': area,
//         'livingRoom': livingRoom,
//       });

// ignore_for_file: unnecessary_nullable_for_final_variable_declarations, unrelated_type_equality_checks

//       setLoading = false;
//       // Utils().doneSnackBar('Apartment Updated Successfully');
//       // Get.back();
//     } catch (e) {
//       setLoading = false;
//       debugPrint(e.toString());
//       Utils().errorSnackBar('Error: $e');
//     }
//   }
// }
import 'dart:convert';
import 'dart:io';

import 'package:apartment_rentals/view_models/services/user_session.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

import '../../../utils/utils.dart';

class AddApartmentController extends GetxController {
  //! Observable variables
  var mediaUrls = <String>[].obs;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var errorMessage = ''.obs;

  //! Media state
  final mediaFiles = RxList<File>();

  //! Firebase Database reference
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref('apartments');

  //! Loading states
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set setLoading(bool value) => _isLoading.value = value;

  final _isLocationLoading = false.obs;
  bool get isLocationLoading => _isLocationLoading.value;
  set setLocationLoading(bool value) => _isLocationLoading.value = value;

  //! Private flag for media picker
  bool _isPickerActive = false;

  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation();
    uploadOfflineData();
  }

  //! Remove selected media
  void removeMedia(File file) {
    mediaFiles.remove(file);
  }

  //! Pick media (images and videos)
  Future<void> pickMedia(BuildContext context) async {
    if (_isPickerActive) return; // Prevent multiple pickers from opening
    _isPickerActive = true;

    final ImagePicker picker = ImagePicker();
    try {
      // Use showDialog to allow user to choose between images or videos
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Select Media Type'),
          content: Text('Would you like to pick images or videos?'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final List<XFile>? pickedImages = await picker.pickMultiImage();
                if (pickedImages != null) {
                  for (var image in pickedImages) {
                    mediaFiles.add(File(image.path));
                  }
                  update();
                }
              },
              child: Text('Images'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final XFile? pickedVideo = await picker.pickVideo(
                  source: ImageSource.gallery,
                );
                if (pickedVideo != null) {
                  final videoFile = File(pickedVideo.path);

                  // Validate video duration
                  final videoPlayerController =
                      VideoPlayerController.file(videoFile);
                  await videoPlayerController.initialize();
                  final duration = videoPlayerController.value.duration;
                  if (duration.inSeconds > 10) {
                    Utils().noteSnackBar(
                        'Please select a video shorter than 10 seconds.');
                  } else {
                    mediaFiles.add(videoFile);
                    update();
                  }
                  await videoPlayerController.dispose();
                }
              },
              child: Text('Videos'),
            ),
          ],
        ),
      );
    } catch (e) {
      debugPrint('Failed to upload media: $e');
      Utils().errorSnackBar(
          'Error picking media: $e'); // Show error if picking fails
    } finally {
      _isPickerActive = false; // Reset the flag
    }
  }

  //! Validate image file format
  Future<bool> _isValidImage(File file) async {
    final String fileExtension = file.path.split('.').last.toLowerCase();
    debugPrint("Checking file extension: $fileExtension");

    // Check if the file extension is one of the valid image formats
    if (['jpg', 'jpeg', 'png', 'gif'].contains(fileExtension)) {
      return true;
    } else {
      debugPrint("Invalid image file format: $fileExtension");
      return false;
    }
  }

  //! Upload media files to Cloudinary
  Future<List<String>> uploadMediaToCloudinary(List<File> mediaFiles) async {
    final connectivity = await Connectivity().checkConnectivity();

    if (connectivity == ConnectivityResult.none) {
      // Offline: Save media locally and return empty URLs
      Utils().errorSnackBar('You are offline. Media will be uploaded later.');
      return []; // Return empty list to indicate offline state
    }

    final List<String> uploadedUrls = [];

    try {
      const String cloudName = "domauasc7";
      const String uploadPreset = "upload";
      final String cloudinaryUrl =
          "https://api.cloudinary.com/v1_1/$cloudName/image/upload";

      for (var media in mediaFiles) {
        if (await _isValidImage(media)) {
          final request =
              http.MultipartRequest('POST', Uri.parse(cloudinaryUrl));
          request.fields['upload_preset'] = uploadPreset;
          request.files
              .add(await http.MultipartFile.fromPath('file', media.path));

          final response = await request.send();
          final responseData = await response.stream.bytesToString();
          final Map<String, dynamic> data = jsonDecode(responseData);

          if (response.statusCode == 200) {
            uploadedUrls.add(data['secure_url']);
          } else {
            debugPrint('Failed to upload media: ${data['error']['message']}');
            throw Exception(data['error']['message']);
          }
        } else {
          debugPrint("Skipping invalid image file: ${media.path}");
        }
      }
    } catch (e) {
      Utils().errorSnackBar('Failed to upload media: $e');
      debugPrint('Failed to upload media: $e');
      throw Exception('Failed to upload media: $e');
    }

    return uploadedUrls;
  }

  //! Get current location
  Future<void> _getCurrentLocation() async {
    try {
      setLocationLoading = true;

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
    } catch (e) {
      errorMessage.value = e.toString();
      Utils().errorSnackBar('Error fetching location: $e');
    } finally {
      setLocationLoading = false;
    }
  }

  //! Save apartment locally when offline
  Future<void> saveApartmentLocally({
    required String description,
    required String noBed,
    required String noBath,
    required String address,
    required String roomType,
    required String price,
    required String houseNumber,
    required String floor,
    required String ownerName,
    required String ownerPhone,
    required String area,
    required String livingRoom,
    required double lag,
    required double log,
  }) async {
    final box = await Hive.openBox<Map<String, dynamic>>('apartments');

    final apartment = {
      'description': description,
      'noBed': noBed,
      'noBath': noBath,
      'address': address,
      'roomType': roomType,
      'price': price,
      'houseNumber': houseNumber,
      'floor': floor,
      'ownerName': ownerName,
      'ownerPhone': ownerPhone,
      'lag': lag,
      'log': log,
      'area': area,
      'livingRoom': livingRoom,
      'mediaUrls': mediaFiles.map((file) => file.path).toList(),
    };

    await box.add(apartment);
    Utils().doneSnackBar('Apartment saved locally. Will upload when online.');
  }

  //! Upload offline data
  Future<void> uploadOfflineData() async {
    final box = await Hive.openBox<Map<dynamic, dynamic>>('apartments');
    final connectivity = await Connectivity().checkConnectivity();

    if (connectivity == ConnectivityResult.none) {
      Utils().errorSnackBar(
          'No internet connection. Unable to upload offline data.');
      return;
    }

    if (box.isNotEmpty) {
      for (var apartment in box.values) {
        final Map<String, dynamic> apartmentData =
            apartment.cast<String, dynamic>();

        final List<String> localMediaPaths =
            List<String>.from(apartmentData['mediaUrls'] ?? []);
        final List<String> uploadedUrls = await uploadMediaToCloudinary(
          localMediaPaths.map((path) => File(path)).toList(),
        );

        await addApartment(
          description: apartmentData['description'] ?? '',
          noBed: apartmentData['noBed'] ?? '',
          noBath: apartmentData['noBath'] ?? '',
          address: apartmentData['address'] ?? '',
          roomType: apartmentData['roomType'] ?? '',
          price: apartmentData['price'] ?? '',
          houseNumber: apartmentData['houseNumber'] ?? '',
          floor: apartmentData['floor'] ?? '',
          ownerName: apartmentData['ownerName'] ?? '',
          ownerPhone: apartmentData['ownerPhone'] ?? '',
          lag: apartmentData['lag'] ?? 0.0,
          log: apartmentData['log'] ?? 0.0,
          area: apartmentData['area'] ?? '',
          livingRoom: apartmentData['livingRoom'] ?? '',
          uploadedMediaUrls: uploadedUrls,
        );
      }

      await box.clear();
      Utils().doneSnackBar('Offline apartments uploaded successfully.');
    } else {
      Utils().errorSnackBar('No offline data to upload.');
    }
  }

  //! Add apartment to Firebase
  Future<void> addApartment({
    required String description,
    required String noBed,
    required String noBath,
    required String address,
    required String roomType,
    required String price,
    required String houseNumber,
    required String floor,
    required String ownerName,
    required String ownerPhone,
    required String area,
    required String livingRoom,
    required double lag,
    required double log,
    List<String>? uploadedMediaUrls,
  }) async {
    final uuid = Uuid().v4();
    final DatabaseReference apartmentRef = _database.child(uuid);

    try {
      setLoading = true;

      if (uploadedMediaUrls == null || uploadedMediaUrls.isEmpty) {
        if (mediaFiles.isNotEmpty) {
          uploadedMediaUrls = await uploadMediaToCloudinary(mediaFiles);
        } else {
          Utils().errorSnackBar('No media selected.');
          setLoading = false;
          return;
        }
      }

      await apartmentRef.set({
        'uuid': uuid,
        'userId': SessionController().userId,
        'description': description,
        'noBed': noBed,
        'noBath': noBath,
        'address': address,
        'roomType': roomType,
        'price': price,
        'houseNumber': houseNumber,
        'floor': floor,
        'ownerName': ownerName,
        'ownerPhone': ownerPhone,
        'mediaUrls': uploadedMediaUrls,
        'area': area,
        'livingRoom': livingRoom,
        'lag': lag,
        'log': log,
        'available': true,
      });

      Utils().doneSnackBar('Apartment added successfully.');
    } catch (e) {
      Utils().errorSnackBar('Error adding apartment: $e');
    } finally {
      setLoading = false;
    }
  }
}
