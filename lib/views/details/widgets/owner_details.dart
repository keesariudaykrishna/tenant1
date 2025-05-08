// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';

// // import '../../../res/colors.dart';
// // import '../../../view_models/controllers/request/request_view_model.dart';
// // import 'row_icon_text.dart';

// // class OwnerDetailsWidget extends StatelessWidget {
// //   const OwnerDetailsWidget({
// //     super.key,
// //     required RequestController controller,
// //     required this.ownerId,
// //   }) : _controller = controller;

// //   final RequestController _controller;
// //   final dynamic ownerId;

// //   @override
// //   Widget build(BuildContext context) {
// //     return SizedBox(
// //       child: FutureBuilder<Map<String, dynamic>?>(
// //         future: _controller.getUserData(ownerId),
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return Center(child: CircularProgressIndicator());
// //           } else if (snapshot.hasError) {
// //             return Center(child: Text("Error: ${snapshot.error}"));
// //           } else if (!snapshot.hasData || snapshot.data == null) {
// //             return Center(child: Text("No data available"));
// //           } else {
// //             final userData = snapshot.data!;
// //             return Padding(
// //                 padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.start,
// //                   crossAxisAlignment: CrossAxisAlignment.center,
// //                   children: [
// //                     CircleAvatar(
// //                       radius: 30.sp,
// //                       backgroundColor: kSecondary3,
// //                       backgroundImage: userData['profilePic'] != null &&
// //                               userData['profilePic'].isNotEmpty
// //                           ? NetworkImage(userData[
// //                               'profilePic']) // Use NetworkImage for CircleAvatar
// //                           : null,
// //                       child: userData['profilePic'] == null ||
// //                               userData['profilePic'].isEmpty
// //                           ? Icon(
// //                               Icons.person,
// //                               color: Colors.white,
// //                             )
// //                           : null, // Show an icon if there's no image
// //                     ),
// //                     SizedBox(
// //                       width: 20,
// //                     ),
// //                     Column(
// //                       mainAxisAlignment: MainAxisAlignment.start,
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         RowIconText(
// //                             text: userData['name'] ?? 'Unknown',
// //                             icon: Icons.person_2_rounded),
// //                         RowIconText(
// //                             text: userData['phone'] ?? 'Unknown',
// //                             icon: Icons.phone_rounded),
// //                         // AppText.body4Bold(
// //                         //    userData['name'] ??
// //                         //         'Unknown' ),
// //                         // AppText.body4Bold(
// //                         //     userData['phone'] ??
// //                         //         'Unknown'),
// //                       ],
// //                     )
// //                   ],
// //                 ));
// //           }
// //         },
// //       ),
// //     );
// //   }
// // }

// // ignore_for_file: use_build_context_synchronously

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../res/colors.dart';
import '../../../view_models/controllers/request/request_view_model.dart';
import 'row_icon_text.dart';

// class OwnerDetailsWidget extends StatelessWidget {
//   const OwnerDetailsWidget({
//     super.key,
//     required RequestController controller,
//     required this.ownerId,
//   }) : _controller = controller;

//   final RequestController _controller;
//   final dynamic ownerId;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       child: FutureBuilder<Map<String, dynamic>?>(
//         future: _controller.getUserData(ownerId),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else if (!snapshot.hasData || snapshot.data == null) {
//             return Center(child: Text("No data available"));
//           } else {
//             final userData = snapshot.data!;
//             return Padding(
//               padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   CircleAvatar(
//                     radius: 30.sp,
//                     backgroundColor: kSecondary3,
//                     backgroundImage: userData['profilePic'] != null &&
//                             userData['profilePic'].isNotEmpty
//                         ? NetworkImage(userData[
//                             'profilePic']) // Use NetworkImage for CircleAvatar
//                         : null,
//                     child: userData['profilePic'] == null ||
//                             userData['profilePic'].isEmpty
//                         ? Icon(
//                             Icons.person,
//                             color: Colors.white,
//                           )
//                         : null, // Show an icon if there's no image
//                   ),
//                   SizedBox(
//                     width: 20,
//                   ),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       RowIconText(
//                           text: userData['name'] ?? 'Unknown',
//                           icon: Icons.person_2_rounded),
//                       GestureDetector(
//                         onTap: () async {
//                           // Launch phone dialer
//                           final phoneNumber = userData['phone'] ?? '';
//                           if (phoneNumber.isNotEmpty) {
//                             final Uri phoneUri =
//                                 Uri(scheme: 'tel', path: phoneNumber);
//                             if (await canLaunchUrl(phoneUri)) {
//                               await launchUrl(phoneUri);
//                             } else {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content:
//                                       Text('Could not launch phone dialer'),
//                                 ),
//                               );
//                             }
//                           }
//                         },
//                         onLongPress: () {
//                           // Copy phone number to clipboard
//                           final phoneNumber = userData['phone'] ?? '';
//                           if (phoneNumber.isNotEmpty) {
//                             Clipboard.setData(ClipboardData(text: phoneNumber));
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content:
//                                     Text('Phone number copied to clipboard'),
//                               ),
//                             );
//                           }
//                         },
//                         child: RowIconText(
//                           text: userData['phone'] ?? 'Unknown',
//                           icon: Icons.phone_rounded,
//                         ),
//                       ),
//                     ],
//                   ),

//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

class OwnerDetailsWidget extends StatelessWidget {
  const OwnerDetailsWidget({
    super.key,
    required RequestController controller,
    required this.ownerId,
    required this.apartmentId,
  }) : _controller = controller;

  final RequestController _controller;
  final dynamic ownerId;
  final String apartmentId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: FutureBuilder<Map<String, dynamic>?>(
        future: _controller.getUserData(ownerId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("No data available"));
          } else {
            final userData = snapshot.data!;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30.sp,
                    backgroundColor: kSecondary3,
                    backgroundImage: userData['profilePic'] != null &&
                            userData['profilePic'].isNotEmpty
                        ? NetworkImage(userData[
                            'profilePic']) // Use NetworkImage for CircleAvatar
                        : null,
                    child: userData['profilePic'] == null ||
                            userData['profilePic'].isEmpty
                        ? Icon(
                            Icons.person,
                            color: Colors.white,
                          )
                        : null, // Show an icon if there's no image
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RowIconText(
                          text: userData['name'] ?? 'Unknown',
                          icon: Icons.person_2_rounded),
                      GestureDetector(
                        onTap: () async {
                          // Launch phone dialer
                          final phoneNumber = userData['phone'] ?? '';
                          if (phoneNumber.isNotEmpty) {
                            final Uri phoneUri =
                                Uri(scheme: 'tel', path: phoneNumber);
                            if (await canLaunchUrl(phoneUri)) {
                              await launchUrl(phoneUri);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Could not launch phone dialer'),
                                ),
                              );
                            }
                          }
                        },
                        onLongPress: () {
                          // Copy phone number to clipboard
                          final phoneNumber = userData['phone'] ?? '';
                          if (phoneNumber.isNotEmpty) {
                            Clipboard.setData(ClipboardData(text: phoneNumber));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Phone number copied to clipboard'),
                              ),
                            );
                          }
                        },
                        child: RowIconText(
                          text: userData['phone'] ?? 'Unknown',
                          icon: Icons.phone_rounded,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
