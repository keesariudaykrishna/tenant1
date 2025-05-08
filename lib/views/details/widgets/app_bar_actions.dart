import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../res/colors.dart';
import '../details_view.dart';
import '../update_appartment_view.dart';

class UpdateAndDeleteWidget extends StatelessWidget {
  const UpdateAndDeleteWidget({
    super.key,
    required this.widget,
    required this.apartment,
    required this.ref,
  });

  final ApartmentDetailsScreen widget;
  final Map apartment;
  final DatabaseReference ref;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: kPrimary,
      onSelected: (value) {
        if (value == 'update') {
          Get.to(
            () => UpdateApartmentScreen(apartmentId: widget.apartmentId),
            arguments: {'apartmentData': apartment},
          );
        } else if (value == 'delete') {
          // Implement delete functionality here
          ref.remove();
          Get.back();
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'update',
            child: Row(
              children: const [
                Icon(
                  Icons.edit,
                  size: 20,
                  color: Colors.green,
                ),
                SizedBox(width: 8),
                Text('Update'),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'delete',
            child: Row(
              children: const [
                Icon(
                  Icons.delete,
                  size: 20,
                  color: Colors.red,
                ),
                SizedBox(width: 8),
                Text('Delete'),
              ],
            ),
          ),
        ];
      },
      icon: Icon(
        Icons.more_vert_outlined,
        // color: kSecondary2,
        color: kPrimary,
        size: 40.spMin,
      ),
    );
  }
}
