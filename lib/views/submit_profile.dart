import 'package:final_taxi_app/views/bottom_nav/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../custom_widgets/custom_button.dart';
import 'login_screen.dart';

class SubmitProfileScreen extends StatefulWidget {
  const SubmitProfileScreen({super.key});

  @override
  State<SubmitProfileScreen> createState() => _SubmitProfileScreenState();
}

class _SubmitProfileScreenState extends State<SubmitProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
              "assets/images/Images-5.png",
            fit: BoxFit.cover, // Ensure the image covers the entire space
            width: double.infinity, // Make the image as wide as possible
          ),
          SizedBox(height: screenHeight/30,),

          Image.asset("assets/images/checklist.png", height: screenHeight/9,),
          const Text("Your Profile has been submitted successfully!"),
          // SizedBox(height: screenHeight/30,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: CustomButton(
              text: "Next",
              textStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              onPressed: () {
                Get.offAll(() => const BottomNavigationScreen());

                ///Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
              },),
          ),

          SizedBox(
            height: 30,
          )

        ],
      ),
    );
  }
}
