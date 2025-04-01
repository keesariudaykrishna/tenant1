import 'package:flutter/material.dart';
import 'home_screen.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final String bookingId;

  BookingConfirmationScreen({required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Booking Confirmed')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 100, color: Colors.green),
            Text('Booking Successful!', style: TextStyle(fontSize: 24)),
            Text('Booking ID: $bookingId'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen())),
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}