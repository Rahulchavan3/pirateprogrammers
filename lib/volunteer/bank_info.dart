import 'package:flutter/material.dart';

class BankInfo extends StatelessWidget {
  final String name;
  final int notificationCount;

  const BankInfo({Key? key, required this.name, required this.notificationCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bank Info'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/profile_image.jpg'), // Change the image path as needed
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 8),
                      Text(
                        name,
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '1234567890',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns children to the start and end of the row
                children: [
                  Text(
                    'Score:',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(width: 5),
                  Text(
                    '15',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns children to the start and end of the row
                children: [
                  Text(
                    'Requirement:',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(width: 5),
                  Text(
                    notificationCount.toString(),
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle Approve button press
                    },
                    child: Text('Approve'),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size.fromHeight(50), // Adjust the button height
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle Reject button press
                    },
                    child: Text('Reject'),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size.fromHeight(50), // Adjust the button height
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
