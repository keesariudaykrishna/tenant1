import 'package:apartment_rentals/res/app_widgets/button.dart';
import 'package:apartment_rentals/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:apartment_rentals/res/app_widgets/text.dart';
import 'package:apartment_rentals/res/colors.dart';
import 'package:intl/intl.dart';

import 'widgets/text&icon_widget.dart';

class RentedApartmentDetailsScreen extends StatefulWidget {
  final String apartmentId;
  const RentedApartmentDetailsScreen({super.key, required this.apartmentId});

  @override
  State<RentedApartmentDetailsScreen> createState() =>
      _RentedApartmentDetailsScreenState();
}

class _RentedApartmentDetailsScreenState
    extends State<RentedApartmentDetailsScreen> {
  final DatabaseReference apartmentRef =
      FirebaseDatabase.instance.ref('apartments');
  final DatabaseReference requestRef = FirebaseDatabase.instance.ref('request');
  final DatabaseReference userRef = FirebaseDatabase.instance.ref('user');

  Future<Map<String, dynamic>> fetchData() async {
    try {
      // Fetch apartment data
      final apartmentSnapshot =
          await apartmentRef.child(widget.apartmentId).get();

      if (apartmentSnapshot.exists) {
        final apartmentData = apartmentSnapshot.value as Map<dynamic, dynamic>;

        // Fetch request data
        final requestSnapshot = await requestRef.get();
        if (requestSnapshot.exists) {
          final requestData = requestSnapshot.value as Map<dynamic, dynamic>;

          // Filter for the current apartmentId and accepted requests
          final filteredRequests = requestData.entries
              .map((entry) => entry.value as Map<dynamic, dynamic>)
              .where((request) =>
                  request['appartmentId'] == widget.apartmentId &&
                  request['requestStatus'] == 'accepted')
              .toList();

          if (filteredRequests.isNotEmpty) {
            final renterId = filteredRequests.first['renterId'];

            // Fetch user details for the renter
            final userSnapshot = await userRef.child(renterId).get();
            if (userSnapshot.exists) {
              final userData = userSnapshot.value as Map<dynamic, dynamic>;

              return {
                'apartment': apartmentData,
                'request': filteredRequests.first,
                'user': userData,
              };
            }
          }
        }

        return {'apartment': apartmentData};
      }
    } catch (e) {
      Utils().errorSnackBar('Error fetching data: $e');
    }

    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final apartmentData = snapshot.data!['apartment'];
            final requestData = snapshot.data!['request'];
            final userData = snapshot.data!['user'];

            final apartmentId = apartmentData['uuid'] ?? 'N/A';
            final description = apartmentData['description'] ?? 'N/A';
            final address = apartmentData['address'] ?? 'N/A';
            final price = apartmentData['price'] ?? 'N/A';
            final imageUrl = apartmentData['imageUrl'] ?? 'N/A';
            final bed = apartmentData['noBed'] ?? 'N/A';
            final bath = apartmentData['noBath'] ?? 'N/A';
            final name = userData['name'] ?? 'N/A';
            final email = userData['email'] ?? 'N/A';
            final phone = userData['phone'] ?? 'N/A';
            final requestStatus = requestData['requestStatus'] ?? 'N/A';
            final rawDate = requestData['date'] ?? 'N/A';
            String formattedDate = 'N/A';

            if (rawDate != 'N/A') {
              try {
                // Parse the raw date string (assuming it follows a standard format like 'yyyy-MM-dd')
                DateTime parsedDate = DateTime.parse(rawDate);
                // Format the parsed date to 'd MMM yyyy' (e.g., '10 Sep 2025')
                formattedDate = DateFormat('d MMM yyyy').format(parsedDate);
              } catch (e) {
                // print('Error parsing date: $e');
                formattedDate = 'Invalid Date';
              }
            }

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 200.h,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: imageUrl != 'N/A'
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.home, size: 100),
                          )
                        : const Icon(Icons.home, size: 100),
                  ),
                  leading: IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: kDark,
                      size: 30,
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(16.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.subHeading('Rs.$price / month'),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  RowIconText(
                                    text: '$bed Bed',
                                    icon: Icons.king_bed_rounded,
                                  ),
                                  SizedBox(width: 10.w),
                                  RowIconText(
                                    text: '$bath Bath',
                                    icon: Icons.bathtub_sharp,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RowIconText(
                                  text: address, icon: Icons.location_on),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.h),
                              child: Divider(thickness: 3, color: kGray),
                            ),
                            AppText.subHeading('Description'),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AppText.body(description),
                            ),

                            // ! Renter Details
                            if (userData != null && requestData != null) ...[
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.h),
                                child: Divider(thickness: 4, color: kGray),
                              ),

                              AppText.subHeading('Renter Details'),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RowIconText(
                                        text: 'Name', icon: Icons.person),
                                    AppText.body(name)
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RowIconText(
                                        text: 'Phone', icon: Icons.phone),
                                    AppText.body(phone)
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RowIconText(
                                        text: 'Email', icon: Icons.email),
                                    AppText.body(email)
                                  ],
                                ),
                              ),
                              // ! Request Details

                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 5.h,
                                ),
                                child: Divider(thickness: 4, color: kGray),
                              ),

                              AppText.subHeading('Request Details'),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RowIconText(
                                              text: 'Request Date',
                                              icon: Icons.date_range),
                                          AppText.body(formattedDate),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RowIconText(
                                              text: 'Request Status',
                                              icon: Icons.check_circle),
                                          AppText.body(requestStatus),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                            SizedBox(
                              height: 10.h,
                            ),
                            MyButton(
                                onTap: () async {
                                  final ref = FirebaseDatabase.instance
                                      .ref('apartments')
                                      .child(apartmentId);
                                  await ref.update({'available': true});
                                  Get.back();
                                },
                                text: 'Unoccupied')
                          ],
                        ),
                      );
                    },
                    childCount: 1, // Adjust based on your dynamic content
                  ),
                ),
              ],
            );
          }

          return const Center(child: Text('No data found.'));
        },
      ),
    );
  }
}
