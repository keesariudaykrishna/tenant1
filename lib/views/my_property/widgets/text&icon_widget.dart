// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../res/app_widgets/text.dart';
import '../../../res/colors.dart';

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
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText.bodyBold(title, color: kGray2),
          AppText.body3(data),
        ],
      ),
    );
  }
}

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
    return Row(
      spacing: 15,
      children: [
        Icon(icon),
        AppText.body3Bold(
          text,
          color: kGray2,
        )
      ],
    );
  }
}
