import 'package:apartment_rentals/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../../res/routes/routes_name.dart';
import '../../services/user_session.dart';

class AuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref('user');

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set setLoading(newVal) {
    _isLoading.value = newVal;
  }

  //! Sign Up Function
  Future<dynamic> signUp(String name, String email, String password,
      String role, String phone) async {
    try {
      setLoading = true;

      //! Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data to Firebase Realtime Database
      await _database.child(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'uid': userCredential.user!.uid,
        'phone': phone,
        'address': '',
        'role': role, // Save the user's role (renter or landlord)
        'gender': '',
        'profilePic':
            "https://play-lh.googleusercontent.com/4t7_uRj7B2YwIWBSMDsvET1X0v1w5-Z06NDhDQ2Cd_Vv-VOAw0ZcC_d5xHqFhf1Y2g=w526-h296-rw",
      });

      // Show success message and navigate back
      Utils().doneSnackBar('Sign-up successful!');
      Get.toNamed(RouteName.loginScreen);
    } on FirebaseAuthException catch (e) {
      // Show error message
      setLoading = false;
      Utils().errorSnackBar(e.toString());
    } finally {
      setLoading = false;
    }
  }

  Future<dynamic> login(String email, String password) async {
    try {
      setLoading = true;

      // Sign in user with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch user data from the database
      var userData = await _database.child(userCredential.user!.uid).get();

      if (userData.exists) {
        String role = userData.child('role').value.toString();

        // Store user ID and role in session controller
        SessionController().userId = userCredential.user!.uid;
        UserPreference().saveUserRole(role);

        debugPrint('Login role:$role');
        debugPrint(
            'Login session data stored: role=${UserPreference().getUserRole().toString()}, uid=${userCredential.user!.uid}');

        // Navigate to the dashboard
        Get.offAndToNamed(RouteName.dashBord);
      } else {
        Utils().errorSnackBar('User data not found. Please try again.');
      }
    } on FirebaseAuthException catch (e) {
      setLoading = false;
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        default:
          errorMessage = e.message ?? 'An error occurred during login.';
      }
      Utils().errorSnackBar(errorMessage);
    } catch (e) {
      setLoading = false;
      Utils().errorSnackBar('An unexpected error occurred. Please try again.');
    } finally {
      setLoading = false;
    }
  }

  //! Logout Function
  Future<void> logout() async {
    await _auth.signOut();
    SessionController().userId = null; // Clear user session
    UserPreference().removeUserRole();
    Hive.box('apartmentCache').clear().then(
          (value) => debugPrint('delete hive'),
        );
    Get.offAndToNamed(RouteName.loginScreen); // Navigate back to login screen
  }

  Future<void> forgotPassword(String email) async {
    try {
      setLoading = true;
      await _auth.sendPasswordResetEmail(email: email);
      Utils().doneSnackBar('Password reset email sent. Please check your inbox.');
    } on FirebaseAuthException catch (e) {
      setLoading = false;
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        default:
          errorMessage = e.message ?? 'An error occurred during password reset.';
      }
      Utils().errorSnackBar(errorMessage);
    } catch (e) {
      setLoading = false;
      Utils().errorSnackBar('An unexpected error occurred. Please try again.');
    } finally {
      setLoading = false;
    }
  }
}
