// // ignore_for_file: no_leading_underscores_for_local_identifiers

// // Add Apartment Screen (AddAppartmentScreen.dart)
// import 'package:apartment_rentals/renter_dash_bord.dart';
// import 'package:apartment_rentals/res/app_widgets/app_bar.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// import '../../../res/app_widgets/button.dart';
// import '../../../res/app_widgets/text_form_field.dart';
// import '../../res/app_widgets/drop_down.dart';
// import '../../utils/utils.dart';
// import '../../view_models/controllers/add_appartment/add_appartment_view_model.dart';

// class UpdateApartmentScreen extends StatefulWidget {
//   final String apartmentId;

//   const UpdateApartmentScreen({super.key, required this.apartmentId});

//   @override
//   State<UpdateApartmentScreen> createState() => _UpdateApartmentScreenState();
// }

// class _UpdateApartmentScreenState extends State<UpdateApartmentScreen> {
//   final AddApartmentController controller = Get.put(AddApartmentController());

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
//   String? existingImageUrl;

//   @override
//   void initState() {
//     super.initState();

//     // Retrieve apartment data from Get.arguments
//     final apartmentData =
//         Get.arguments['apartmentData'] as Map<dynamic, dynamic>;

//     // Initialize controllers with apartment data
//     descriptionController.text = apartmentData['description'] ?? '';
//     noBedController.text = apartmentData['noBed']?.toString() ?? '';
//     noBathController.text = apartmentData['noBath']?.toString() ?? '';
//     addressController.text = apartmentData['address'] ?? '';
//     priceController.text = apartmentData['price']?.toString() ?? '';
//     housenoController.text = apartmentData['houseNumber'] ?? '';
//     floorController.text = apartmentData['floor']?.toString() ?? '';
//     ownerNameController.text = apartmentData['ownerName'] ?? '';
//     ownerPhoneController.text = apartmentData['ownerPhone']?.toString() ?? '';
//     selectedType = apartmentData['roomType'] ?? houseTypes[0];
//     controller.imageUrl.value = apartmentData['imageUrl'] ?? '';
//     existingImageUrl = apartmentData['imageUrl'];
//     areaController.text = apartmentData['area']?.toString() ?? '';
//     livingRoomController.text = apartmentData['livingRoom']?.toString() ?? '';
//   }

//   @override
//   void dispose() {
//     descriptionController.dispose();
//     noBedController.dispose();
//     noBathController.dispose();
//     addressController.dispose();
//     priceController.dispose();
//     housenoController.dispose();
//     floorController.dispose();
//     ownerNameController.dispose();
//     ownerPhoneController.dispose();
//     areaController.dispose();
//     livingRoomController.dispose();
//     super.dispose();
//   }

//   void _selectImage() async {
//     // Open the image picker
//     await controller.pickImage(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     FirebaseDatabase.instance.ref('apartments').child(widget.apartmentId);

//     return Scaffold(
//       appBar: MyAppBar(
//         title: 'Update Apartment',
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Image Container
//                 GestureDetector(
//                   onTap: _selectImage, // Trigger image selection on tap
//                   child: Container(
//                     height: 200,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       color: Colors.grey[300],
//                     ),
//                     child: Obx(
//                       () {
//                         // If a new image is selected, show it
//                         if (controller.image.value != null) {
//                           return ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: Image.file(
//                               controller.image.value!,
//                               height: 200,
//                               width: double.infinity,
//                               fit: BoxFit.cover,
//                             ),
//                           );
//                         }
//                         // If no new image, show the existing image (if available)
//                         else if (existingImageUrl != null &&
//                             existingImageUrl!.isNotEmpty) {
//                           return ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: Image.network(
//                               existingImageUrl!,
//                               height: 200,
//                               width: double.infinity,
//                               fit: BoxFit.cover,
//                             ),
//                           );
//                         } else {
//                           return Center(
//                             child: Icon(
//                               Icons.add_a_photo,
//                               size: 50,
//                               color: Colors.grey[700],
//                             ),
//                           );
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10.h),

