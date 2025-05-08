import 'package:apartment_rentals/res/app_widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../res/colors.dart';

class AppartmentCardWidget extends StatelessWidget {
  final String image; //! Image URL for the apartment
  final String address; //! Address of the apartment
  final String price; //! Price of the apartment
  final String bedRooms; //! Number of bedrooms
  final String bathRooms; //! Number of bathrooms
  final String roomType; //! Type of the room (e.g., Studio, 1BHK, etc.)
  final VoidCallback? onTap; //! Optional callback for when the card is tapped
  final bool isAvailable; //!

  const AppartmentCardWidget({
    super.key,
    required this.image,
    required this.address,
    required this.price,
    this.onTap,
    required this.bedRooms,
    required this.bathRooms,
    required this.roomType,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, //! Trigger the onTap callback when the card is tapped
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 5.h,
        ),
        child: Card(
          color: kPrimaryLight2, //! Card background color
          elevation: 2, //! Shadow for the card
          child: Stack(
            children: [
              Container(
                // height: 295.h, //! Height of the apartment card
                width: double.infinity, //! Full width of the card
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), //! Rounded corners
                ),
                child: Padding(
                  padding: EdgeInsets.all(5.h),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 3.h), //! Padding around the image
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              12), //! Rounded corners for the image
                          child: SizedBox(
                            height: 175.h, //! Height of the image
                            width: double.infinity, //! Full width for the image
                            child: CachedNetworkImage(
                              imageUrl: image.isNotEmpty
                                  ? image
                                  : '', // Provide an empty string if the image is null or empty
                              fit: BoxFit.fitWidth,
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => Icon(
                                Icons
                                    .broken_image, // The icon to show when the image is null or fails to load
                                size: 50, // Adjust size as needed
                                color: Colors.grey, // Adjust color as needed
                              ),
                            ),

                            //  Image.network(
                            //   image, //! Image URL
                            //   fit: BoxFit
                            //       .fitWidth, //! Make sure the image covers the area
                            //   errorBuilder: (context, error, stackTrace) {
                            //     return const Icon(Icons
                            //         .error); //! Show an error icon if the image fails to load
                            //   },
                            // ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w), //! Padding for the text
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment
                              .start, //! Align children to the start
                          crossAxisAlignment: CrossAxisAlignment
                              .start, //! Align children to the start on the cross-axis
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Rs.$price/month', //! Price text
                                    style: TextStyle(
                                        fontWeight: FontWeight
                                            .bold, //! Bold font weight for the price
                                        fontSize: 20
                                            .spMin, //! Font size for the price
                                        color:
                                            kSecondaryLight), //! Price text color
                                  ),
                                  Icon(
                                    isAvailable
                                        ? Icons.check_circle
                                        : Icons.do_disturb,
                                    color:
                                        isAvailable ? kSecondary2 : Colors.red,
                                  )
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                spacing: 40, //! Space between the icons
                                mainAxisAlignment: MainAxisAlignment
                                    .start, //! Align children to the start
                                children: [
                                  RowIconAndText(
                                      text: bedRooms,
                                      icon: Icons
                                          .king_bed_outlined), //! Display number of bedrooms with an icon
                                  RowIconAndText(
                                      text: bathRooms,
                                      icon: Icons
                                          .bathtub_outlined), //! Display number of bathrooms with an icon
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: RowIconAndText(
                                  text: address,
                                  icon: Icons.location_on_outlined),
                            ), //! Display address with an icon
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: 25.h, //! Position the room type label
                  left: 25.w, //! Position the label from the left
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4), //! Add horizontal padding
                    decoration: BoxDecoration(
                      color:
                          kSecondary2, //! Background color for the room type label
                      borderRadius: BorderRadius.all(
                          Radius.circular(12)), //! Rounded corners
                    ),
                    child: Center(
                      child: AppText.bodyBold(
                        roomType, //! Display the room type text
                        color: kPrimary, //! Text color for the room type label
                      ),
                    ),
                  )

                  //  Container(
                  //   height: 30, //! Height of the room type label
                  //   width: 80.w, //! Width of the room type label
                  //   decoration: BoxDecoration(
                  //       color:
                  //           kSecondary2, //! Background color for the room type label
                  //       borderRadius: BorderRadius.all(Radius.circular(
                  //           12))), //! Rounded corners for the label
                  //   child: Center(
                  //     child: AppText.bodyBold(
                  //       roomType, //! Display the room type text
                  //       color: kPrimary, //! Text color for the room type label
                  //     ),
                  //   ),
                  // ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class RowIconAndText extends StatelessWidget {
  final String text; //! Text for the row (e.g., number of rooms)
  final IconData
      icon; //! Icon associated with the text (e.g., bed, bath, location)

  const RowIconAndText({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: 5, //! Space between the icon and text
        children: [
          Icon(icon), //! Display the icon
          Text(
            text, //! Display the text next to the icon
            style: TextStyle(
                fontWeight: FontWeight.w700, //! Font weight for the text
                fontSize: 16.spMin, //! Font size for the text
                color: kGray), //! Color of the text
          ),
        ],
      ),
    );
  }
}
