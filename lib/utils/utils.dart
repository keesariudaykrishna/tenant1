// ignore_for_file: deprecated_member_use

import 'package:apartment_rentals/res/app_widgets/button.dart';
import 'package:apartment_rentals/views/details/details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import '../res/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math';

import '../view_models/controllers/map/map_view_model.dart';
import '../views/maps/widgets/row_icon&text_widget.dart'; // For Cupertino Widgets if necessary.

class Utils {
  void doneSnackBar(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: kSecondaryLight3,
      colorText: kDark,
      icon: Icon(
        Icons.done_all,
        color: Colors.green,
      ),
    );
  }

  void noteSnackBar(String message) {
    Get.snackbar(
      'Note',
      message,
      backgroundColor: kSecondaryLight3,
      colorText: kDark,
      icon: Icon(
        Icons.note,
        color: kSecondary2,
      ),
    );
  }

  void fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void errorSnackBar(String message) {
    // Delaying snackbar show until after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.snackbar(
        'Error',
        message,
        backgroundColor: kSecondaryLight,
        colorText: kDark,
        icon: Icon(
          Icons.error_rounded,
          color: kSecondary,
        ),
      );
    });
  }

  String formatTimestamp(DateTime timestamp) {
    return DateFormat('h:mm a').format(timestamp); // Just the time
  }

  String formatDate(DateTime timestamp) {
    return DateFormat('MMM dd, yyyy').format(timestamp); // Date format
  }

  bool isToday(DateTime timestamp) {
    final now = DateTime.now();
    return now.year == timestamp.year &&
        now.month == timestamp.month &&
        now.day == timestamp.day;
  }
}

List<String> houseTypes = [
  "Apartment",
  "Bungalow",
  "Cottage",
  "Duplex",
  "Mansion",
  "Townhouse",
  "Villa",
  "Penthouse",
  "Studio",
  "Loft",
  "Condominium",
  "Ranch",
  "Cabin",
  "Farmhouse",
  "Mobile Home",
  "Row House",
  "Tiny House",
  "Carriage House",
  "Chalet",
  "Split-Level",
  "Victorian",
  "Colonial",
  "Georgian",
  "Craftsman",
  "Modern",
  "Mediterranean",
  "Tudor",
  "A-Frame",
  "Container Home",
  "Earthship",
  "Treehouse",
  "Houseboat",
  "Yurt",
  "Igloo",
  "Pagoda",
  "Hut"
];
List<String> houseTypes2 = [
  "Apartment",
  "Cottage",
  "Duplex",
  "Mansion",
  "Townhouse",
  "Penthouse",
  "Tiny House",
  "Modern",
];

class MapUtils {
  // Function to show the apartment details in a modal bottom sheet
  static void showApartmentDetails(
      BuildContext context, Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(12.h),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      child: Container(
                        height: 100.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: data['imageUrl'] ??
                              'https://images.pexels.com/photos/439391/pexels-photo-439391.jpeg?auto=compress&cs=tinysrgb&w=600',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RowIconAndText(
                            title: 'Location',
                            icon: Icons.location_on,
                            data: data['address'] ?? 'N/A',
                          ),
                          RowIconAndText(
                            icon: Icons.business_rounded,
                            data: data['floor'] ?? 'N/A',
                            title: 'Floor no:',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: MyButton(
                          onTap: () {
                            //! clicked, open Google Maps with directions
                            _openGoogleMapsForDirections(data);
                            //! Close the bottom sheet
                            Navigator.pop(context);
                          },
                          text: 'Get Directions'),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Expanded(
                      child: MyButton(
                          onTap: () {
                            Get.to(() => ApartmentDetailsScreen(
                                  apartmentId: data['uuid'],
                                ));
                          },
                          text: 'Details'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to open Google Maps for directions
  static void _openGoogleMapsForDirections(Map<String, dynamic> data) async {
    final double destinationLat = data['location'].latitude;
    final double destinationLng = data['location'].longitude;
    final MapsController mapController = Get.put(MapsController());

    final String currentLat = mapController.latitude.value.toString();
    final String currentLng = mapController.longitude.value.toString();

    final String googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&origin=$currentLat,$currentLng&destination=$destinationLat,$destinationLng&travelmode=driving"; // Change `travelmode` if needed

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      Get.snackbar('Error', 'Could not open Google Maps.');
    }
  }

  // Function to generate circle points (used for drawing circles around locations)
  static List<LatLng> generateCirclePoints(
      LatLng center, double radiusInMeters) {
    const int pointsCount = 50; // Number of points to form the circle
    final double radiusInKm = radiusInMeters / 1000.0; // Convert to kilometers
    final List<LatLng> circlePoints = [];
    final double angleStep = (2 * 3.14159265359) / pointsCount;

    for (int i = 0; i < pointsCount; i++) {
      final double angle = angleStep * i;
      final double latitudeOffset = radiusInKm / 111.32 * cos(angle);
      final double longitudeOffset = radiusInKm /
          (111.32 * cos(center.latitude * (3.14159265359 / 180))) *
          sin(angle);

      circlePoints.add(LatLng(
        center.latitude + latitudeOffset,
        center.longitude + longitudeOffset,
      ));
    }

    return circlePoints;
  }
}
