import 'package:apartment_rentals/res/app_widgets/app_bar.dart';
import 'package:apartment_rentals/res/app_widgets/text.dart';
import 'package:apartment_rentals/res/colors.dart';
import 'package:apartment_rentals/views/details/details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SearchResultScreen extends StatelessWidget {
  final List apartments;

  const SearchResultScreen({super.key, required this.apartments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Results'),
      body: apartments.isEmpty
          ? Center(child: Text('No apartments found.'))
          : ListView.builder(
              itemCount: apartments.length,
              itemBuilder: (context, index) {
                final apartment = apartments[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Get.to(() => ApartmentDetailsScreen(
                          apartmentId: apartment['uuid']));
                    },
                    child: Card(
                      elevation: 4, // Optional: Adds shadow for better UI
                      child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: ListTile(
                            contentPadding:
                                EdgeInsets.zero, // Remove default padding
                            title: Text(apartment['address']),
                            subtitle: Text('Rs.${apartment['price']}'),
                            trailing: Container(
                              height: 25.h,
                              // Dynamically calculate width based on the text length
                              width: _getTextWidth(apartment['roomType']) +
                                  20.0, // Extra padding
                              decoration: BoxDecoration(
                                color: kSecondary2,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: AppText.body1(
                                    apartment['roomType'],
                                    color: kPrimary,
                                  ),
                                ),
                              ),
                            ),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                apartment['imageUrl'],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(Icons.error),
                                  );
                                },
                              ),
                            ),
                          )
                          // ListTile(
                          //
                          //
                          //   title: AppText.body3Bold(),
                          //   subtitle: AppText.body3(),
                          //   trailing: Container(
                          //     decoration: BoxDecoration(
                          //       color: kSecondary2,
                          //       borderRadius:
                          //           BorderRadius.all(Radius.circular(12)),
                          //     ),
                          //     child: Center(
                          //       child: Padding(
                          //         padding: EdgeInsets.all(5),
                          //         child: AppText.body1(
                          //           apartment['roomType'],
                          //           color: kPrimary,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// Function to calculate width of text
double _getTextWidth(String text) {
  final textStyle = TextStyle(fontSize: 14); // Match your text style
  final textPainter = TextPainter(
    text: TextSpan(text: text, style: textStyle),
    textDirection: TextDirection.ltr,
  );
  textPainter.layout();
  return textPainter.size.width;
}
