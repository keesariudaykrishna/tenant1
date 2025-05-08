import 'package:flutter/material.dart';

import '../../../res/app_widgets/text.dart';
import '../../../res/colors.dart';

class PriceTextWidget extends StatelessWidget {
  const PriceTextWidget({
    super.key,
    required this.price,
  });

  final dynamic price;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 25,
        bottom: 25,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.body5Bold(
              'Rent',
              color: kPrimary,
            ),
            SizedBox(
              height: 5,
            ),
            AppText.body4Bold(
              'PKR $price/month',
              color: kPrimary,
            )
          ],
        ));
  }
}
