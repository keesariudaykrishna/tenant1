import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Help & Support')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('FAQs', style: TextStyle(fontSize: 20)),
            SizedBox(height: 16),
            Text('Q: How do I book a property?\nA: Search, select, and book!'),
            Text('Q: How do I cancel a booking?\nA: Go to Manage Bookings.'),
          ],
        ),
      ),
    );
  }
}