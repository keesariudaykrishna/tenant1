import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/property.dart';
import '../models/booking.dart';
import 'payment_screen.dart';

class BookingScreen extends StatefulWidget {
  final Property property;

  BookingScreen({required this.property});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _checkIn;
  DateTime? _checkOut;
  int _guests = 1;

  @override
  Widget build(BuildContext context) {
    double totalPrice = _checkIn != null && _checkOut != null ? widget.property.price * _checkOut!.difference(_checkIn!).inDays : 0;
    return Scaffold(
      appBar: AppBar(title: Text('Book ${widget.property.title}')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () async {
                _checkIn = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2026),
                );
                setState(() {});
              },
              child: Text(_checkIn == null ? 'Check-In' : _checkIn!.toString().substring(0, 10)),
            ),
            ElevatedButton(
              onPressed: () async {
                _checkOut = await showDatePicker(
                  context: context,
                  initialDate: _checkIn ?? DateTime.now(),
                  firstDate: _checkIn ?? DateTime.now(),
                  lastDate: DateTime(2026),
                );
                setState(() {});
              },
              child: Text(_checkOut == null ? 'Check-Out' : _checkOut!.toString().substring(0, 10)),
            ),
            Row(
              children: [
                Text('Guests: $_guests'),
                Slider(value: _guests.toDouble(), min: 1, max: 10, onChanged: (value) => setState(() => _guests = value.toInt())),
              ],
            ),
            SizedBox(height: 16),
            Text('Total: £$totalPrice'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(
                booking: Booking(
                  id: '',
                  userId: FirebaseAuth.instance.currentUser!.uid,
                  propertyId: widget.property.id,
                  checkIn: _checkIn ?? DateTime.now(),
                  checkOut: _checkOut ?? DateTime.now().add(Duration(days: 1)),
                  totalPrice: totalPrice,
                ),
              ))),
              child: Text('Proceed to Payment'),
            ),
          ],
        ),
      ),
    );
  }
}