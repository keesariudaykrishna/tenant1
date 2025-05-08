import 'package:apartment_rentals/res/app_widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoCol extends StatelessWidget {
  final String tile;
  final String name;
  final IconData icon;

  const InfoCol({
    super.key,
    required this.tile,
    required this.name,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                icon,
                size: 30.spMin,
              ),
              SizedBox(
                width: 10.w,
              ),
              AppText.body4Bold(tile)
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.h, bottom: 20.h, left: 8.w),
            child: AppText.body3(name),
          ),
        ],
      ),
    );
  }
}
