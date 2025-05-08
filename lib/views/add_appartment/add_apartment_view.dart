// // ignore_for_file: no_leading_underscores_for_local_identifiers

// import 'package:apartment_rentals/res/app_widgets/app_bar.dart';
// import 'package:apartment_rentals/res/colors.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../res/app_widgets/button.dart';
// import '../../../res/app_widgets/text_form_field.dart';
// import '../../res/app_widgets/drop_down.dart';
// import '../../utils/utils.dart';
// import '../../view_models/controllers/add_appartment/add_appartment_view_model.dart';
// import 'widgets/image_container.dart';

// class AddAppartmentScreen extends StatefulWidget {
//   const AddAppartmentScreen({super.key});

//   @override
//   State<AddAppartmentScreen> createState() => _AddAppartmentScreenState();
// }

// class _AddAppartmentScreenState extends State<AddAppartmentScreen> {
//   final AddApartmentController controller = Get.put(AddApartmentController());

//   // TextEditingControllers to manage input fields
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController noBedController = TextEditingController();
//   final TextEditingController noBathController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController priceController = TextEditingController();
//   final TextEditingController housenoController = TextEditingController();
//   final TextEditingController floorController = TextEditingController();
//   final TextEditingController ownerNameController = TextEditingController();
//   final TextEditingController ownerPhoneController = TextEditingController();
//   final TextEditingController areaController = TextEditingController();
//   final TextEditingController livingRoomController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   String? selectedType = houseTypes[0]; // Dropdown selection for apartment type

//   @override
//   void dispose() {
//     // Dispose of the controllers when the widget is disposed
//     descriptionController.dispose();
//     noBedController.dispose();
//     noBathController.dispose();
//     addressController.dispose();
//     priceController.dispose();
//     areaController.dispose();
//     livingRoomController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: MyAppBar(title: 'Add Apartment'),
//         backgroundColor: kPrimary,
//         body: Obx(
//           () {
//             if (controller.isLocationLoading) {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else if (controller.errorMessage.isNotEmpty) {
//               return Center(
//                 child: Text("Error: ${controller.errorMessage}"),
//               );
//             } else {
//               return SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       spacing: 20,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         TextButton(
//                             onPressed: () {
//                               if (kDebugMode) {
//                                 print(
//                                     'latitude: ${controller.latitude} & longitude: ${controller.longitude}');
//                               }
//                             },
//                             child: Text('Print Location')),

//                         InkWell(
//                           onTap: () async {
//                             await controller
//                                 .pickImage(context); // Trigger image picking
//                           },
//                           child: ImageContainer(), // Display the selected image
//                         ),

//                         SizedBox(height: 16),

//                         //! Description field
//                         MyField(
//                           maxLines: 5,
//                           prefixIcon: Icon(Icons.description),
//                           controller: descriptionController,
//                           hintText: 'Description',
//                           validatorText: 'Enter a description',
//                         ),

//                         //! Number of Bedrooms field
//                         MyField(
//                           prefixIcon: Icon(Icons.bed),
//                           controller: noBedController,
//                           hintText: 'Number of Bedrooms',
//                           textInputType: TextInputType.number,
//                           validatorText: 'Enter number of bedrooms',
//                         ),

//                         //! Number of Bathrooms field
//                         MyField(
//                           prefixIcon: Icon(Icons.bathroom),
//                           controller: noBathController,
//                           textInputType: TextInputType.number,
//                           hintText: 'Number of Bathrooms',
//                           validatorText: 'Enter number of bathrooms',
//                         ),
//                         //! Number of Living Room field
//                         MyField(
//                           prefixIcon: Icon(Icons.weekend),
//                           controller: livingRoomController,
//                           textInputType: TextInputType.number,
//                           hintText: 'Number of living room',
//                           validatorText: 'Enter number of living room',
//                         ),
//                         //! Area in Square fit
//                         MyField(
//                           prefixIcon: Icon(Icons.square_foot),
//                           controller: areaController,
//                           textInputType: TextInputType.number,
//                           hintText: 'Area in Square fit',
//                           validatorText: 'Enter Area in Square fit',
//                         ),

//                         //! Address field
//                         MyField(
//                           prefixIcon: Icon(Icons.location_on),
//                           controller: addressController,
//                           hintText: 'Address',
//                           validatorText: 'Enter an address',
//                         ),

//                         //! Apartment Type Dropdown
//                         MyDropdown(
//                           prefixIcon: Icon(Icons.roofing_outlined),
//                           selectedItem: selectedType,
//                           items: houseTypes,
//                           onChanged: (String? value) {
//                             setState(() {
//                               selectedType = value!; // Update selected type
//                             });
//                           },
//                           hintText: 'Select Apartment Type',
//                           validaterText: 'Please select an option',
//                         ),

//                         //! House No field
//                         MyField(
//                           prefixIcon: Icon(Icons.house_rounded),
//                           controller: housenoController,
//                           textInputType: TextInputType.number,
//                           hintText: 'House No',
//                           validatorText: 'Enter House No',
//                         ),

