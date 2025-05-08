import 'package:apartment_rentals/views/chat/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../res/colors.dart';
import '../../../view_models/controllers/chat/chat_view_model.dart';

class BottomTextFeild extends StatefulWidget {
  const BottomTextFeild({
    super.key,
    required TextEditingController controller,
    required ChatController chatController,
    required this.chatId,
    required this.widget,
  })  : _controller = controller,
        _chatController = chatController;

  final TextEditingController _controller;
  final ChatController _chatController;
  final String chatId;
  final UserChatScreen widget;

  @override
  State<BottomTextFeild> createState() => _BottomTextFeildState();
}

class _BottomTextFeildState extends State<BottomTextFeild> {
  final ChatController controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12.h),
      child: Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12))),
        height: 70,
        width: double.infinity,
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(40),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: TextField(
                  controller: widget._controller,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black, // Set text color
                  ),
                  decoration: InputDecoration(
                    hintText: 'Type a message',
                    hintStyle: TextStyle(
                      color: Colors.grey, // Set hint text color
                      fontSize: 14, // Adjust font size
                    ),
                    border: InputBorder.none, // No border
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  ),
                )
                    //  MyField(
                    //   hintText: 'Type a message',
                    //   controller: _controller,
                    // ),
                    ),
                ClipOval(
                  child: Container(
                    color: kSecondary3,
                    child: Center(
                      child: IconButton(
                        icon: Icon(
                          Icons.send_rounded,
                          color: kSecondary2,
                          size: 40.spMin,
                        ),
                        onPressed: () {
                          String message = widget._controller.text.trim();
                          if (message.isNotEmpty) {
                            widget._chatController.sendMessage(
                              widget.chatId,
                              widget.widget.userId,
                              message,
                            );
                            widget._controller.clear();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
