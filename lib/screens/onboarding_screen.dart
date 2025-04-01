import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<String> _interests = ['Beach', 'City', 'Nature', 'Adventure'];
  final List<bool> _selected = [false, false, false, false];

  Future<void> _saveInterests() async {
    final user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'email': user.email,
      'interests': _interests.asMap().entries.where((e) => _selected[e.key]).map((e) => e.value).toList(),
    });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tell us about you')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Select your interests', style: TextStyle(fontSize: 20)),
            SizedBox(height: 16),
            ...List.generate(_interests.length, (index) => CheckboxListTile(
              title: Text(_interests[index]),
              value: _selected[index],
              onChanged: (value) => setState(() => _selected[index] = value!),
            )),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _saveInterests, child: Text('Continue')),
          ],
        ),
      ),
    );
  }
}