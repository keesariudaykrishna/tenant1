// import 'dart:async';

// import 'package:apartment_rentals/landload_dash_bord.dart';
// import 'package:apartment_rentals/renter_dash_bord.dart';
// import 'package:apartment_rentals/res/routes/routes_name.dart';
// import 'package:apartment_rentals/utils/utils.dart';
// import 'package:apartment_rentals/view_models/services/user_session.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../views/leanding/leanding_view.dart';

// class SplashServices {
//   final FirebaseAuth auth = FirebaseAuth.instance; // Firebase Auth instance
//   final DatabaseReference database = FirebaseDatabase.instance
//       .ref('user'); // Firebase Realtime Database instance

//   //! Method to check if the user is logged in or it's the first time the app is launched
//   Future<void> isLogin(BuildContext context) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool isFirstTime =
//         prefs.getBool('isFirstTime') ?? true; // Check if it's the first time

//     // !If it's the first time, set isFirstTime to false and proceed to the landing page
//     if (isFirstTime) {
//       prefs.setBool('isFirstTime', false); // Mark the app as not the first time
//       Timer(Duration(seconds: 3), () {
//         Get.to(() => LandingPage()); // Navigate to LandingPage after 3 seconds
//       });
//     } else {
//       // If not first time, check if the user is logged in
//       final user = auth.currentUser;

//       if (user != null) {
//         //! User is signed in
//         SessionController().userId =
//             user.uid.toString(); // Save user ID in session controller

//         //! Retrieve the role of the user from Firebase Realtime Database
//         database.child(user.uid).child('role').get().then((snapshot) {
//           if (kDebugMode) {
//             print(user.uid); // Print user ID for debugging
//             print(snapshot.value.toString()); // Print role for debugging
//           }

//           // Depending on the role, navigate to the corresponding dashboard
//           if (snapshot.value == 'Renter') {
//             Timer(Duration(seconds: 3), () {
//               Get.to(() => RenterDashBord()); // Navigate to Renter Dashboard
//             });
//           } else if (snapshot.value == 'Landlord') {
//             Timer(Duration(seconds: 3), () {
//               Get.to(() =>
//                   LandlordDashBord()); // Navigate to Landlord Dashboard (same as Renter for now)
//             });
//           } else {
//             // If no valid role, show an error and navigate to login
//             Get.snackbar(
//               'Error',
//               'User does not have a role assigned',
//               snackPosition: SnackPosition.BOTTOM,
//             );
//             Timer(
//                 Duration(seconds: 3), () => Get.toNamed(RouteName.loginScreen));
//           }
//         }).catchError((error) {
//           //! Handle errors during role retrieval
//           Utils().errorSnackBar(
//               'Failed to retrieve user data: ${error.toString()}');

//           // Navigate to login screen after error
//           Timer(Duration(seconds: 3), () => Get.toNamed(RouteName.loginScreen));
//           if (kDebugMode) {
//             print(error.toString()); // Print error for debugging
//           }
//         });
//       } else {
//         //! User is not signed in, navigate to login screen
//         Timer(Duration(seconds: 3), () => Get.toNamed(RouteName.loginScreen));
//       }
//     }
//   }
// }

import 'dart:async';

import 'package:apartment_rentals/res/routes/routes_name.dart';
import 'package:apartment_rentals/view_models/services/user_session.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../views/leanding/leanding_view.dart';
import '../controllers/home/home_view_model.dart';

class SplashServices {
  final FirebaseAuth auth = FirebaseAuth.instance; // Firebase Auth instance

  //! Method to check if the user is logged in or it's the first time the app is launched
  Future<void> isLogin(BuildContext context) async {
    Get.put(HomeController());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime =
        prefs.getBool('isFirstTime') ?? true; // Check if it's the first time

    // !If it's the first time, set isFirstTime to false and proceed to the landing page
    if (isFirstTime) {
      prefs.setBool('isFirstTime', false); // Mark the app as not the first time
      Timer(Duration(seconds: 3), () {
        Get.to(() => LandingPage()); // Navigate to LandingPage after 3 seconds
      });
    } else {
      // If not first time, check if the user is logged in
      final user = auth.currentUser;

      if (user != null) {
        //! User is signed in
        String? userRole = await UserPreference().getUserRole();

        SessionController().userId =
            user.uid.toString(); // Save user ID in session controller
        debugPrint(
            'this login session in splash screen:${SessionController().userId},${userRole.toString()}');

        // Navigate directly to the dashboard without checking the role
        Timer(Duration(seconds: 3), () {
          Get.offAndToNamed(RouteName.dashBord); // Default to Renter Dashboard
        });
      } else {
        //! User is not signed in, navigate to login screen
        Timer(Duration(seconds: 3),
            () => Get.offAndToNamed(RouteName.loginScreen));
      }
    }
  }
}
