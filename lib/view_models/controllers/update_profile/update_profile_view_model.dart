// ignore_for_file: no_leading_underscores_for_local_identifiers, non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:apartment_rentals/view_models/services/user_session.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '../../../utils/utils.dart';

class UpdateProfileController extends GetxController {
  final _isLoading = false.obs; //! Loading indicator state
  final _selectedGender = Rx<String?>(null); //! Observable for gender selection
  final Rx<XFile?> _selectedImage =
      Rx<XFile?>(null); //! Observable for selected image

  bool get isLoading => _isLoading.value;

  set setLoading(val) {
    _isLoading.value = val;
  }

  String? get selectedGender => _selectedGender.value;
  XFile? get selectedImage => _selectedImage.value;

  //! Function to set the gender
  void setGender(String? gender) {
    if (gender == 'Male' || gender == 'Female') {
      _selectedGender.value = gender;
    } else {
      _selectedGender.value = null;
    }
  }

  //! Function to pick image from gallery
  Future<void> pickImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      _selectedImage.value = image;
      update(); //! Notify listeners to rebuild
    }
  }

  //! Upload selected image to Cloudinary and return the URL
  Future<String> uploadImageToCloudinary(XFile image) async {
    final String CLOUD_NAME = "domauasc7";
    final String cloudinaryUrl =
        "https://api.cloudinary.com/v1_1/$CLOUD_NAME/image/upload";
    const String uploadPreset = "upload";

    final request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl));
    request.fields['upload_preset'] = uploadPreset;
    request.files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();
    final responseData = await response.stream.toBytes();
    final result = String.fromCharCodes(responseData);

    //! Parse and get the URL of the uploaded image
    final Map<String, dynamic> responseDataMap = jsonDecode(result);
    return responseDataMap['secure_url'];
  }

  //! Function to update the profile in Firebase Realtime Database
  Future<void> updateProfile(
    String name,
    String email,
    String phone,
    String address,
    String gender,
    String? imageUrl,
  ) async {
    final DatabaseReference _database = FirebaseDatabase.instance
        .ref('user')
        .child(SessionController().userId.toString());

    try {
      setLoading = true;
      await _database.update({
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'gender': gender,
        'profilePic': imageUrl,
      });
      setLoading = false;
      Utils().doneSnackBar('Profile Updated');
    } catch (e) {
      setLoading = false;
      Utils().doneSnackBar('Error: $e');
    }
  }
}