//                         //! Floor field
//                         MyField(
//                           prefixIcon: Icon(Icons.business),
//                           controller: floorController,
//                           textInputType: TextInputType.number,
//                           hintText: 'Floor No',
//                           validatorText: 'Enter Floor No',
//                         ),

//                         //! Owner name field
//                         MyField(
//                           prefixIcon: Icon(Icons.person_2_sharp),
//                           controller: ownerNameController,
//                           hintText: 'Owner name',
//                           validatorText: 'Enter Owner name',
//                         ),

//                         //! Owner phone field
//                         MyField(
//                           prefixIcon: Icon(Icons.phone_in_talk_rounded),
//                           controller: ownerPhoneController,
//                           hintText: 'Owner phone number',
//                           textInputType: TextInputType.phone,
//                           validatorText: 'Enter Owner phone number',
//                           onValidator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter a phone number';
//                             }
//                             if (value.length != 12) {
//                               return 'Phone number must be 12 digits';
//                             }
//                             return null;
//                           },
//                         ),

//                         //! Price field
//                         MyField(
//                           prefixIcon: Icon(Icons.price_change_rounded),
//                           controller: priceController,
//                           textInputType: TextInputType.number,
//                           hintText: 'Price',
//                           validatorText: 'Enter Price of House',
//                         ),

//                         SizedBox(height: 16),

//                         //! Add Apartment Button
//                         Obx(
//                           () => MyButton(
//                             isLoading: controller.isLoading,
//                             text: 'Add Apartment',
//                             onTap: () async {
//                               // Validate the form
//                               if (_formKey.currentState!.validate()) {
//                                 // Check if an image has been selected
//                                 if (controller.image.value != null) {
//                                   // If no image selected, proceed with the default image URL
//                                   await controller
//                                       .addApartment(
//                                           description:
//                                               descriptionController.text.trim(),
//                                           noBed: noBedController.text,
//                                           noBath: noBathController.text,
//                                           address: addressController.text,
//                                           roomType:
//                                               selectedType.toString().trim(),
//                                           price: priceController.text,
//                                           houseNumber: housenoController.text,
//                                           floor: floorController.text,
//                                           ownerName: ownerNameController.text,
//                                           ownerPhone: ownerPhoneController.text,
//                                           uploadedImageUrl:
//                                               controller.imageUrl.value,
//                                           lag: controller.latitude.value,
//                                           log: controller.longitude.value,
//                                           area: areaController.text,
//                                           livingRoom: livingRoomController.text)
//                                       .then(
//                                     (value) {
//                                       // Reset the form
//                                       controller.removeImage();
//                                       descriptionController.clear();
//                                       noBedController.clear();
//                                       noBathController.clear();
//                                       addressController.clear();
//                                       selectedType = houseTypes[0];
//                                       priceController.clear();
//                                       housenoController.clear();
//                                       floorController.clear();
//                                       ownerNameController.clear();
//                                       ownerPhoneController.clear();
//                                     },
//                                   );
//                                 } else {
//                                   // Show a message if the image is not selected
//                                   Get.snackbar(
//                                       'Error', 'Please select an image.');
//                                 }
//                               }
//                             },
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             }
//           },
//         ));
//   }
// }

// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../res/app_widgets/app_bar.dart';
import '../../../res/colors.dart';
import '../../../res/app_widgets/drop_down.dart';
import '../../../res/app_widgets/text_form_field.dart';
import '../../utils/utils.dart';
import '../../view_models/controllers/add_appartment/add_appartment_view_model.dart';

class AddAppartmentScreen extends StatefulWidget {
  const AddAppartmentScreen({super.key});

  @override
  State<AddAppartmentScreen> createState() => _AddAppartmentScreenState();
}

class _AddAppartmentScreenState extends State<AddAppartmentScreen> {
  final AddApartmentController controller = Get.put(AddApartmentController());

