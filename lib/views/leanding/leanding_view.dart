import 'package:apartment_rentals/res/app_widgets/button.dart';
import 'package:apartment_rentals/res/colors.dart';
import 'package:apartment_rentals/res/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../view_models/controllers/leanding/leanding_view_controller.dart';
import 'widgets/text_span.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final LandingPageController controller = Get.put(
      LandingPageController()); //! Controller for landing page tab management

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary, //! Background color for the page
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              //! Reactive widget, rebuilds on tab index change
              return _buildTabContent(controller.currentTabIndex
                  .value); //! Build content based on the current tab
            }),
          ),
        ],
      ),
    );
  }

  // Function to switch between the pages based on the currentTabIndex
  Widget _buildTabContent(int index) {
    switch (index) {
      case 0:
        return _buildIntroPage(); //! Introduction Page
      case 1:
        return _buildFeaturesPage(); //! Features Page
      case 2:
        return _buildGetStartedPage(); //! Get Started Page
      default:
        return _buildIntroPage(); //! Default to Introduction Page
    }
  }

  //! Page 1
  Widget _buildIntroPage() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
            left: 12.w,
            right: 12.w,
            top: 40.h,
            bottom: 40.h), //! Padding around the content
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, //! Space between widgets
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment
                  .center, //! Center alignment for intro content
              crossAxisAlignment:
                  CrossAxisAlignment.center, //! Cross-axis center alignment
              children: [
                SizedBox(
                  height: 50.h, //! Space between top and image
                ),
                SizedBox(
                  height: 250.h, //! Image height
                  width: double.infinity, //! Image width to fill container
                  child: Image.asset('assets/h_d.png'), //! Intro image
                ),
                TextSpanWidget(), //! Text widget with information
              ],
            ),
            MyButton(
                onTap: () {
                  controller.nextTab(); //! Navigate to next tab
                },
                text: 'Next'), //! Button to go to the next tab
          ],
        ),
      ),
    );
  }

  //! Page 2
  Widget _buildFeaturesPage() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
            left: 12.w,
            right: 12.w,
            top: 40.h,
            bottom: 40.h), //! Padding around the content
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, //! Space between widgets
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment
                  .center, //! Center alignment for features content
              crossAxisAlignment:
                  CrossAxisAlignment.center, //! Cross-axis center alignment
              children: [
                SizedBox(
                  height: 50.h, //! Space between top and image
                ),
                SizedBox(
                  height: 250.h, //! Image height
                  width: double.infinity, //! Image width to fill container
                  child: Image.asset('assets/h_e.png'), //! Features image
                ),
                TextSpanWidget2(
                    headingText:
                        'Explore more', //! Heading for the features section
                    subheadingText1:
                        "Don't find the perfect house,Exploring", //! First subheading for features
                    subheadingText2:
                        "different options and keep your priorities in", //! Second subheading
                    subheadingText3: 'mind.'), //! Third subheading
              ],
            ),
            MyButton(
                onTap: () {
                  controller.nextTab(); //! Navigate to the next tab
                },
                text: 'Next'), //! Button to go to the next tab
          ],
        ),
      ),
    );
  }

  //! Page 3
  Widget _buildGetStartedPage() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
            left: 12.w,
            right: 12.w,
            top: 40.h,
            bottom: 40.h), //! Padding around the content
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, //! Space between widgets
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment
                  .center, //! Center alignment for get started content
              crossAxisAlignment:
                  CrossAxisAlignment.center, //! Cross-axis center alignment
              children: [
                SizedBox(
                  height: 50.h, //! Space between top and image
                ),
                SizedBox(
                  height: 250.h, //! Image height
                  width: double.infinity, //! Image width to fill container
                  child: Image.asset('assets/h_s.png'), //! Get Started image
                ),
                TextSpanWidget2(
                    headingText:
                        'Get key to your dream home', //! Heading for the Get Started page
                    subheadingText1:
                        "If you have found your dream home, make an", //! First subheading for Get Started
                    subheadingText2:
                        "offer and get the key of your dream home", //! Second subheading
                    subheadingText3: 'and start living.'), //! Third subheading
              ],
            ),
            MyButton(
                onTap: () {
                  Get.toNamed(RouteName
                      .loginScreen); //! Navigate to login screen on tap
                },
                text: 'Get Started'), //! Button to go to login screen
          ],
        ),
      ),
    );
  }
}
