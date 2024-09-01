import 'package:final_taxi_app/views/register_screen.dart';
import 'package:final_taxi_app/views/verify_screen.dart';
import 'package:flutter/material.dart';

import '../custom_widgets/custom_button.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            "assets/images/TR.png",
            fit: BoxFit.cover, // Ensure the image covers the entire space
            width: double.infinity, // Make the image as wide as possible
          ),
          SizedBox(height: screenHeight/30,),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: CustomButton(
              text: "Let's get rides",
              textStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              icons: Icons.arrow_forward,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));
                ///Navigator.push(context, MaterialPageRoute(builder: (context) => const VerifyScreen(mobileNo: '+919309768989'),));
            },),
          )

        ],
      ),
    );
  }
}
