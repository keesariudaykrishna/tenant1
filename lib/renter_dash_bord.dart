// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:apartment_rentals/views/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:apartment_rentals/res/colors.dart';
import 'package:apartment_rentals/views/maps/map_view.dart';
import 'package:apartment_rentals/views/home/home_view.dart';
import 'package:apartment_rentals/views/serch/search_view.dart';
import 'view_models/controllers/dash_bord/nav_bar_controller.dart';
import 'view_models/controllers/home/home_view_model.dart';

class RenterDashBord extends StatelessWidget {
  const RenterDashBord({super.key});

  @override
  Widget build(BuildContext context) {
    final TabIndexController tabController = Get.put(TabIndexController());
    Get.put(BackButtonController());
    Get.put(HomeController());

    List<Widget> pageList = [
      HomeScreen(),
      SearchScreen(),
      MapScreen(),
      ProfileScreen(),
    ];

    // Handle back press with GetX state management

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {},
//       onWillPop: _onBackPressed, // Handle the back button press
      child: Obx(
        () => Stack(
          children: [
            Positioned.fill(
              child: pageList[tabController.tabIndex],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: kSecondary2,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      color: Colors.black.withValues(alpha: .1),
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                  child: GNav(
                    rippleColor: kSecondary3,
                    hoverColor: kSecondary3,
                    gap: 8,
                    activeColor: kPrimary,
                    iconSize: 24,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    duration: Duration(milliseconds: 400),
                    tabBackgroundColor: Colors.black38,
                    color: Colors.black,
                    selectedIndex: tabController.tabIndex,
                    onTabChange: (index) {
                      tabController.setTabIndex = index;
                    },
                    tabs: [
                      GButton(
                        icon: Icons.home_rounded,
                        text: 'Home',
                      ),
                      GButton(
                        icon: Icons.filter_alt,
                        text: 'Filter',
                      ),
                      GButton(
                        icon: FontAwesomeIcons.mapLocationDot,
                        text: 'Map',
                      ),
                      GButton(
                        icon: Icons.person_2_rounded,
                        text: 'Profile',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
