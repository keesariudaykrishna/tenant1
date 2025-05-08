import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../res/app_widgets/text.dart';
import '../../../res/colors.dart';
import 'row_icon_text.dart';

class PropertiesDetailsWidget extends StatelessWidget {
  const PropertiesDetailsWidget({
    super.key,
    required this.bed,
    required this.bath,
    required this.houseNumber,
    required this.floor,
    this.livingRoom,
    this.area,
  });

  final dynamic bed;
  final dynamic bath;
  final dynamic houseNumber;
  final dynamic floor;
  final dynamic livingRoom;
  final dynamic area;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      child: Center(
        child: Wrap(
          spacing: 60.w, // Horizontal spacing between children
          runSpacing: 30.h, // Vertical spacing between rows
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RowIconText(
                  text: bed,
                  icon: FontAwesomeIcons.bed,
                ),
                SizedBox(height: 4),
                AppText.body3Bold(
                  'BedRoom',
                  color: kGray2,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RowIconText(
                  text: bath,
                  icon: FontAwesomeIcons.bath,
                ),
                SizedBox(height: 4),
                AppText.body3Bold(
                  'BathRoom',
                  color: kGray2,
                ),
              ],
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RowIconText(
                  text: livingRoom,
                  icon: FontAwesomeIcons.couch,
                ),
                SizedBox(height: 4),
                AppText.body3Bold(
                  'LivingRoom',
                  color: kGray2,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RowIconText(
                  text: area,
                  icon: Icons.square_foot,
                ),
                SizedBox(height: 4),
                AppText.body3Bold(
                  'Area',
                  color: kGray2,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RowIconText(
                  text: 'House $houseNumber',
                  icon: FontAwesomeIcons.house,
                ),
                SizedBox(height: 4),
                AppText.body3Bold(
                  'House No',
                  color: kGray2,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RowIconText(
                  text: 'Floor $floor',
                  icon: FontAwesomeIcons.houseTsunami,
                ),
                SizedBox(height: 4),
                AppText.body3Bold(
                  'Floor No',
                  color: kGray2,
                ),
              ],
            ),
            // Add more containers as needed
          ],
        ),
      ),
    );
  }
}
