// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:io';
import 'package:apartment_rentals/res/app_widgets/app_bar.dart';
import 'package:apartment_rentals/res/app_widgets/button.dart';
import 'package:apartment_rentals/res/app_widgets/text_form_field.dart';
import 'package:apartment_rentals/res/colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../res/app_widgets/drop_down.dart';
import '../../view_models/controllers/update_profile/update_profile_view_model.dart';
import '../../view_models/services/user_session.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey =
      GlobalKey<FormState>(); // ! Global key for the form to validate inputs

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emialController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final List<String> genderList = [
    'Male',
    'Female'
  ]; // ! List of gender options for selection

  @override
  Widget build(BuildContext context) {
    final UpdateProfileController _controller =
        // ! Reference to Firebase database to fetch user data
        Get.put(UpdateProfileController());
    final ref = FirebaseDatabase.instance.ref('user');
    return Scaffold(
      appBar:
          // ! Custom app bar with the title
          MyAppBar(title: 'Update Profile'),
      backgroundColor: kPrimary,
      body: SingleChildScrollView(
        // ! Scrollable body to prevent overflow on small screens
        child: Padding(
          padding: EdgeInsets.all(12.h), // Padding for the body content
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center the contents vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center the contents horizontally
            spacing: 20,
            children: [
              StreamBuilder<DatabaseEvent>(
                // ! Stream to listen to changes in the user data from Firebase
                stream:
                    ref.child(SessionController().userId.toString()).onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child:
                            CircularProgressIndicator()); // ! Loading indicator while waiting for data
                  }

                  if (snapshot.hasError) {
                    return const Center(
                        child: Text('An error occurred while loading data.'));
                  }

                  final data =
                      snapshot.data?.snapshot.value as Map<dynamic, dynamic>?;

                  if (data == null) {
                    return const Center(child: Text('No data available.'));
                  }

                  // ! Set initial values to the controllers from the fetched data
                  nameController.text = data['name'];
                  emialController.text = data['email'];
                  phoneController.text = data['phone'];
                  addressController.text = data['address'];

                  _controller.setGender(data[
                      'gender']); // ! Set the gender field from fetched data

                  return Center(
                    child: Form(
                      key: _formKey, // ! Form key for validation
                      child: Column(
                        spacing: 20.h, // Space between elements
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20.h),
                          Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [
                              SizedBox(
                                height: 150.h,
                                width: 130.h,
                                child: Positioned(
                                  child: SizedBox(
                                    height: 100.h,
                                    width: 100.h,
                                    child: Obx(
                                      () => Container(
                                        height: 110
                                            .h, // Adjusted size for the border
                                        width: 110
                                            .h, // Adjusted size for the border
                                        decoration: BoxDecoration(
                                          shape: BoxShape
                                              .circle, // Circular border
                                          border: Border.all(
                                            color: kSecondary, // Border color
                                            width: 4.0, // Border width
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          // Reactive circle avatar with profile image
                                          radius: 55.h,
                                          backgroundImage: _controller
                                                      .selectedImage ==
                                                  null
                                              ? NetworkImage(data['profilePic'])
                                              : FileImage(File(_controller
                                                  .selectedImage!
                                                  .path)) as ImageProvider,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: ClipRRect(
                                  child: InkWell(
                                    onTap: () {
                                      _controller.pickImage(
                                          context); // Image picker when user taps on the avatar
                                    },
                                    child: Container(
                                      height: 25.h,
                                      width: 25.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)),
                                        color: Colors.black,
                                      ),
                                      child: Icon(
                                        Icons
                                            .add, // Icon to indicate image picking
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          // ! User input fields for Name, Email, Phone, and Address
                          MyField(
                            prefixIcon: Icon(Icons.person),
                            hintText: 'Name',
                            controller: nameController,
                            validatorText: 'Enter name',
                          ),
                          MyField(
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            controller: emialController,
                            validatorText: 'Enter Email address',
                          ),
                          MyField(
                            prefixIcon: Icon(Icons.phone),
                            hintText: 'Phone Number',
                            controller: phoneController,
                            validatorText: 'Enter Phone Number',
                          ),
                          MyField(
                            prefixIcon: Icon(Icons.location_on),
                            hintText: 'Address',
                            controller: addressController,
                            validatorText: 'Enter Address',
                          ),
                          MyDropdown(
                            // ! Gender selection dropdown
                            selectedItem: _controller.selectedGender,
                            items: genderList,
                            onChanged: (val) {
                              _controller.setGender(
                                  val); // ! Update the selected gender
                            },
                            hintText: 'Select Gender',
                            validaterText: 'Select Gender',
                          ),
                          SizedBox(height: 20.h),
                          Obx(
                            () => MyButton(
                              // ! Button to submit the form and update profile
                              isLoading: _controller
                                  .isLoading, // ! Show loading state while processing
                              onTap: () async {
                                String? imageUrl =
                                    data['profilePic']; // ! Default image URL
                                if (_controller.selectedImage != null) {
                                  imageUrl = await _controller
                                      .uploadImageToCloudinary(_controller
                                          .selectedImage!); // ! Upload image to Cloudinary if selected
                                }
                                // ! Update profile with new data
                                _controller.updateProfile(
                                  nameController.text,
                                  emialController.text,
                                  phoneController.text,
                                  addressController.text,
                                  _controller.selectedGender.toString(),
                                  imageUrl,
                                );
                              },
                              text: 'U P D A T E', // Button text
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
