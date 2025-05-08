import 'package:apartment_rentals/res/app_widgets/button.dart';
import 'package:apartment_rentals/res/app_widgets/text.dart';
import 'package:apartment_rentals/res/colors.dart';
import 'package:apartment_rentals/res/enum.dart';
import 'package:apartment_rentals/views/details/details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../view_models/controllers/request/request_view_model.dart';
import '../chat/chat_view.dart';
import '../home/widgets/appartment_card.dart';

class MyRequestDetailsScreen extends StatefulWidget {
  final String requestId;
  const MyRequestDetailsScreen({super.key, required this.requestId});

  @override
  State<MyRequestDetailsScreen> createState() => _MyRequestDetailsScreenState();
}

class _MyRequestDetailsScreenState extends State<MyRequestDetailsScreen> {
  final RequestController _requestController = Get.put(RequestController());
  late final Map<String, dynamic> arguments;
  late final Map<String, dynamic> ownerData;
  late final Map<String, dynamic> apartmentData;
  late final Map<dynamic, dynamic> requestData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Access the arguments passed to the screen
    arguments = Get.arguments ?? {};
    ownerData = arguments['ownerData'] ?? {};
    apartmentData = arguments['apartmentData'] ?? {};
    requestData = arguments['requestData'] ?? {};
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.requestId);

    // Extract values for layout
    // Extract values for layout

    // Filter to only get image URLs
    List<dynamic> mediaUrls = apartmentData['mediaUrls'] ?? [];

    String imageUrl = mediaUrls.firstWhere(
      (url) =>
          url.endsWith('.jpg') || url.endsWith('.jpeg') || url.endsWith('.png'),
      orElse: () => '', // If no image URL, return an empty string
    );
    // print(widget.requestStatus);
    final String renterImage = (ownerData['profilePic'] as String?) ?? '';
    // final String address = apartmentData['address'] ?? 'N/A';
    // final String price = apartmentData['price'] ?? 'N/A';
    // final String bedRooms = apartmentData['bedRooms'] ?? 'N/A';
    // final String bathRooms = apartmentData['bathRooms'] ?? 'N/A';
    // final String roomType = apartmentData['roomType'] ?? 'N/A';

    // final String renterImage = ownerData['profilePic'];
    final String address = apartmentData['address'] ?? 'N/A';
    final String price = apartmentData['price'] ?? 'N/A';
    final String bedRooms = apartmentData['noBed'] ?? 'N/A';
    final String bathRooms = apartmentData['noBath'] ?? 'N/A';
    final String roomType = apartmentData['roomType'] ?? 'N/A';
    final bool available = apartmentData['available'] ?? true;
    // print(
    //     '$image, $renterImage, address, $price, $bedRooms, $bathRooms, $roomType');
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 250.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: kSecondary3,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 35.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 5.h, horizontal: 20.w),
                        child: AppText.body3Bold('Request to:'),
                      ),
                      Center(
                        child: CircleAvatar(
                          backgroundColor: kSecondaryLight3,
                          radius:
                              50.spMin, // Set the radius to your desired size
                          child: Hero(
                            tag: 'profileImage',
                            child: ClipOval(
                              child: renterImage.isNotEmpty
                                  ? Image.network(
                                      renterImage,
                                      fit: BoxFit
                                          .cover, // Make sure the image is scaled correctly
                                      width:
                                          95, // Set the width and height to ensure a circular shape
                                      height: 95,
                                    )
                                  : const Icon(Icons.person,
                                      size: 30), // Fallback if no profilePic
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Hero(
                            tag: 'name',
                            child: RowText(
                                title: 'Name:',
                                text: ownerData['name'] ?? 'N/A'),
                          ),
                          RowText(
                              title: 'Email:',
                              text: ownerData['email'] ?? 'N/A'),
                          Hero(
                            tag: 'number',
                            child: RowText(
                                title: 'Phone:',
                                text: ownerData['phone'] ?? 'N/A'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                    top: 15.h,
                    child: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: kDark,
                          size: 30.spMin,
                        )))
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.body3Bold('Chat with Landlord'),
                  InkWell(
                      onTap: () => Get.to(
                            () => UserChatScreen(
                                userId: requestData['renterId'],
                                ownerId: requestData['ownerId']),
                            arguments: {'ownerData': ownerData},
                          ),
                      child: Image.asset('assets/chat.gif')),
                  AppText.body3Bold('Property requests for:'),
                  InkWell(
                    onTap: () => Get.to(() => ApartmentDetailsScreen(
                        btn: false, apartmentId: widget.requestId)),
                    child: AppartmentCardWidget(
                        isAvailable: available,
                        image: imageUrl,
                        address: address,
                        price: price,
                        bedRooms: bedRooms,
                        bathRooms: bathRooms,
                        roomType: roomType),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                children: [
                  // Expanded(
                  //   child: Obx(
                  //     () => MyButton(
                  //         isLoading: _requestController.isLoading,
                  //         onTap: () async {
                  //           _requestController.updateRequest(
                  //               widget.requestId,
                  //               RequestStatus.accepted
                  //                   .toString()
                  //                   .split('.')
                  //                   .last,
                  //               'Request Accept successfully');
                  //         },
                  //         text: 'Accept'),
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: 10.w,
                  // ),
                  Expanded(
                      child: Obx(
                    () => MyButton(
                        isLoading: _requestController.isLoading,
                        onTap: () async {
                          _requestController.updateRequest(
                              widget.requestId,
                              RequestStatus.canceled.toString().split('.').last,
                              'Request Declined successfully');
                          Get.back();
                        },
                        text: 'cancel'),
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ! row text
class RowText extends StatelessWidget {
  final String title;
  final String text;
  const RowText({
    super.key,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Row(
        children: [
          AppText.body4Bold(title),
          SizedBox(
            width: 20.w,
          ),
          AppText.body4(text),
        ],
      ),
    );
  }
}
