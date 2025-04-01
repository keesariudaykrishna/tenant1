import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/property.dart';
import 'booking_screen.dart';
import 'wishlist_screen.dart';

class PropertyDetailsScreen extends StatelessWidget {
  final Property property;

  PropertyDetailsScreen({required this.property});

  Future<void> _addToWishlist(BuildContext context) async {
    await WishlistScreen()._addToWishlist(property.id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added to Wishlist')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(property.title),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () => _addToWishlist(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(property.imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(property.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(property.location),
                  Text('£${property.price}/night', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Text(property.description),
                  SizedBox(height: 16),
                  Text('Amenities', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...property.amenities.map((amenity) => Text('- $amenity')),
                  SizedBox(height: 16),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('reviews').where('propertyId', isEqualTo: property.id).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return SizedBox();
                      final reviews = snapshot.data!.docs;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Reviews (${reviews.length})', style: TextStyle(fontWeight: FontWeight.bold)),
                          ...reviews.map((review) => ListTile(
                            title: Text(review['comment']),
                            subtitle: Text('Rating: ${review['rating']}'),
                          )),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BookingScreen(property: property))),
                    child: Text('Book Now'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}