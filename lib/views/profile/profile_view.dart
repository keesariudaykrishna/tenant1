import 'package:apartment_rentals/res/app_widgets/app_bar.dart';
import 'package:apartment_rentals/res/colors.dart';
import 'package:apartment_rentals/res/routes/routes_name.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../view_models/services/user_session.dart';
import 'widgets/info_row.dart';
import 'widgets/user_iamge_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final ref = FirebaseDatabase.instance
        .ref('user'); // ! Firebase reference to fetch user data
    return Scaffold(
      appBar: MyAppBar(
        title: 'Profile', // ! Custom app bar with title 'Profile'
        showBackButton: false, // ! Disable back button
      ),
      body: StreamBuilder<DatabaseEvent>(
          // ! Stream builder to listen for changes in Firebase data
          stream: ref
              .child(SessionController().userId.toString())
              .onValue, // ! Listen to user data in Firebase
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child:
                      CircularProgressIndicator()); // ! Show loading while data is being fetched
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text(
                    'An error occurred while loading data.'), // ! Error message if something goes wrong
              );
            }

            final data = snapshot.data?.snapshot.value
                as Map<dynamic, dynamic>?; // ! Get the data from snapshot

            if (data == null) {
              return const Center(
                child: Text(
                    'No data available.'), // ! Show message if data is null
              );
            }
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: 350.h, // Height of the image area
                  pinned:
                      false, // Keeps the image at the top as the rest scrolls
                  flexibleSpace: FlexibleSpaceBar(
                      background: SafeArea(
                    child: Stack(
                      children: [
                        SizedBox(
                            height: 330.h,
                            width: double.infinity,
                            child: ImageWidget(imageUrl: data['profilePic'])),
                        // ! update and delete buttons
                        Positioned(
                            bottom: 0,
                            right: 30.w,
                            child: Container(
                              width: 45.h,
                              height: 45.h,
                              decoration: BoxDecoration(
                                  color: kSecondary2,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              child: IconButton(
                                  onPressed: () {
                                    Get.toNamed(RouteName.updateProfileScreen);
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: kDark,
                                    size: 30.spMin,
                                  )),
                            ))
                      ],
                    ),
                  )),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 12.h, horizontal: 20.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            // ! InfoRow widget to display profile information
                            InfoCol(
                                tile: 'Name',
                                name:
                                    data['name'] ?? 'N/A', // ! Name of the user
                                icon: Icons.person), // ! Icon for Name
                            InfoCol(
                                tile: 'Email Address',
                                name: data['email'] ??
                                    'N/A', // ! Email of the user
                                icon: Icons.email), // ! Icon for Email
                            InfoCol(
                                tile: 'Phone Number',
                                name: data['phone'] ??
                                    'N/A', // ! Phone number of the user
                                icon: Icons.phone), // ! Icon for Phone
                            InfoCol(
                                tile: 'Address',
                                name: data['address'] ??
                                    'N/A', // ! Address of the user
                                icon: Icons.location_on), // ! Icon for Address
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