  // TextEditingControllers to manage input fields
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController noBedController = TextEditingController();
  final TextEditingController noBathController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController housenoController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController ownerPhoneController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController livingRoomController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? selectedType = houseTypes[0]; // Dropdown selection for apartment type

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    descriptionController.dispose();
    noBedController.dispose();
    noBathController.dispose();
    addressController.dispose();
    priceController.dispose();
    areaController.dispose();
    livingRoomController.dispose();
    super.dispose();
  }

  Future<VideoPlayerController> _initializeVideo(File videoFile) async {
    final videoPlayerController = VideoPlayerController.file(videoFile);
    await videoPlayerController.initialize();
    return videoPlayerController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Add Apartment'),
      backgroundColor: kPrimary,
      body: Obx(() {
        if (controller.isLocationLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text("Error: ${controller.errorMessage}"));
        } else {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {
                        debugPrint(
                            'latitude: ${controller.latitude} & longitude: ${controller.longitude}');
                      },
                      child: const Text('Print Location'),
                    ),

                    //! Media Picker Section
                    InkWell(
                      onTap: () async {
                        await controller.pickMedia(context);
                      },
                      child: Column(
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: controller.mediaFiles.map((file) {
                              final fileExtension =
                                  file.path.split('.').last.toLowerCase();
                              return Stack(
                                children: [
                                  // Image or Video
                                  if (fileExtension == 'jpg' ||
                                      fileExtension == 'jpeg' ||
                                      fileExtension == 'png')
                                    SizedBox(
                                      height: 150,
                                      width: 150,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          file,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  if (fileExtension == 'mp4' ||
                                      fileExtension == 'mov' ||
                                      fileExtension == 'avi')
                                    SizedBox(
                                      height: 150,
                                      width: 150,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: FutureBuilder(
                                          future: _initializeVideo(file),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              return VideoPlayer(snapshot.data
                                                  as VideoPlayerController);
                                            }
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          },
                                        ),
                                      ),
                                    ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.removeMedia(file);
                                      },
                                      child: const CircleAvatar(
                                        backgroundColor: Colors.red,
                                        radius: 12,
                                        child: Icon(Icons.close,
                                            color: Colors.white, size: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () => controller.pickMedia(context),
                            icon: const Icon(Icons.add_a_photo),
                            label: const Text('Add Images'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Form Fields
                    MyField(
                      maxLines: 5,
                      prefixIcon: const Icon(Icons.description),
                      controller: descriptionController,
                      hintText: 'Description',
                      validatorText: 'Enter a description',
                    ),
                    MyField(
                      prefixIcon: const Icon(Icons.bed),
                      controller: noBedController,
                      hintText: 'Number of Bedrooms',
                      textInputType: TextInputType.number,
                      validatorText: 'Enter number of bedrooms',
                    ),
                    MyField(
                      prefixIcon: const Icon(Icons.bathroom),
                      controller: noBathController,
                      textInputType: TextInputType.number,
                      hintText: 'Number of Bathrooms',
                      validatorText: 'Enter number of bathrooms',
                    ),
                    MyField(
                      prefixIcon: const Icon(Icons.weekend),
                      controller: livingRoomController,
                      textInputType: TextInputType.number,
                      hintText: 'Number of living rooms',
                      validatorText: 'Enter number of living rooms',
                    ),
                    MyField(
                      prefixIcon: const Icon(Icons.square_foot),
                      controller: areaController,
                      textInputType: TextInputType.number,
                      hintText: 'Area in Square feet',
                      validatorText: 'Enter Area in Square feet',
                    ),
                    MyField(
                      prefixIcon: const Icon(Icons.location_on),
                      controller: addressController,
                      hintText: 'Address',
                      validatorText: 'Enter an address',
                    ),

                    // Apartment Type Dropdown
                    MyDropdown(
                      prefixIcon: const Icon(Icons.roofing_outlined),
                      selectedItem: selectedType,
                      items: houseTypes,
                      onChanged: (String? value) {
                        setState(() {
                          selectedType = value!;
                        });
                      },
                      hintText: 'Select Apartment Type',
                      validaterText: 'Please select an option',
                    ),

                    MyField(
                      prefixIcon: const Icon(Icons.house_rounded),
                      controller: housenoController,
                      textInputType: TextInputType.number,
                      hintText: 'House No',
                      validatorText: 'Enter House No',
                    ),
                    MyField(
                      prefixIcon: const Icon(Icons.business),
                      controller: floorController,
                      textInputType: TextInputType.number,
                      hintText: 'Floor No',
                      validatorText: 'Enter Floor No',
                    ),
                    MyField(
                      prefixIcon: const Icon(Icons.person_2_sharp),
                      controller: ownerNameController,
                      hintText: 'Owner name',
                      validatorText: 'Enter Owner name',
                    ),
                    MyField(
                      prefixIcon: const Icon(Icons.phone_in_talk_rounded),
                      controller: ownerPhoneController,
                      hintText: 'Owner phone number',
                      textInputType: TextInputType.phone,
                      validatorText: 'Enter Owner phone number',
                      onValidator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a phone number';
                        }
                        if (value.length != 12) {
                          return 'Phone number must be 12 digits';
                        }
                        return null;
                      },
                    ),
                    MyField(
                      prefixIcon: const Icon(Icons.price_change_rounded),
                      controller: priceController,
                      textInputType: TextInputType.number,
                      hintText: 'Price',
                      validatorText: 'Enter Price of House',
                    ),

                    const SizedBox(height: 16),

                    // Add Apartment Button
                    Obx(() {
                      return ElevatedButton(
                        onPressed: controller.isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  await controller.addApartment(
                                    description: descriptionController.text,
                                    noBed: noBedController.text,
                                    noBath: noBathController.text,
                                    address: addressController.text,
                                    roomType: selectedType ?? '',
                                    price: priceController.text,
                                    houseNumber: housenoController.text,
                                    floor: floorController.text,
                                    ownerName: ownerNameController.text,
                                    ownerPhone: ownerPhoneController.text,
                                    area: areaController.text,
                                    livingRoom: livingRoomController.text,
                                    lag: controller.latitude.value,
                                    log: controller.longitude.value,
                                  );
                                }
                              },
                        child: controller.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text("Add Apartment"),
                      );
                    }),
                  ],
                ),
              ),
            ),
          );
        }
      }),
    );
  }
}
