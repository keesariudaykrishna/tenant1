// // ignore_for_file: no_leading_underscores_for_local_identifiers

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../view_models/controllers/chat/chat_view_model.dart';

// class OwnerChatScreen extends StatelessWidget {
//   final String ownerId;
//   final String userId;

//   const OwnerChatScreen(
//       {super.key, required this.ownerId, required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController _controller = TextEditingController();
//     final ChatController _chatController = Get.put(ChatController());

//     // Generate the same chatId based on userId and ownerId
//     final chatId = '${userId}_$ownerId';
//     _chatController.listenForMessages(chatId);

//     return Scaffold(
//       appBar: AppBar(title: Text("Chat with User")),
//       body: Column(
//         children: [
//           Expanded(
//             child: Obx(() {
//               if (_chatController.messages.isEmpty) {
//                 return Center(child: Text("No messages yet"));
//               }
//               return ListView.builder(
//                 itemCount: _chatController.messages.length,
//                 itemBuilder: (context, index) {
//                   final messageData = _chatController.messages[index];
//                   final message = messageData['message'] as String;
//                   final sender = messageData['senderId'] as String;
//                   final isOwnerMessage = sender == ownerId;

//                   return Align(
//                     alignment: isOwnerMessage
//                         ? Alignment.centerRight
//                         : Alignment.centerLeft,
//                     child: Container(
//                       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                       decoration: BoxDecoration(
//                         color: isOwnerMessage ? Colors.green : Colors.grey[300],
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(16),
//                           topRight: Radius.circular(16),
//                           bottomLeft: isOwnerMessage
//                               ? Radius.circular(16)
//                               : Radius.zero,
//                           bottomRight: isOwnerMessage
//                               ? Radius.zero
//                               : Radius.circular(16),
//                         ),
//                       ),
//                       child: Text(
//                         message,
//                         style: TextStyle(
//                           color: isOwnerMessage ? Colors.white : Colors.black,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: InputDecoration(
//                       hintText: 'Type a message',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: () {
//                     String message = _controller.text.trim();
//                     if (message.isNotEmpty) {
//                       // Send message under the same chatId
//                       _chatController.sendMessage(chatId, ownerId, message);
//                       _controller.clear();
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
