import 'package:final_taxi_app/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';

import '../splash_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Example fields that could be edited
  String _username = "John Doe";
  String _email = "john.doe@example.com";

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with the current values
    _usernameController.text = _username;
    _emailController.text = _email;
  }

  @override
  void dispose() {
    // Dispose of the controllers when the screen is disposed
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Function to update the profile details
  void _updateProfile() {
    setState(() {
      _username = _usernameController.text;
      _email = _emailController.text;
    });
  }
  var box = Hive.box('details');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Username',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: 'Enter your username',
              ),
            ),
            SizedBox(height: 16),

            Text(
              'Email',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email',
              ),
            ),
            SizedBox(height: 32),

            Center(
              child: ElevatedButton(
                onPressed: _updateProfile,
                child: Text('Update Profile'),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed:() async {
                 await box.clear();
                  Get.offAll(const SplashScreen());
                  snackBar(context, 'Logout Successful', Colors.white, Colors.red);
                },
                child: Text('Logout'),
              ),
            ),
            SizedBox(height: 16),

            Center(
              child: Text(
                'Current Profile Information:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),

            Center(
              child: Text(
                'Username: $_username',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 8),

            Center(
              child: Text(
                'Email: $_email',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
