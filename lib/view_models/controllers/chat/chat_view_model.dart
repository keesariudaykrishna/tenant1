// // import 'package:firebase_database/firebase_database.dart';
// // import 'package:get/get.dart';

// // class ChatController extends GetxController {
// //   RxList<Map<String, dynamic>> messages = RxList<Map<String, dynamic>>([]);
// //   final FirebaseDatabase _database = FirebaseDatabase.instance;

// //   // Listen for new messages in the chat
// //   void listenForMessages(String chatId) {
// //     // Listen for added messages under the unique chatId in Firebase
// //     _database.ref('chats/$chatId/messages').onChildAdded.listen((event) {
// //       final messageData = event.snapshot.value as Map<dynamic, dynamic>;
// //       messages.add({
// //         'message': messageData['message'],
// //         'senderId': messageData['senderId'],
// //         'timestamp': messageData['timestamp'],
// //       });
// //     });
// //   }

// //   // Send message to the existing chatId
// //   void sendMessage(String chatId, String senderId, String message) {
// //     final timestamp = DateTime.now().toIso8601String();

// //     // Create a message object
// //     final newMessage = {
// //       'message': message,
// //       'senderId': senderId,
// //       'timestamp': timestamp,
// //     };

// //     // Push the message under the specific chatId's messages
// //     _database.ref('chats/$chatId/messages').push().set(newMessage);
// //   }
// // }
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class ChatController extends GetxController {
//   RxList<Map<String, dynamic>> messages = RxList<Map<String, dynamic>>([]);
//   final FirebaseDatabase _database = FirebaseDatabase.instance;

//   // Listen for new messages in the chat, ordered by the latest timestamp first
//   void listenForMessages(String chatId) {
//     // Listen for added messages under the unique chatId in Firebase
//     _database
//         .ref('chats/$chatId/messages')
//         .orderByChild('timestamp') // Order messages by timestamp
//         .onChildAdded
//         .listen((event) {
//       final messageData = event.snapshot.value as Map<dynamic, dynamic>;

//       // Add the new message at the beginning of the list to keep the latest first
//       messages.insert(0, {
//         'message': messageData['message'],
//         'senderId': messageData['senderId'],
//         'timestamp': messageData['timestamp'],
//       });
//     });
//   }

//   // Send message to the existing chatId
//   void sendMessage(String chatId, String senderId, String message) {
//     final timestamp = DateTime.now().toIso8601String();

//     // Create a message object
//     final newMessage = {
//       'message': message,
//       'senderId': senderId,
//       'timestamp': timestamp,
//     };

//     // Push the message under the specific chatId's messages
//     _database.ref('chats/$chatId/messages').push().set(newMessage);
//   }
// }

class ChatController extends GetxController {
  RxList<Map<String, dynamic>> messages = RxList<Map<String, dynamic>>([]);
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Listen for new messages in the chat, ordered by the latest timestamp first
  void listenForMessages(String chatId, GlobalKey<AnimatedListState> listKey) {
    // print("Fetching messages for chatId: $chatId");
    _database
        .ref('chats/$chatId/messages')
        .orderByChild('timestamp') // Order messages by timestamp
        .onChildAdded
        .listen((event) {
      final messageData = event.snapshot.value as Map<dynamic, dynamic>;

      // Insert the new message at the start of the list and animate it
      messages.insert(0, {
        'message': messageData['message'],
        'senderId': messageData['senderId'],
        'timestamp': messageData['timestamp'],
      });

      // Insert the new item with animation
      listKey.currentState
          ?.insertItem(0, duration: Duration(milliseconds: 300));
      // print("Message added: $messageData");
    });
  }

  // Send message to the existing chatId
  void sendMessage(String chatId, String senderId, String message) {
    final timestamp = DateTime.now().toIso8601String();

    // Create a message object
    final newMessage = {
      'message': message,
      'senderId': senderId,
      'timestamp': timestamp,
    };

    // Push the message under the specific chatId's messages
    _database.ref('chats/$chatId/messages').push().set(newMessage);
  }
}
