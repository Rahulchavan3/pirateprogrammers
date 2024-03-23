import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pirateprogrammers/login_page.dart';

import 'volunteer_info.dart';

class HomeBankScreen extends StatefulWidget {
  @override
  _HomeBankScreenState createState() => _HomeBankScreenState();
}

class _HomeBankScreenState extends State<HomeBankScreen> {
  int _selectedIndex = 0;
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Available',
                textAlign: TextAlign.right,
              ),
            ),
            SizedBox(width: 8),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('counters').doc('counter_doc').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  final counterValue = snapshot.data?['counter'] ?? 0;
                  return Text('$counterValue');
                }
              },
            ),
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

  void _navigateToVolunteerInfo(BuildContext context, String name, int notificationCount) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => VolunteerInfo(name: name, notificationCount: notificationCount)),
    );
  }

  Widget _buildSearchOverlay() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Data Update',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: _decrementCounter,
                tooltip: 'Decrement',
                child: Icon(Icons.remove),
              ),
              SizedBox(width: 20),
              Text(
                '$_counter',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 20),
              FloatingActionButton(
                onPressed: _incrementCounter,
                tooltip: 'Increment',
                child: Icon(Icons.add),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Save counter value to Firestore
              _saveCounterToFirestore(_counter);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _saveCounterToFirestore(int counterValue) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    _firestore.collection('counters').doc('counter_doc').set({
      'counter': counterValue,
    }).then((value) {
      // Successfully saved to Firestore
      print('Counter value saved to Firestore: $counterValue');
    }).catchError((error) {
      // Failed to save to Firestore
      print('Failed to save counter value: $error');
    });
  }

  Widget _buildProfileOverlay() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('users').doc(user!.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (!snapshot.hasData || snapshot.data!.data() == null) {
            // If no data or no user found, display an appropriate message
            return Text('No profile data found');
          }
          final profileData = snapshot.data!.data() as Map<String, dynamic>;
          final name = profileData['name']; // Fetch the 'name' field from Firestore
          final email = profileData['email']; // Fetch the 'email' field from Firestore
          final profileImage = profileData['profileImage']; // Fetch the 'profileImage' field from Firestore
          final role = profileData['role']; // Fetch the 'role' field from Firestore

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: NetworkImage(profileImage),
                ),
              ],
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            SizedBox(height: 10),
            Divider(color: Colors.grey),
            ListTile(
              leading: Icon(Icons.work, color: Colors.blue),
              title: Text('Role: $role', style: TextStyle(fontSize: 18)),
            ),
            ListTile(
              leading: Icon(Icons.email, color: Colors.red),
              title: Text('Email: $email', style: TextStyle(fontSize: 18)),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: Text('Logout', style: TextStyle(fontSize: 16)),
              ),
            ),
            SizedBox(height: 20),
          ],
        );
      }
    },
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
