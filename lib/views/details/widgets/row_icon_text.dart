import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../res/app_widgets/text.dart';
import '../../../res/colors.dart';

class RowIconText extends StatelessWidget {
  final String text;
  final IconData icon;

  const RowIconText({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: kGray2,
            ),
            SizedBox(width: 15.w), // Add spacing between the icon and text
            SizedBox(child: AppText.body4Bold(text)),
          ],
        ),
      ),
    );
  }
}

class RowText extends StatelessWidget {
  const RowText({
    super.key,
    required this.data,
    required this.title,
  });

  final dynamic data;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.body4Bold(
            title,
            color: kDark,
          ),
          AppText.body4(data),
        ],
      ),
    );
  }
}
