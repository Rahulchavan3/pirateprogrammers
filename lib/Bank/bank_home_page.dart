import 'package:flutter/material.dart';

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
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
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
            NameItem(
              name: 'John',
              notificationCount: 10,
            ),
            NameItem(
              name: 'Alice',
              notificationCount: 10,
            ),
            NameItem(
              name: 'Bob',
              notificationCount: 10,
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

  Widget _buildSearchOverlay() {
  return Container(
    color: Colors.white,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Data Update',
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 20),
        Text(
          'Counter Value:',
          style: TextStyle(fontSize: 20),
        ),
        Text(
          '$_counter',
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: Icon(Icons.add),
            ),
            SizedBox(width: 20),
            FloatingActionButton(
              onPressed: _decrementCounter,
              tooltip: 'Decrement',
              child: Icon(Icons.remove),
            ),
          ],
        ),
      ],
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
                    'Required ${notificationCount.toString()}',
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
