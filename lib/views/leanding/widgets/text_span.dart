import 'package:apartment_rentals/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextSpanWidget extends StatelessWidget {
  const TextSpanWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5, //! Spacing between the widgets inside the column
      children: [
        Text(
          'Search your dream house', //! Heading text
          style: TextStyle(
              color: kSecondary, //! Color for the heading text
              fontSize: 30.spMin, //! Font size for the heading
              fontWeight: FontWeight.bold), //! Bold style for the heading
        ),
        SizedBox(
          height: 10, //! Space below the heading text
        ),
        RichText(
          textAlign: TextAlign.center, //! Align the text to center
          text: TextSpan(
            text: 'By ', //! Text at the beginning of the paragraph
            style: TextStyle(
                color: kGray, //! Text color for the starting text
                fontSize: 20.spMin, //! Font size for the starting text
                fontWeight:
                    FontWeight.w500), //! Font weight for the starting text
            children: <TextSpan>[
              TextSpan(
                text: 'Safe Havens, ', //! Highlighted brand name text
                style: TextStyle(
                    color: kSecondaryLight, //! Color for the highlighted brand
                    fontSize: 20.spMin, //! Font size for the brand name
                    fontWeight:
                        FontWeight.w600), //! Font weight for the brand name
              ),
              TextSpan(
                text: 'you can narrow down your\n', //! Description text
                style: TextStyle(
                    color: kGray, //! Color for description text
                    fontSize: 20.spMin, //! Font size for description text
                    fontWeight:
                        FontWeight.w500), //! Font weight for description text
              ),
              TextSpan(
                text:
                    'search and find a home that meet your\n', //! Description continuation
                style: TextStyle(
                    color: kGray, //! Color for the continuation text
                    fontSize: 20.spMin, //! Font size for continuation
                    fontWeight:
                        FontWeight.w500), //! Font weight for continuation text
              ),
              TextSpan(
                text: 'needs and desires\n', //! Final text in the paragraph
                style: TextStyle(
                    color: kGray, //! Text color for final line
                    fontSize: 20.spMin, //! Font size for final line
                    fontWeight: FontWeight.w500), //! Font weight for final line
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TextSpanWidget2 extends StatelessWidget {
  final String headingText; //! Heading text that is passed dynamically
  final String subheadingText1; //! First subheading text passed dynamically
  final String subheadingText2; //! Second subheading text passed dynamically
  final String subheadingText3; //! Third subheading text passed dynamically
  const TextSpanWidget2({
    super.key,
    required this.headingText,
    required this.subheadingText1,
    required this.subheadingText2,
    required this.subheadingText3,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5, //! Spacing between the widgets inside the column
      children: [
        Text(
          headingText, //! Dynamic heading text
          style: TextStyle(
              color: kSecondary, //! Color for the heading text
              fontSize: 30.spMin, //! Font size for the heading text
              fontWeight: FontWeight.bold), //! Font weight for the heading text
        ),
        SizedBox(
          height: 10, //! Space below the heading text
        ),
        RichText(
          textAlign: TextAlign.center, //! Align text to the center
          text: TextSpan(
            text: '$subheadingText1\n', //! First subheading text
            style: TextStyle(
                color: kGray, //! Color for subheading text
                fontSize: 20.spMin, //! Font size for subheading text
                fontWeight:
                    FontWeight.w500), //! Font weight for subheading text
            children: <TextSpan>[
              TextSpan(
                text: '$subheadingText2 \n', //! Second subheading text
                style: TextStyle(
                    color: kGray, //! Color for second subheading text
                    fontSize: 20.spMin, //! Font size for second subheading text
                    fontWeight:
                        FontWeight.w500), //! Font weight for second subheading
              ),
              TextSpan(
                text: '$subheadingText3 \n', //! Third subheading text
                style: TextStyle(
                    color: kGray, //! Color for third subheading text
                    fontSize: 20.spMin, //! Font size for third subheading text
                    fontWeight:
                        FontWeight.w500), //! Font weight for third subheading
              ),
            ],
          ),
        ),
      ],
    );
  }
}
