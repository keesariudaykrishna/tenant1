import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _passwordController = TextEditingController();

  Future<void> _changePassword() async {
    final user = FirebaseAuth.instance.currentUser!;
    try {
      await user.updatePassword(_passwordController.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password updated')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: Text('Change Password'),
            onTap: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Change Password'),
                content: TextField(controller: _passwordController, decoration: InputDecoration(labelText: 'New Password'), obscureText: true),
                actions: [TextButton(onPressed: _changePassword, child: Text('Save'))],
              ),
            ),
          ),
          ListTile(title: Text('Payment Methods'), onTap: () {}), // Placeholder
          ListTile(title: Text('Notifications'), onTap: () {}), // Placeholder
          ListTile(title: Text('Help & Support'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HelpScreen()))),
        ],
      ),
    );
  }
}