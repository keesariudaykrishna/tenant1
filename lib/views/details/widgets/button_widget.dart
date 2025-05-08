import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../res/app_widgets/button.dart';
import '../../../res/app_widgets/text.dart';
import '../../../res/colors.dart';
import '../../../utils/utils.dart';
import '../../../view_models/controllers/request/request_view_model.dart';
import '../../../view_models/services/user_session.dart';
import '../details_view.dart';

class ButtonOfConditions extends StatelessWidget {
  const ButtonOfConditions({
    super.key,
    required this.widget,
    required this.available,
    required this.userId,
    required RequestController controller,
    required this.uuid,
  }) : _controller = controller;

  final ApartmentDetailsScreen widget;
  final dynamic available;
  final dynamic userId;
  final RequestController _controller;
  final dynamic uuid;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: widget.btn
          ? available == true
              ? SessionController().userId == userId
                  ? Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
                      child: Center(
                        child: Container(
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: kSecondary3,
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          child: Center(
                            child: AppText.body(
                                'You\'re the owner of this property'),
                          ),
                        ),
                      ),
                    )
                  : Obx(
                      () => MyButton(
                        isLoading: _controller.isLoading,
                        onTap: () {
                          if (SessionController().userId == userId) {
                            Utils().doneSnackBar(
                                "You're the owner of this property");
                          } else {
                            _controller.request(userId, uuid);
                          }
                        },
                        text: 'Check Out',
                      ),
                    )
              : Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
                  child: Center(
                    child: Container(
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors
                            .redAccent, // Set a distinct color for "not available"
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      child: Center(
                        child: Container(
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Colors.red.shade300,
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          child: Center(
                            child:
                                AppText.body('This property is not available'),
                          ),
                        ),
                      ),

                      //     Center(
                      //       child: AppText.body(
                      //         'This property is not available',
                      //         color: Colors
                      //             .white, // Text color for better visibility
                      //       ),
                      //     ),
                    ),
                  ),
                )
          : SizedBox.shrink(),
    );
  }
}
