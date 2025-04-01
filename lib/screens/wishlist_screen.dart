import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/property.dart';

class WishlistScreen extends StatelessWidget {
  Future<void> _addToWishlist(String propertyId) async {
    final user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance.collection('wishlists').doc(user.uid).set({
      'properties': FieldValue.arrayUnion([propertyId]),
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(title: Text('Wishlists')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('wishlists').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
          final propertyIds = List<String>.from(data['properties'] ?? []);
          return ListView.builder(
            itemCount: propertyIds.length,
            itemBuilder: (context, index) {
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('properties').doc(propertyIds[index]).get(),
                builder: (context, propSnapshot) {
                  if (!propSnapshot.hasData) return SizedBox();
                  final property = Property.fromFirestore(propSnapshot.data!.data() as Map<String, dynamic>, propSnapshot.data!.id);
                  return ListTile(
                    title: Text(property.title),
                    subtitle: Text(property.location),
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