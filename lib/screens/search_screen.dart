import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/property.dart';
import 'property_details_screen.dart';
import 'map_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _locationController = TextEditingController();
  DateTime? _checkIn;
  DateTime? _checkOut;
  int _guests = 1;
  double _maxPrice = 500;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _locationController,
                  decoration: InputDecoration(hintText: 'Location', border: OutlineInputBorder()),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
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
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
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
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text('Guests: $_guests'),
                    Slider(value: _guests.toDouble(), min: 1, max: 10, onChanged: (value) => setState(() => _guests = value.toInt())),
                  ],
                ),
                Row(
                  children: [
                    Text('Max Price: £$_maxPrice'),
                    Slider(value: _maxPrice, min: 50, max: 1000, onChanged: (value) => setState(() => _maxPrice = value)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('properties').where('price', isLessThanOrEqualTo: _maxPrice).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                final properties = snapshot.data!.docs.map((doc) => Property.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)).toList();
                return ListView.builder(
                  itemCount: properties.length + 1,
                  itemBuilder: (context, index) {
                    if (index == properties.length) {
                      return ElevatedButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen(properties: properties))),
                        child: Text('View on Map'),
                      );
                    }
                    final property = properties[index];
                    return ListTile(
                      leading: Image.network(property.imageUrl, width: 50, fit: BoxFit.cover),
                      title: Text(property.title),
                      subtitle: Text('${property.location} - £${property.price}/night'),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PropertyDetailsScreen(property: property))),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}