// // ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

// import 'package:apartment_rentals/res/app_widgets/app_bar.dart';
// import 'package:apartment_rentals/res/app_widgets/text.dart';
// import 'package:apartment_rentals/res/colors.dart';
// import 'package:apartment_rentals/view_models/services/user_session.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// import '../../view_models/controllers/request/request_view_model.dart';
// import 'widgets/app_bar_actions.dart';
// import 'widgets/button_widget.dart';
// import 'widgets/image_widget.dart';
// import 'widgets/owner_details.dart';
// import 'widgets/price_widget.dart';
// import 'widgets/property_details.dart';
// import 'widgets/row_icon_text.dart';

// class ApartmentDetailsScreen extends StatefulWidget {
//   final String apartmentId;
//   final bool btn;

//   const ApartmentDetailsScreen(
//       {super.key, required this.apartmentId, this.btn = true});

//   @override
//   State<ApartmentDetailsScreen> createState() => _ApartmentDetailsScreenState();
// }

// class _ApartmentDetailsScreenState extends State<ApartmentDetailsScreen> {
//   //! fetch Owner Details

//   @override
//   Widget build(BuildContext context) {
//     DateTime date = DateTime.now(); // Example date
//     String formattedDate = DateFormat('d MMM y').format(date);

//     RequestController _controller = Get.put(RequestController());
//     final ref =
//         FirebaseDatabase.instance.ref('apartments').child(widget.apartmentId);