//                 //! Description Field
//                 MyField(
//                   maxLines: 5,
//                   prefixIcon: Icon(Icons.description),
//                   controller: descriptionController,
//                   hintText: 'Description',
//                   validatorText: 'Enter a description',
//                 ),
//                 SizedBox(height: 10.h),
//                 //! Bedrooms Field
//                 MyField(
//                   prefixIcon: Icon(Icons.bed),
//                   controller: noBedController,
//                   hintText: 'Number of Bedrooms',
//                   validatorText: 'Enter number of bedrooms',
//                 ),
//                 SizedBox(height: 10.h),
//                 //! Bathrooms Field
//                 MyField(
//                   prefixIcon: Icon(Icons.bathroom),
//                   controller: noBathController,
//                   hintText: 'Number of Bathrooms',
//                   validatorText: 'Enter number of bathrooms',
//                 ),
//                 SizedBox(height: 10.h),
//                 //! Number of Living Room field
//                 MyField(
//                   prefixIcon: Icon(Icons.weekend),
//                   controller: livingRoomController,
//                   textInputType: TextInputType.number,
//                   hintText: 'Number of living room',
//                   validatorText: 'Enter number of living room',
//                 ),
//                 //! Area in Square fit
//                 MyField(
//                   prefixIcon: Icon(Icons.square_foot),
//                   controller: areaController,
//                   textInputType: TextInputType.number,
//                   hintText: 'Area in Square fit',
//                   validatorText: 'Enter Area in Square fit',
//                 ),

//                 //! Address Field
//                 MyField(
//                   prefixIcon: Icon(Icons.location_on),
//                   controller: addressController,
//                   hintText: 'Address',
//                   validatorText: 'Enter an address',
//                 ),
//                 SizedBox(height: 10.h),
//                 //! Apartment Type Dropdown
//                 MyDropdown(
//                   prefixIcon: Icon(Icons.roofing_outlined),
//                   selectedItem: selectedType,
//                   items: houseTypes,
//                   onChanged: (String? value) {
//                     setState(() {
//                       selectedType = value!;
//                     });
//                   },
//                   hintText: 'Select Apartment Type',
//                   validaterText: 'Please select an option',
//                 ),
//                 SizedBox(height: 10.h),
//                 //! House Number Field
//                 MyField(
//                   prefixIcon: Icon(Icons.house_rounded),
//                   controller: housenoController,
//                   hintText: 'House No',
//                   validatorText: 'Enter House No',
//                 ),
//                 SizedBox(height: 10.h),
//                 //! Floor Field
//                 MyField(
//                   prefixIcon: Icon(Icons.business),
//                   controller: floorController,
//                   hintText: 'Floor No',
//                   validatorText: 'Enter Floor No',
//                 ),
//                 SizedBox(height: 10.h),
//                 //! Owner Name Field
//                 MyField(
//                   prefixIcon: Icon(Icons.person_2_sharp),
//                   controller: ownerNameController,
//                   hintText: 'Owner name',
//                   validatorText: 'Enter Owner name',
//                 ),
//                 SizedBox(height: 10.h),
//                 //! Owner Phone Field
//                 MyField(
//                   prefixIcon: Icon(Icons.phone_in_talk_rounded),
//                   controller: ownerPhoneController,
//                   hintText: 'Owner phone number',
//                   validatorText: 'Enter Owner phone number',
//                 ),
//                 SizedBox(height: 10.h),
//                 //! Price Field
//                 MyField(
//                   prefixIcon: Icon(Icons.price_change_rounded),
//                   controller: priceController,
//                   hintText: 'Price',
//                   validatorText: 'Enter price',
//                 ),

//                 SizedBox(height: 15.h),

//                 //! Update Button
//                 // Obx(
//                 //   () => MyButton(
//                 //     isLoading: controller.isLoading,
//                 //     text: 'Update Apartment',
//                 //     onTap: () async {
//                 //       if (_formKey.currentState!.validate()) {
//                 //         await controller
//                 //             .updateApartment(
//                 //           widget.apartmentId,
//                 //           description: descriptionController.text.trim(),
//                 //           noBed: noBedController.text.trim(),
//                 //           noBath: noBathController.text.trim(),
//                 //           address: addressController.text.trim(),
//                 //           roomType: selectedType ?? '',
//                 //           price: priceController.text.trim(),
//                 //           houseNumber: housenoController.text.trim(),
//                 //           floor: floorController.text.trim(),
//                 //           ownerName: ownerNameController.text.trim(),
//                 //           ownerPhone: ownerPhoneController.text.trim(),
//                 //           newImage: controller.image.value,
//                 //           existingImageUrl: existingImageUrl,
//                 //           area: areaController.text.trim(),
//                 //           livingRoom: livingRoomController.text.trim(),
//                 //         )
//                 //             .then(
//                 //           (value) {
//                 //             Utils()
//                 //                 .doneSnackBar('Update Apartment successfully!');
//                 //             Get.to(() => RenterDashBord());
//                 //           },
//                 //         );
//                 //       }
//                 //     },
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: no_leading_underscores_for_local_identifiers

