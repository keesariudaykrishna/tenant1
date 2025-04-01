import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking.dart';

class BookingRequestsScreen extends StatelessWidget {
  Future<void> _updateStatus(String bookingId, String status) async {
    await FirebaseFirestore.instance.collection('bookings').doc(bookingId).update({'status': status});
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(title: Text('Booking Requests')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('properties').where('hostId', isEqualTo: user.uid).snapshots(),
        builder: (context, propertySnapshot) {
          if (!propertySnapshot.hasData) return Center(child: CircularProgressIndicator());
          final propertyIds = propertySnapshot.data!.docs.map((doc) => doc.id).toList();
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('bookings').where('propertyId', whereIn: propertyIds).where('status', isEqualTo: 'Pending').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
              final bookings = snapshot.data!.docs.map((doc) => Booking.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)).toList();
              return ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return ListTile(
                    title: Text('Booking for ${booking.propertyId}'),
                    subtitle: Text('Check-In: ${booking.checkIn.toString().substring(0, 10)} - £${booking.totalPrice}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.check),
                          onPressed: () => _updateStatus(booking.id, 'Accepted'),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => _updateStatus(booking.id, 'Rejected'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}