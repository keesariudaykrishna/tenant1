import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../models/property.dart';
import 'dart:io';

class AddPropertyScreen extends StatefulWidget {
  @override
  _AddPropertyScreenState createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amenitiesController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) setState(() => _image = File(pickedFile.path));
  }

  Future<void> _addProperty() async {
    final user = FirebaseAuth.instance.currentUser!;
    String imageUrl = 'https://via.placeholder.com/300';
    if (_image != null) {
      final ref = FirebaseStorage.instance.ref().child('properties/${DateTime.now().toString()}');
      await ref.putFile(_image!);
      imageUrl = await ref.getDownloadURL();
    }
    final property = Property(
      id: '',
      title: _titleController.text,
      location: _locationController.text,
      imageUrl: imageUrl,
      price: double.parse(_priceController.text),
      description: _descriptionController.text,
      amenities: _amenitiesController.text.split(','),
      hostId: user.uid,
    );
    await FirebaseFirestore.instance.collection('properties').add(property.toFirestore());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Property')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: _titleController, decoration: InputDecoration(labelText: 'Title')),
              TextField(controller: _locationController, decoration: InputDecoration(labelText: 'Location')),
              TextField(controller: _priceController, decoration: InputDecoration(labelText: 'Price per Night')),
              TextField(controller: _descriptionController, decoration: InputDecoration(labelText: 'Description')),
              TextField(controller: _amenitiesController, decoration: InputDecoration(labelText: 'Amenities (comma-separated)')),
              SizedBox(height: 16),
              _image == null ? Text('No image selected') : Image.file(_image!, height: 100),
              ElevatedButton(onPressed: _pickImage, child: Text('Pick Image')),
              SizedBox(height: 16),
              ElevatedButton(onPressed: _addProperty, child: Text('Add Property')),
            ],
          ),
        ),
      ),
    );
  }
}