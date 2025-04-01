import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking.dart';

class BookingManagementScreen extends StatelessWidget {
  Future<void> _cancelBooking(String bookingId) async {
    await FirebaseFirestore.instance.collection('bookings').doc(bookingId).update({'status': 'Cancelled'});
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(title: Text('Manage Bookings')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('bookings').where('userId', isEqualTo: user.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final bookings = snapshot.data!.docs.map((doc) => Booking.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)).toList();
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return ListTile(
                title: Text('Booking for ${booking.propertyId}'),
                subtitle: Text('Status: ${booking.status} - £${booking.totalPrice}'),
                trailing: booking.status == 'Pending' ? IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () => _cancelBooking(booking.id),
                ) : null,
              );
            },
          );
        },
      ),
    );
  }
}