// // ignore_for_file: no_leading_underscores_for_local_identifiers

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// import '../../../res/colors.dart';
// import '../../../view_models/controllers/add_appartment/add_appartment_view_model.dart';

// class ImageContainer extends StatelessWidget {
//   const ImageContainer({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final AddApartmentController _controller = Get.put(
//         AddApartmentController()); //! Create an instance of AddApartmentController

//     return GestureDetector(
//       onTap: () async {
//         // await _controller.pickImage(context); // Trigger image picking
//       },
//       child: Container(
//         height: 170.h,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           color: kSecondary.withValues(
//               alpha: 0.1), //! Background color with opacity
//           borderRadius: BorderRadius.circular(12), //! Rounded corners
//           border: Border.all(color: kSecondary), //! Border with secondary color
//         ),
//         child: Obx(() {
//           // Obx allows us to reactively update the UI when the image state changes
//           if (_controller.image.value == null) {
//             return Center(
//               child: IconButton(
//                 icon: Icon(
//                   Icons.add_a_photo, //! Icon for adding a photo
//                   size: 40,
//                   color: kSecondary,
//                 ),
//                 onPressed: () => _controller.pickImage(context),
//               ),
//             );
//           } else {
//             return Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(
//                       12), //! Rounded corners for the image
//                   child: Image.file(
//                     File(_controller
//                         .image.value!.path), //! Display the picked image
//                     fit: BoxFit
//                         .cover, //! Ensures the image covers the entire area
//                     width: double.infinity, //! Take up full width
//                     height: double.infinity, //! Take up full height
//                   ),
//                 ),
//                 Positioned(
//                   top: 10, //! Position the close button on the top right
//                   right: 10,
//                   child: GestureDetector(
//                     onTap: () {
//                       _controller
//                           .removeImage(); //! Remove the image when close button is tapped
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color:
//                             Colors.red, //! Red background for the close button
//                         shape: BoxShape.circle, //! Circle-shaped close button
//                       ),
//                       child: Icon(
//                         Icons.close, //! Close icon
//                         color: Colors.white, //! White color for the close icon
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           }
//         }),
//       ),
//     );
//   }
// }
