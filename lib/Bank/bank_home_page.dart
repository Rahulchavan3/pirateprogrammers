import 'package:flutter/material.dart';

class HomeBankScreen extends StatelessWidget {
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
      body: ListView(
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
