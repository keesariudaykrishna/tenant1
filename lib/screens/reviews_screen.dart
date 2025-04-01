import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewsScreen extends StatefulWidget {
  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final _reviewController = TextEditingController();
  double _rating = 5.0;

  Future<void> _submitReview() async {
    final user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance.collection('reviews').add({
      'userId': user.uid,
      'propertyId': 'property123', // Dummy, replace with dynamic
      'rating': _rating,
      'comment': _reviewController.text,
      'timestamp': FieldValue.serverTimestamp(),
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reviews')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Slider(value: _rating, min: 1, max: 5, divisions: 4, onChanged: (value) => setState(() => _rating = value)),
            Text('Rating: $_rating'),
            TextField(controller: _reviewController, decoration: InputDecoration(labelText: 'Write a review')),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _submitReview, child: Text('Submit Review')),
          ],
        ),
      ),
    );
  }
}