// Add Apartment Screen (AddAppartmentScreen.dart)
import 'package:apartment_rentals/res/app_widgets/app_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../res/app_widgets/text_form_field.dart';
import '../../res/app_widgets/drop_down.dart';
import '../../utils/utils.dart';
import '../../view_models/controllers/add_appartment/add_appartment_view_model.dart';

class UpdateApartmentScreen extends StatefulWidget {
  final String apartmentId;

  const UpdateApartmentScreen({super.key, required this.apartmentId});

  @override
  State<UpdateApartmentScreen> createState() => _UpdateApartmentScreenState();
}

class _UpdateApartmentScreenState extends State<UpdateApartmentScreen> {
  final AddApartmentController controller = Get.put(AddApartmentController());

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
  String? existingImageUrl;

  @override
  void initState() {
    super.initState();

    // Retrieve apartment data from Get.arguments
    final apartmentData =
        Get.arguments['apartmentData'] as Map<dynamic, dynamic>;

    // Initialize controllers with apartment data
    descriptionController.text = apartmentData['description'] ?? '';
    noBedController.text = apartmentData['noBed']?.toString() ?? '';
    noBathController.text = apartmentData['noBath']?.toString() ?? '';
    addressController.text = apartmentData['address'] ?? '';
    priceController.text = apartmentData['price']?.toString() ?? '';
    housenoController.text = apartmentData['houseNumber'] ?? '';
    floorController.text = apartmentData['floor']?.toString() ?? '';
    ownerNameController.text = apartmentData['ownerName'] ?? '';
    ownerPhoneController.text = apartmentData['ownerPhone']?.toString() ?? '';
    selectedType = apartmentData['roomType'] ?? houseTypes[0];
    // controller.imageUrl.value = apartmentData['imageUrl'] ?? '';
    existingImageUrl = apartmentData['imageUrl'];
    areaController.text = apartmentData['area']?.toString() ?? '';
    livingRoomController.text = apartmentData['livingRoom']?.toString() ?? '';
  }

