import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle style;

  AppText.heading(this.text, {super.key, Color? color})
      : style = TextStyle(
          fontSize: 24.spMin,
          fontWeight: FontWeight.bold,
          color: color ?? Colors.black,
        );

  AppText.subHeading(this.text, {super.key, Color? color})
      : style = TextStyle(
          fontSize: 20.spMin,
          fontWeight: FontWeight.w600,
          color: color ?? Colors.black54,
        );

  AppText.body(this.text, {super.key, Color? color})
      : style = TextStyle(
          fontSize: 16.spMin,
          fontWeight: FontWeight.normal,
          color: color ?? Colors.black,
        );
  AppText.bodyLittel(this.text, {super.key, Color? color})
      : style = TextStyle(
          fontSize: 9.spMin,
          fontWeight: FontWeight.normal,
          color: color ?? Colors.black,
        );
  AppText.bodyBold(this.text, {super.key, Color? color})
      : style = TextStyle(
          fontSize: 16.spMin,
          fontWeight: FontWeight.bold,
          color: color ?? Colors.black,
        );

  AppText.body1(this.text, {super.key, Color? color})
      : style = TextStyle(
          fontSize: 14.spMin,
          fontWeight: FontWeight.normal,
          color: color ?? Colors.black87,
        );
  AppText.body1Bold(this.text, {super.key, Color? color})
      : style = TextStyle(
          fontSize: 14.spMin,
          fontWeight: FontWeight.bold,
          color: color ?? Colors.black87,
        );
  AppText.body3(this.text, {super.key, Color? color})
      : style = TextStyle(
          fontSize: 16.spMin,
          fontWeight: FontWeight.normal,
          color: color ?? Colors.black87,
        );
  AppText.body3Bold(this.text, {super.key, Color? color})
      : style = TextStyle(
            fontSize: 16.spMin,
            fontWeight: FontWeight.bold,
            color: color ?? Colors.black87,
            overflow: TextOverflow.fade);
  AppText.body4Bold(this.text, {super.key, Color? color})
      : style = TextStyle(
          fontSize: 20.spMin,
          fontWeight: FontWeight.bold,
          color: color ?? Colors.black87,
        );
  AppText.body4(this.text, {super.key, Color? color})
      : style = TextStyle(
            fontSize: 20.spMin,
            fontWeight: FontWeight.normal,
            color: color ?? Colors.black87,
            overflow: TextOverflow.fade);
  AppText.body5Bold(this.text, {super.key, Color? color})
      : style = TextStyle(
          fontSize: 25.spMin,
          fontWeight: FontWeight.bold,
          color: color ?? Colors.black87,
        );
  AppText.body5(this.text, {super.key, Color? color})
      : style = TextStyle(
            fontSize: 25.spMin,
            fontWeight: FontWeight.normal,
            color: color ?? Colors.black87,
            overflow: TextOverflow.fade);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
    );
  }
}
