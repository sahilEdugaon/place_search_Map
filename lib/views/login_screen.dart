import 'dart:convert';

import 'package:final_taxi_app/views/verify_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../custom_widgets/custom_button.dart';
import '../service/auth_service.dart';
import '../utils/snack_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController phoneController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(  // This will make the whole content scrollable
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenHeight,
          ),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/images/7.png"),

                SizedBox(height: screenHeight / 18),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenHeight / 32,
                        ),
                      ),
                      SizedBox(height:10),
                      const Text("Enter Mobile number"),
                      SizedBox(height: screenHeight / 80),
                      IntlPhoneField(
                        flagsButtonPadding: const EdgeInsets.only(left: 5),
                        dropdownTextStyle: TextStyle(fontSize: screenHeight / 55),
                        dropdownIconPosition: IconPosition.trailing,
                        dropdownIcon: Icon(
                          Icons.arrow_drop_down_sharp,
                          size: screenHeight / 40,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                          hintText: 'Enter Mobile number',
                          hintStyle: TextStyle(fontSize: screenHeight / 55),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey, width: 1),
                          ),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(12), // Set max length to 10 digits
                          FilteringTextInputFormatter.digitsOnly, // Ensure only digits are entered
                        ],
                        initialCountryCode: 'IN',
                        disableLengthCheck: true,
                        textAlign: TextAlign.left,
                       // controller: phoneController,
                        keyboardType: TextInputType.phone,

                        onChanged: (phone) {
                          print('phone-');
                          print(phone.completeNumber);
                          phoneController.text = phone.completeNumber;
                          ///print(phoneController.text);

                        },
                      ),

                      SizedBox(height: screenHeight / 20),
                      isLoading==false
                      ?CustomButton(
                        text: "Continue",
                        textStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        onPressed: () {
                          if(phoneController.text.isEmpty){
                            snackBar(context, 'Please Enter Phone Number', Colors.white, Colors.red);
                          }
                          else{
                            // Navigator.pushAndRemoveUntil(
                            //   context,
                            //   MaterialPageRoute(builder: (context) =>   VerifyScreen(mobileNo: phoneController.text,)),
                            //       (route) => false,
                            // );
                            loginPhoneNumber(phoneController.text.trim(),context);
                          }
                        },
                      )
                      :const Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  loginPhoneNumber(String mobile, BuildContext context)async{
    setState(() {
      isLoading=true;
    });
    final Map<String,dynamic> data = {
      "mobile":mobile,
    };
    await AuthService().otpService(data).then((response){

      final responseBody = json.decode(response.body??"");
      var status = responseBody['response']['status'];
      var message = responseBody['response']['message'];

      print('responseBody-$responseBody');
      setState(() {
        isLoading=false;
      });
      if (status.toString().toUpperCase() =='success'.toUpperCase()) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) =>   VerifyScreen(mobileNo: phoneController.text,)),
              (route) => false,
        );
        snackBar(context, 'Sent OTP', Colors.white, Colors.green);
      }
      else {
        print('LoginErrorState-${responseBody['message']}');
        snackBar(context, message, Colors.white, Colors.red);
      }
    }).onError((error, stackTrace){
      setState(() {
        isLoading=false;
      });
      snackBar(context, 'Otp Sent failed!', Colors.white, Colors.red);

    });
  }

}
