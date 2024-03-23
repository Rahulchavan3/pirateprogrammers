import 'package:flutter/material.dart';

import 'volunteer_info.dart';

class HomeBankScreen extends StatefulWidget {
  @override
  _HomeBankScreenState createState() => _HomeBankScreenState();
}

class _HomeBankScreenState extends State<HomeBankScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Available',
                textAlign: TextAlign.left,
              ),
            ),
            Text('15'),
          ],
        ),
      ),
      body: Stack(
        children: [
          if (_selectedIndex == 0) // Render only if "Home" tab is selected
            _buildPageView(),
          if (_selectedIndex == 1) // Render only if "Search" tab is selected
            _buildSearchOverlay(),
          if (_selectedIndex == 2) // Render only if "Settings" tab is selected
            _buildProfileOverlay(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note_rounded),
            label: 'Update',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildPageView() {
    return PageView(
      children: [
        ListView(
          children: [
            GestureDetector(
              onTap: () {
                _navigateToVolunteerInfo(context, 'John', 10);
              },
              child: NameItem(
                name: 'John',
                notificationCount: 10,
              ),
            ),
            GestureDetector(
              onTap: () {
                _navigateToVolunteerInfo(context, 'Alice', 10);
              },
              child: NameItem(
                name: 'Alice',
                notificationCount: 10,
              ),
            ),
            GestureDetector(
              onTap: () {
                _navigateToVolunteerInfo(context, 'Bob', 10);
              },
              child: NameItem(
                name: 'Bob',
                notificationCount: 10,
              ),
            ),
          ],
        ),
        Container(), // Empty Container for the Search tab
      ],
      onPageChanged: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }

  void _navigateToVolunteerInfo(
      BuildContext context, String name, int notificationCount) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              VolunteerInfo(name: name, notificationCount: notificationCount)),
    );
  }

  Widget _buildSearchOverlay() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text(
          'Data Update',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  Widget _buildProfileOverlay() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text(
          'Profile',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class NameItem extends StatelessWidget {
  final String name;
  final int notificationCount;

  const NameItem({
    required this.name,
    required this.notificationCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue, // Change color as needed
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Requirement ${notificationCount.toString()}',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
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
