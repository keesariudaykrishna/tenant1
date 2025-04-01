import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_property_screen.dart';
import 'manage_listings_screen.dart';
import 'booking_requests_screen.dart';

class HostDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(title: Text('Host Dashboard')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Welcome, ${user.email}'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddPropertyScreen())),
              child: Text('Add New Property'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ManageListingsScreen())),
              child: Text('Manage Listings'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BookingRequestsScreen())),
              child: Text('Booking Requests'),
            ),
            SizedBox(height: 16),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('bookings').where('propertyId', whereIn: FirebaseFirestore.instance.collection('properties').where('hostId', isEqualTo: user.uid).snapshots().map((s) => s.docs.map((d) => d.id).toList())).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                final bookings = snapshot.data!.docs;
                final revenue = bookings.fold(0.0, (sum, doc) => sum + (doc['totalPrice'] as num).toDouble());
                return Column(
                  children: [
                    Text('Total Bookings: ${bookings.length}'),
                    Text('Total Revenue: £$revenue'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}