//     return Scaffold(
//       appBar: MyAppBar(title: 'Property Details'),
//       // appBar: AppBar(
//       //   title: Text('Details of the Apartments'),
//       //   actions: [],
//       // ),
//       body: FutureBuilder<DataSnapshot>(
//         future: ref.get(), // Fetch data for the specific apartment
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           if (!snapshot.hasData || snapshot.data?.value == null) {
//             return const Center(child: Text('Apartment not found.'));
//           }

//           final apartment = snapshot.data!.value as Map<dynamic, dynamic>;
//           final description = apartment['description'] ?? 'N/A';
//           final address = apartment['address'] ?? 'N/A';
//           final price = apartment['price'] ?? 'N/A';
//           final imageUrl = apartment['imageUrl'] ?? 'N/A';
//           final userId = apartment['userId'] ?? 'N/A';
//           final bed = apartment['noBed'] ?? 'N/A';
//           final bath = apartment['noBath'] ?? 'N/A';
//           final houseNumber = apartment['houseNumber'] ?? 'N/A';
//           final floor = apartment['floor'] ?? 'N/A';
//           final available = apartment['available'] ?? 'N/A';
//           final roomType = apartment['roomType'] ?? 'N/A';
//           final area = apartment['area'] ?? 'N/A';
//           final livingRoom = apartment['livingRoom'] ?? 'N/A';
//           final uuid = apartment['uuid'] ?? 'N/A';
//           final ownerId = apartment['userId'] ?? 'N/A';

//           return CustomScrollView(
//             slivers: [
//               SliverAppBar(
//                 automaticallyImplyLeading: false,
//                 expandedHeight: 350.h, // Height of the image area
//                 pinned: false, // Keeps the image at the top as the rest scrolls
//                 flexibleSpace: FlexibleSpaceBar(
//                     background: SafeArea(
//                   child: Stack(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                         child: Container(
//                           height: 400.h,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.only(
//                               bottomLeft: Radius.circular(20),
//                               bottomRight: Radius.circular(20),
//                             ),
//                           ),
//                           child: Stack(
//                             fit: StackFit.expand,
//                             children: [
//                               //! Image
//                               ImageWidget(imageUrl: imageUrl),

//                               // Gradient fade effect on top (black fades to transparent)
//                               Positioned.fill(
//                                 child: Align(
//                                   alignment: Alignment.topCenter,
//                                   child: Container(
//                                     decoration: BoxDecoration(),
//                                   ),
//                                 ),
//                               ),

//                               //! Bottom black overlay with opacity
//                               Positioned(
//                                 bottom: 0,
//                                 left: 0,
//                                 right: 0,
//                                 child: Container(
//                                   height: 80.h,
//                                   decoration: BoxDecoration(
//                                     color: Colors.black.withValues(alpha: 0.6),
//                                     gradient: LinearGradient(
//                                       begin: Alignment.topCenter,
//                                       end: Alignment.bottomCenter,
//                                       colors: [
//                                         Colors.black.withValues(alpha: 0.6),
//                                         Colors.transparent,
//                                       ],
//                                       stops: [1.1, 2.1],
//                                     ),
//                                     borderRadius: BorderRadius.only(
//                                       bottomLeft: Radius.circular(20),
//                                       bottomRight: Radius.circular(20),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       // ! update and delete buttons
//                       SessionController().userId == userId
//                           ? Positioned(
//                               top: 30,
//                               right: 25,
//                               child: UpdateAndDeleteWidget(
//                                   widget: widget,
//                                   apartment: apartment,
//                                   ref: ref),
//                             )
//                           : SizedBox.shrink(),
//                       // ! price per-month
//                       PriceTextWidget(price: price)
//                     ],
//                   ),
//                 )),
//               ),
//               SliverList(
//                 delegate: SliverChildListDelegate(
//                   [
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                           vertical: 12.h, horizontal: 20.w),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           AppText.heading(
//                             roomType,
//                             color: kDark,
//                           ),
//                           // ! address of property
//                           SizedBox(height: 10.h),
//                           SizedBox(
//                             width: double.infinity,
//                             child: RowIconText(
//                                 text: address, icon: Icons.location_on),
//                           ),
//                           SizedBox(
//                             height: 20.h,
//                           ),
//                           // ! propertie details
//                           AppText.heading(
//                             'Property Details',
//                             color: kDark,
//                           ),
//                           PropertiesDetailsWidget(
//                             bed: bed,
//                             bath: bath,
//                             houseNumber: houseNumber,
//                             floor: floor,
//                             area: area,
//                             livingRoom: livingRoom,
//                           ),
//                           SizedBox(
//                             height: 20.h,
//                           ),
//                           // ! discrition propertie
//                           AppText.heading('Propertie Description'),
//                           Padding(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 10.w, vertical: 15.h),
//                             child: AppText.body1(description),
//                           ),
//                           SizedBox(height: 20.h),
//                           // Add condition for the Check Out button based on availability and ownership
//                           SizedBox(
//                             height: 20.h,
//                           ),
//                           // ! owner Deatils
//                           AppText.heading('Owner Details'),
//                           OwnerDetailsWidget(
//                               controller: _controller, ownerId: ownerId),
//                           SizedBox(
//                             height: 20.h,
//                           ),
//                           // ! button with contiondtions
//                           ButtonOfConditions(
//                               widget: widget,
//                               available: available,
//                               userId: userId,
//                               controller: _controller,
//                               uuid: uuid),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:apartment_rentals/res/app_widgets/app_bar.dart';
import 'package:apartment_rentals/res/app_widgets/text.dart';
import 'package:apartment_rentals/res/colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../view_models/controllers/request/request_view_model.dart';
import '../../view_models/services/user_session.dart';
import 'widgets/app_bar_actions.dart';
import 'widgets/button_widget.dart';
import 'widgets/image_widget.dart';
import 'widgets/owner_details.dart';
import 'widgets/price_widget.dart';
import 'widgets/property_details.dart';
import 'widgets/row_icon_text.dart';

class ApartmentDetailsScreen extends StatefulWidget {
  final String apartmentId;
  final bool btn;

  const ApartmentDetailsScreen(
      {super.key, required this.apartmentId, this.btn = true});

  @override
  State<ApartmentDetailsScreen> createState() => _ApartmentDetailsScreenState();
}

class _ApartmentDetailsScreenState extends State<ApartmentDetailsScreen> {
  //! Fetch Owner Details

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.now(); // Example date
    DateFormat('d MMM y').format(date);

    RequestController _controller = Get.put(RequestController());
    final ref =
        FirebaseDatabase.instance.ref('apartments').child(widget.apartmentId);

    return Scaffold(
      appBar: MyAppBar(
        title: 'Property Details',
        actions: [],
      ),
      body: FutureBuilder<DataSnapshot>(
        future: ref.get(), // Fetch data for the specific apartment
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data?.value == null) {
            return const Center(child: Text('Apartment not found.'));
          }

          final apartment = snapshot.data!.value as Map<dynamic, dynamic>;
          final description = apartment['description'] ?? 'N/A';
          final address = apartment['address'] ?? 'N/A';
          final price = apartment['price'] ?? 'N/A';
          final userId = apartment['userId'] ?? 'N/A';
          final bed = apartment['noBed'] ?? 'N/A';
          final bath = apartment['noBath'] ?? 'N/A';
          final houseNumber = apartment['houseNumber'] ?? 'N/A';
          final floor = apartment['floor'] ?? 'N/A';
          final available = apartment['available'] ?? 'N/A';
          final roomType = apartment['roomType'] ?? 'N/A';
          final area = apartment['area'] ?? 'N/A';
          final livingRoom = apartment['livingRoom'] ?? 'N/A';
          final uuid = apartment['uuid'] ?? 'N/A';
          final ownerId = apartment['userId'] ?? 'N/A';
          final mediaUrls = apartment['mediaUrls'] ?? [];

          return ListView(
            children: [
              Stack(
                children: [
                  ImageWidget(
                    mediaUrls: mediaUrls,
                    child: PriceTextWidget(price: price),
                  ),
                  SessionController().userId == userId
                      ? Positioned(
                          top: 30,
                          right: 25,
                          child: UpdateAndDeleteWidget(
                              widget: widget, apartment: apartment, ref: ref),
                        )
                      : SizedBox.shrink(),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.heading(roomType, color: kDark),
                    // ! Address of property
                    SizedBox(height: 10.h),
                    SizedBox(
                      width: double.infinity,
                      child:
                          RowIconText(text: address, icon: Icons.location_on),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    // ! Property details
                    AppText.heading('Property Details', color: kDark),
                    PropertiesDetailsWidget(
                      bed: bed,
                      bath: bath,
                      houseNumber: houseNumber,
                      floor: floor,
                      area: area,
                      livingRoom: livingRoom,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    // ! Description of property
                    AppText.heading('Property Description'),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 15.h),
                      child: AppText.body1(description),
                    ),
                    SizedBox(height: 20.h),
                    // ! Owner details
                    AppText.heading('Owner Details'),
                    OwnerDetailsWidget(
                      controller: _controller,
                      ownerId: ownerId,
                      apartmentId: uuid,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    // ! Button with conditions
                    ButtonOfConditions(
                        widget: widget,
                        available: available,
                        userId: userId,
                        controller: _controller,
                        uuid: uuid),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
