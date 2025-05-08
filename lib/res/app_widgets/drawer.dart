import 'package:apartment_rentals/res/app_widgets/text.dart';
import 'package:apartment_rentals/res/colors.dart';
import 'package:apartment_rentals/res/routes/routes_name.dart';
import 'package:apartment_rentals/views/my_request/my_request_list_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../view_models/controllers/auth/auth_view_model.dart';
import '../../view_models/controllers/home/home_view_model.dart';
import '../../view_models/services/user_session.dart';
import '../../views/my_property/my_property_view.dart';
import '../../views/requests/requests_list_view.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService auth = Get.put(AuthService());
    final ref = FirebaseDatabase.instance.ref('user');
    final HomeController homeController = Get.put(HomeController());

    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                StreamBuilder<DatabaseEvent>(
                    stream: ref
                        .child(SessionController().userId.toString())
                        .onValue,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('An error occurred while loading data.'),
                        );
                      }

                      final data = snapshot.data?.snapshot.value
                          as Map<dynamic, dynamic>?;

                      if (data == null) {
                        return const Center(
                          child: Text('No shoes available.'),
                        );
                      }

                      return Column(children: [
                        InkWell(
                          onTap: () =>
                              Get.toNamed(RouteName.updateProfileScreen),
                          child: DrawerHeader(
                            decoration: BoxDecoration(
                              color: kSecondary,
                            ),
                            child: Row(
                              spacing: 20,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(data['profilePic']),
                                  radius: 30.h,
                                  backgroundColor: kSecondaryLight,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['name'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      data['email'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      data['phone'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        homeController.userRole.value == "Landlord"
                            ? Column(
                                children: [
                                  ListTile(
                                    leading: Icon(
                                      Icons.house_rounded,
                                      color: kDark,
                                    ),
                                    title: Text('My Properties'),
                                    onTap: () {
                                      Get.to(() => MyPropertyScreen());
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.question_answer_rounded,
                                      color: kDark,
                                    ),
                                    title: Text('Requests'),
                                    onTap: () {
                                      Get.to(() => RequestsPage());
                                    },
                                  ),
                                ],
                              )
                            : SizedBox.shrink(),
                        ListTile(
                          leading: Icon(
                            Icons.location_city_sharp,
                            color: kDark,
                            size: 30.spMin,
                          ),
                          title: AppText.body3Bold('My Requests'),
                          onTap: () {
                            Get.to(() => MyRequestTabScreen());
                          },
                        ),
                      ]);
                    }),
              ],
            ),
          ),

          // Place the logout ListTile at the bottom
          Padding(
            padding: EdgeInsets.only(bottom: 40.h, top: 10.h),
            child: ListTile(
              leading: Icon(
                Icons.logout,
                color: kSecondary2,
                size: 30.spMin,
              ),
              title: AppText.body3Bold('LogOut'),
              // title: Text('Logout'),
              onTap: () {
                auth.logout();
              },
            ),
          ),
        ],
      ),
    );
  }
}
