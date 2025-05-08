// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:apartment_rentals/view_models/services/user_session.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../details/details_view.dart';
import '../home/widgets/appartment_card.dart';
import 'my_property_details_view.dart';

class FirstView extends StatelessWidget {
  final bool isAvailable;
  const FirstView({super.key, required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    late Stream<DatabaseEvent> _apartmentsStream;

    _apartmentsStream =
        FirebaseDatabase.instance.ref('apartments').onValue.asBroadcastStream();
    return StreamBuilder<DatabaseEvent>(
      stream: _apartmentsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
          return const Center(child: Text('No properties available.'));
        }

        Map<dynamic, dynamic> houseData =
            snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

        //! Filter apartments by userId and availability
        var filteredApartments = houseData.entries
            .where((entry) =>
                entry.value['userId'] == SessionController().userId &&
                entry.value['available'] == isAvailable)
            .toList();

        if (filteredApartments.isEmpty) {
          return const Center(child: Text('No properties available.'));
        }

        return ListView.builder(
          itemCount: filteredApartments.length,
          itemBuilder: (context, index) {
            final apartment = filteredApartments[index].value;
            final address = apartment['address'] ?? 'No address';
            final price = apartment['price'] ?? 'No price available';
            final bedRooms = apartment['noBed'] ?? '';
            final bathRooms = apartment['noBath'] ?? '';
            final roomType = apartment['roomType'] ?? '';
            final available = apartment['available'] ?? '';
            final apartmentId = filteredApartments[index].key;

            List<dynamic> mediaUrls = apartment['mediaUrls'] ?? [];

            // Filter to only get image URLs
            String imageUrl = mediaUrls.firstWhere(
              (url) =>
                  url.endsWith('.jpg') ||
                  url.endsWith('.jpeg') ||
                  url.endsWith('.png'),
              orElse: () => '', // If no image URL, return an empty string
            );

            return AppartmentCardWidget(
              isAvailable: available,
              image: imageUrl,
              address: address,
              price: price,
              bedRooms: bedRooms,
              bathRooms: bathRooms,
              roomType: roomType,
              onTap: () {
                isAvailable
                    ? Get.to(() => ApartmentDetailsScreen(
                          apartmentId: apartmentId,
                          btn: false,
                        ))
                    : Get.to(() => RentedApartmentDetailsScreen(
                          apartmentId: apartmentId,
                        ));
              },
            );
          },
        );
      },
    );
  }
}