  @override
  void dispose() {
    descriptionController.dispose();
    noBedController.dispose();
    noBathController.dispose();
    addressController.dispose();
    priceController.dispose();
    housenoController.dispose();
    floorController.dispose();
    ownerNameController.dispose();
    ownerPhoneController.dispose();
    areaController.dispose();
    livingRoomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseDatabase.instance.ref('apartments').child(widget.apartmentId);

    return Scaffold(
      appBar: MyAppBar(
        title: 'Update Apartment',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // // Image Container
                // GestureDetector(
                //   onTap: _selectImage, // Trigger image selection on tap
                //   child: Container(
                //     height: 200,
                //     width: double.infinity,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(12),
                //       color: Colors.grey[300],
                //     ),
                //     child: Obx(
                //       () {
                //         // If a new image is selected, show it
                //         if (controller.image.value != null) {
                //           return ClipRRect(
                //             borderRadius: BorderRadius.circular(12),
                //             child: Image.file(
                //               controller.image.value!,
                //               height: 200,
                //               width: double.infinity,
                //               fit: BoxFit.cover,
                //             ),
                //           );
                //         }
                //         // If no new image, show the existing image (if available)
                //         else if (existingImageUrl != null &&
                //             existingImageUrl!.isNotEmpty) {
                //           return ClipRRect(
                //             borderRadius: BorderRadius.circular(12),
                //             child: Image.network(
                //               existingImageUrl!,
                //               height: 200,
                //               width: double.infinity,
                //               fit: BoxFit.cover,
                //             ),
                //           );
                //         } else {
                //           return Center(
                //             child: Icon(
                //               Icons.add_a_photo,
                //               size: 50,
                //               color: Colors.grey[700],
                //             ),
                //           );
                //         }
                //       },
                //     ),
                //   ),
                // ),
                SizedBox(height: 10.h),

                //! Description Field
                MyField(
                  maxLines: 5,
                  prefixIcon: Icon(Icons.description),
                  controller: descriptionController,
                  hintText: 'Description',
                  validatorText: 'Enter a description',
                ),
                SizedBox(height: 10.h),
                //! Bedrooms Field
                MyField(
                  prefixIcon: Icon(Icons.bed),
                  controller: noBedController,
                  hintText: 'Number of Bedrooms',
                  validatorText: 'Enter number of bedrooms',
                ),
                SizedBox(height: 10.h),
                //! Bathrooms Field
                MyField(
                  prefixIcon: Icon(Icons.bathroom),
                  controller: noBathController,
                  hintText: 'Number of Bathrooms',
                  validatorText: 'Enter number of bathrooms',
                ),
                SizedBox(height: 10.h),
                //! Number of Living Room field
                MyField(
                  prefixIcon: Icon(Icons.weekend),
                  controller: livingRoomController,
                  textInputType: TextInputType.number,
                  hintText: 'Number of living room',
                  validatorText: 'Enter number of living room',
                ),
                //! Area in Square fit
                MyField(
                  prefixIcon: Icon(Icons.square_foot),
                  controller: areaController,
                  textInputType: TextInputType.number,
                  hintText: 'Area in Square fit',
                  validatorText: 'Enter Area in Square fit',
                ),

                //! Address Field
                MyField(
                  prefixIcon: Icon(Icons.location_on),
                  controller: addressController,
                  hintText: 'Address',
                  validatorText: 'Enter an address',
                ),
                SizedBox(height: 10.h),
                //! Apartment Type Dropdown
                MyDropdown(
                  prefixIcon: Icon(Icons.roofing_outlined),
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
                SizedBox(height: 10.h),
                //! House Number Field
                MyField(
                  prefixIcon: Icon(Icons.house_rounded),
                  controller: housenoController,
                  hintText: 'House No',
                  validatorText: 'Enter House No',
                ),
                SizedBox(height: 10.h),
                //! Floor Field
                MyField(
                  prefixIcon: Icon(Icons.business),
                  controller: floorController,
                  hintText: 'Floor No',
                  validatorText: 'Enter Floor No',
                ),
                SizedBox(height: 10.h),
                //! Owner Name Field
                MyField(
                  prefixIcon: Icon(Icons.person_2_sharp),
                  controller: ownerNameController,
                  hintText: 'Owner name',
                  validatorText: 'Enter Owner name',
                ),
                SizedBox(height: 10.h),
                //! Owner Phone Field
                MyField(
                  prefixIcon: Icon(Icons.phone_in_talk_rounded),
                  controller: ownerPhoneController,
                  hintText: 'Owner phone number',
                  validatorText: 'Enter Owner phone number',
                ),
                SizedBox(height: 10.h),
                //! Price Field
                MyField(
                  prefixIcon: Icon(Icons.price_change_rounded),
                  controller: priceController,
                  hintText: 'Price',
                  validatorText: 'Enter price',
                ),

                SizedBox(height: 15.h),

                //! Update Button
                // Obx(
                //   () => MyButton(
                //     isLoading: controller.isLoading,
                //     text: 'Update Apartment',
                //     onTap: () async {
                //       if (_formKey.currentState!.validate()) {
                //         await controller
                //             .updateApartment(
                //           widget.apartmentId,
                //           description: descriptionController.text.trim(),
                //           noBed: noBedController.text.trim(),
                //           noBath: noBathController.text.trim(),
                //           address: addressController.text.trim(),
                //           roomType: selectedType ?? '',
                //           price: priceController.text.trim(),
                //           houseNumber: housenoController.text.trim(),
                //           floor: floorController.text.trim(),
                //           ownerName: ownerNameController.text.trim(),
                //           ownerPhone: ownerPhoneController.text.trim(),
                //           newImage: controller.image.value,
                //           existingImageUrl: existingImageUrl,
                //           area: areaController.text.trim(),
                //           livingRoom: livingRoomController.text.trim(),
                //         )
                //             .then(
                //           (value) {
                //             Utils()
                //                 .doneSnackBar('Update Apartment successfully!');
                //             Get.to(() => RenterDashBord());
                //           },
                //         );
                //       }
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
