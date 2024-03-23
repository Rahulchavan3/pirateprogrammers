import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pirateprogrammers/volunteer/volunteer_home_page.dart';
import 'package:pirateprogrammers/Bank/bank_home_page.dart';
import 'package:pirateprogrammers/registration_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                  final uid = userCredential.user!.uid;
                  final role = await _fetchUserRole(uid);
                  if (role == 'Volunteer') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  } else if (role == 'Foodbank') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeBankScreen()),
                    );
                  }
                } catch (e) {
                  print('Error: $e');
                  // Handle error
                }
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Navigate to registration page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationPage()),
                );
              },
              child: const Text('Create New Account'),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _fetchUserRole(String uid) async {
    try {
      final DocumentSnapshot snapshot = await _firestore.collection('users').doc(uid).get();
      if (snapshot.exists) {
        return snapshot['role'];
      }
    } catch (e) {
      print('Error fetching user role: $e');
    }
    return null;
  }
}
