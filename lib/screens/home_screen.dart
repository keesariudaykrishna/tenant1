import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'host_dashboard_screen.dart';
import 'profile_screen.dart';
import '../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [HomeContent(), HostDashboardScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TENANT')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Where to?',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen())),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  _buildCategoryCard('Beach', 'https://via.placeholder.com/150'),
                  _buildCategoryCard('City', 'https://via.placeholder.com/150'),
                  _buildCategoryCard('Nature', 'https://via.placeholder.com/150'),
                  _buildCategoryCard('Adventure', 'https://via.placeholder.com/150'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, String imageUrl) {
    return Card(
      child: Column(
        children: [
          Image.network(imageUrl, height: 100, fit: BoxFit.cover),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}