import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pirateprogrammers/volunteer/volunteer_home_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedRole;
  File? _image;

  // Function to pick an image from gallery
  Future<void> _getImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  // Function to upload image to Firebase Storage
  Future<String> _uploadImage(String userId) async {
    if (_image == null) return '';

    try {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('$userId.jpg');
      UploadTask uploadTask = storageReference.putFile(_image!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Upload Image Error: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: _getImage, // Open image picker
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? const Icon(Icons.add_a_photo, size: 30)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              const SizedBox(
                  height: 10), // Reduced space between Name and Email
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const SizedBox(
                  height: 20), // Added space between Email and Password
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                hint: const Text('Select Role'),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value;
                    // If the selected role is 'Foodbank', clear the image
                    if (_selectedRole == 'Foodbank') {
                      _image = null;
                    }
                  });
                },
                items: ['Volunteer', 'Foodbank']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    // Create user in Firebase Authentication
                    final UserCredential userCredential =
                        await _auth.createUserWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );

                    // Upload image to Firebase Storage if not Foodbank role
                    String imageURL = '';
                    if (_image != null && _selectedRole != 'Foodbank') {
                      imageURL = await _uploadImage(userCredential.user!.uid);
                    }

                    // Add user details to Firestore collection
                    await _firestore
                        .collection('users')
                        .doc(userCredential.user!.uid)
                        .set({
                      'name': _nameController.text,
                      'email': _emailController.text,
                      'role': _selectedRole,
                      'profileImage': imageURL,
                    });

                    // Navigate to home page on successful registration
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  } catch (e) {
                    print('Error: $e');
                    // Handle error
                  }
                },
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
