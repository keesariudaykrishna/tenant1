// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../res/enum.dart';
import '../../../utils/utils.dart';
import '../../services/user_session.dart';

class RequestController extends GetxController {
  final DatabaseReference _database = FirebaseDatabase.instance.ref('request');
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set setLoading(val) {
    _isLoading.value = val;
  }

  Future<void> request(
    String ownerId,
    String appartmentId,
    // RequestStatus requestStatus,
  ) async {
    final userId = SessionController().userId.toString();
    final uuid = Uuid().v4();

    final DatabaseReference userApartmentRef = _database.child(uuid);
    final isNotify = false;
    DateTime date = DateTime.now();

    try {
      setLoading = true;
      //! Convert DateTime to ISO 8601 String format
      final String formattedDate = date.toIso8601String();

      //! Set the apartment data in Firebase
      await userApartmentRef.set({
        'uuid': uuid,
        'ownerId': ownerId,
        'renterId': userId,
        'date': formattedDate, // Store the date as a string
        'updateAt': formattedDate, // Store the date as a string
        'appartmentId': appartmentId,
        'isNotify': isNotify,
        'requestStatus': RequestStatus.pending.toString().split('.').last
        // .toString()
        // .split('.')
        // .last, // Save the status as a string
      });
      setLoading = false;

      //! Show success message
      Utils().doneSnackBar('Request Sent Successfully');
    } catch (e) {
      setLoading = false;

      //! Show error message if any exception occurs
      Utils().errorSnackBar('Error: $e');
    }
  }

  Future<void> updateRequest(
      String requestId, String requestStatus, String message) async {
    setLoading = true;
    try {
      await _database.child(requestId).update({
        'requestStatus': requestStatus,
      }).then(
        (value) {
          setLoading = false;
          Utils().doneSnackBar(message);
        },
      );
    } catch (e) {
      setLoading = false;
      Utils().errorSnackBar('Error: $e');
    } finally {
      setLoading = false;
    }
  }

  final DatabaseReference userdatabase = FirebaseDatabase.instance.ref('user');

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final DataSnapshot snapshot = await userdatabase.child(uid).get();
      if (snapshot.exists) {
        // Convert snapshot to Map
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        return data;
      } else {
        if (kDebugMode) {
          print("No data found for UID: $uid");
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving data: $e");
      }
      return null;
    }
  }
}
