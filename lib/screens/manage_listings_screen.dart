import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/property.dart';

class ManageListingsScreen extends StatelessWidget {
  Future<void> _deleteProperty(String id) async {
    await FirebaseFirestore.instance.collection('properties').doc(id).delete();
  }

  Future<void> _editProperty(BuildContext context, Property property) async {
    final _titleController = TextEditingController(text: property.title);
    final _priceController = TextEditingController(text: property.price.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Property'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _titleController, decoration: InputDecoration(labelText: 'Title')),
            TextField(controller: _priceController, decoration: InputDecoration(labelText: 'Price')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('properties').doc(property.id).update({
                'title': _titleController.text,
                'price': double.parse(_priceController.text),
              });
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(title: Text('Manage Listings')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('properties').where('hostId', isEqualTo: user.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final properties = snapshot.data!.docs.map((doc) => Property.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)).toList();
          return ListView.builder(
            itemCount: properties.length,
            itemBuilder: (context, index) {
              final property = properties[index];
              return ListTile(
                title: Text(property.title),
                subtitle: Text('${property.location} - £${property.price}/night'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: Icon(Icons.edit), onPressed: () => _editProperty(context, property)),
                    IconButton(icon: Icon(Icons.delete), onPressed: () => _deleteProperty(property.id)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}