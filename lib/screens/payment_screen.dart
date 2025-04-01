import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking.dart';

class PaymentScreen extends StatefulWidget {
  final Booking booking;

  PaymentScreen({required this.booking});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _paymentMethod = 'Credit Card';

  Future<void> _confirmBooking() async {
    final bookingRef = await FirebaseFirestore.instance.collection('bookings').add(widget.booking.toFirestore());
    await FirebaseFirestore.instance.collection('payments').add({
      'bookingId': bookingRef.id,
      'method': _paymentMethod,
      'amount': widget.booking.totalPrice,
      'status': 'Completed',
      'timestamp': FieldValue.serverTimestamp(),
    });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BookingConfirmationScreen(bookingId: bookingRef.id)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Total: £${widget.booking.totalPrice}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: _paymentMethod,
              items: ['Credit Card', 'UPI', 'PayPal'].map((method) => DropdownMenuItem(value: method, child: Text(method))).toList(),
              onChanged: (value) => setState(() => _paymentMethod = value!),
            ),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _confirmBooking, child: Text('Confirm Payment')),
          ],
        ),
      ),
    );
  }
}