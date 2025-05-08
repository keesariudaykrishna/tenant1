import 'package:apartment_rentals/res/app_widgets/text.dart';
import 'package:apartment_rentals/res/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/utils.dart';
import '../../view_models/controllers/chat/chat_view_model.dart';
import 'widgets/bottom_text_field.dart';
import 'widgets/popup.dart';

class UserChatScreen extends StatefulWidget {
  final String userId;
  final String ownerId;

  const UserChatScreen(
      {super.key, required this.userId, required this.ownerId});

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  final ChatController chatController = Get.put(ChatController());
  late final Map<String, dynamic> arguments;
  late final Map<String, dynamic> ownerData;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    arguments = Get.arguments ?? {};
    ownerData = arguments['ownerData'] ?? {};
    final chatId = '${widget.userId}_${widget.ownerId}';

    // Use Future.delayed to ensure data fetch is called after widget is rendered
    Future.delayed(Duration(milliseconds: 200), () {
      chatController.listenForMessages(chatId, _listKey);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatId = '${widget.userId}_${widget.ownerId}';
    final profilePic = ownerData['profilePic'];
    final name = ownerData['name'];
    final phone = ownerData['phone'];

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: kSecondary3,
        title: Row(
          children: [
            IconButton(
                onPressed: () => Get.back(), icon: Icon(Icons.arrow_back)),
            GestureDetector(
              onTap: () {
                showUserDataDialog(context, profilePic, name, phone);
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Hero(
                  tag: 'profileImage',
                  child: ClipOval(
                    child: profilePic.isEmpty
                        ? Icon(Icons.person, size: 30)
                        : CachedNetworkImage(
                            imageUrl: profilePic.isNotEmpty ? profilePic : '',
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.person, size: 30),
                          ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                      tag: 'name',
                      child: AppText.body3Bold('${name ?? 'Unknown'}')),
                  AppText.body1('Owner'),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: kSecondary3,
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (chatController.messages.isEmpty) {
                return Center(
                    child:
                        CircularProgressIndicator()); // Show loading indicator
              }

              return AnimatedList(
                key: _listKey,
                reverse: true, // Start the list from the bottom
                controller: _scrollController,
                initialItemCount: chatController.messages.length,
                itemBuilder: (context, index, animation) {
                  final messageData = chatController.messages[index];
                  final message = messageData['message'] as String;
                  final sender = messageData['senderId'] as String;
                  final timestampString = messageData['timestamp'] as String;
                  final timestamp = DateTime.parse(timestampString);
                  final isUserMessage = sender == widget.userId;

                  // Check if the date header should be shown for this message
                  final prevIndex = index + 1;
                  final prevMessageData =
                      prevIndex < chatController.messages.length
                          ? chatController.messages[prevIndex]
                          : null;
                  final showDateHeader = prevMessageData == null ||
                      Utils().formatDate(
                              DateTime.parse(messageData['timestamp'])) !=
                          Utils().formatDate(
                              DateTime.parse(prevMessageData['timestamp']));

                  return Column(
                    children: [
                      if (showDateHeader)
                        _buildDateHeader(Utils().formatDate(timestamp)),
                      _buildMessageItem(
                          message, timestamp, isUserMessage, animation),
                    ],
                  );
                },
              );
            }),
          ),
          BottomTextFeild(
              controller: _controller,
              chatController: chatController,
              chatId: chatId,
              widget: widget),
        ],
      ),
    );
  }

  Widget _buildMessageItem(String message, DateTime timestamp,
      bool isUserMessage, Animation<double> animation) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Align(
        alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.0),
          child: Card(
            elevation: 10,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUserMessage ? kSecondaryLight : kPrimary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: isUserMessage ? Radius.circular(12) : Radius.zero,
                  bottomRight:
                      isUserMessage ? Radius.zero : Radius.circular(12),
                ),
              ),
              child: FadeTransition(
                opacity: animation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.body3(message,
                        color: isUserMessage ? kPrimary : kDark),
                    SizedBox(width: 4),
                    Text(
                      Utils().formatTimestamp(timestamp),
                      style: TextStyle(
                        color: isUserMessage ? kPrimary : kDark,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateHeader(String date) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        children: [
          Expanded(child: Divider(color: kGray2, thickness: 1, endIndent: 8)),
          Text(
            date,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: kDark,
            ),
          ),
          Expanded(child: Divider(color: kGray2, thickness: 1, indent: 8)),
        ],
      ),
    );
  }
}
