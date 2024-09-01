import 'dart:convert';

import 'package:final_taxi_app/views/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pinput/pinput.dart';

import '../custom_widgets/custom_button.dart';
import '../service/auth_service.dart';
import '../utils/colors_constant.dart';
import '../utils/snack_bar.dart';
import 'bottom_nav/bottom_nav.dart';

class VerifyScreen extends StatefulWidget {
  final String mobileNo;
  const  VerifyScreen({super.key,required this.mobileNo});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {

  TextEditingController codeController = TextEditingController();

  int remainingSeconds = 120;
  bool isResendAvailable = false;
  var box = Hive.box('details');
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
        startTimer();
      } else {
        setState(() {
          isResendAvailable = true;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    final defaultPinTheme = PinTheme(
      width: screenWidth / 5,
      height: screenHeight / 14,
      textStyle: TextStyle(
        fontSize: screenHeight/38,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 1.5),
      ),
    );


    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  "assets/images/Image.png",
                  fit: BoxFit.cover,
                ),
                Positioned(
                    top: screenHeight/18,
                    left: screenWidth/20,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        child: Icon(Icons.arrow_back),
                      ),
                    )
                ),
              ],
            ),
            SizedBox(height: screenHeight / 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Verify",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenHeight / 32,
                              ),
                            ),
                            SizedBox(height: screenHeight / 40),
                             FittedBox(child: Text("Enter the 6-digit OTP sent to you at +91 - ********${widget.mobileNo[10]}${widget.mobileNo[11]}${widget.mobileNo[12]}")),
                            SizedBox(height: screenHeight / 90),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                              child: SizedBox(
                                child: Pinput(
                                  controller: codeController,
                                  keyboardType: TextInputType.number,
                                  length: 6,
                                  defaultPinTheme: defaultPinTheme,

                                  showCursor: true,
                                  preFilledWidget: Text(
                                    '0',
                                    style: TextStyle(
                                      fontSize: screenHeight/38,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey, // Hint text color
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      // isTextFieldEmpty = value.isEmpty;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight / 20),

                            isLoading==false
                            ?CustomButton(
                              text: "Continue",
                              textStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                              onPressed: () {

                                if(codeController.text.isEmpty){
                                  snackBar(context, 'Please Enter OTP', Colors.white, Colors.red);
                                }
                                else if(codeController.text.length < 5){
                                  snackBar(context, 'Please fill up OTP', Colors.white, Colors.red);

                                }
                                else{
                                  verifyOTP(codeController.text,context);
                                }
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen(),));
                              },
                            )
                                :const Center(child: CircularProgressIndicator()),


                            SizedBox(height: screenHeight / 40),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: isResendAvailable ? () {
                                    // Handle OTP resend
                                    resendOTP(widget.mobileNo,context);
                                  } : null,
                                  child: Text(
                                    isResendAvailable
                                        ? "Resend OTP"
                                        : "Resend OTP ($remainingSeconds Seconds)",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: isResendAvailable ? Colors.blue : Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            )

                          ],
                        ),
                      ),
          ],
        ),
      ),
    );
  }
  verifyOTP(String otp, BuildContext context)async{
    String getOTp= otp;
    setState(() {
      isLoading = true;
    });
    final Map<String,dynamic> data = {
      "mobile": widget.mobileNo,
      "otp": otp
    };
    await AuthService().otpVerify(data).then((response) async {

      final responseBody = json.decode(response.body??"");
      var status = responseBody['response']['status']??"";
      var message = responseBody['response']['message']??"";
      var token = responseBody['header']??"";

      print('responseBody-$responseBody');
      print('token-$token');

      if (status.toString().toUpperCase() =='success'.toUpperCase()) {
        await AuthService().checkAuth(token, context,widget.mobileNo).then((value) async {
          setState(() {
            isLoading = false;
          });
         //  var getD= await AuthService().getData;
         //  print(getD);
         //  final responseBody = json.decode(response.body??"");
         // print('responseBody-$responseBody');
         //  var status = responseBody['body']['profile']??"";
         //  print(status);
         //  var getPin = responseBody['body']['pin']??"";
         //  print(getPin);
         //  var getToken = responseBody['header']??"";
         //  print(getToken);
         //  print('checkAuth');
         //  print([responseBody,status,getPin,getToken]);


          // if(status != null && status.toString().isNotEmpty && getPin.toString().isNotEmpty){
          //   ///  home page
          //  await box.put('token', getToken.toString());
          //   box.put('mobile', widget.mobileNo.toString());
          //
          //   // Remove all previous routes and navigate to HomeScreen.
          //   Get.offAll(() => const BottomNavigationScreen());
          //  snackBar(context, 'Login Successful', Colors.white, Colors.green);
          //
          // }
          // else{
          //   /// Create User
          //   Navigator.pushAndRemoveUntil(
          //             context,
          //             MaterialPageRoute(builder: (context) =>   RegisterScreen(mobileNo: widget.mobileNo, getToken: '$token',)),
          //                 (route) => false,
          //           );
          // }

        }).onError((error, stackTrace) {
        });
        snackBar(context, message, Colors.white, Colors.green);
      }
      else {
        print('LoginErrorState-${responseBody['message']}');
        snackBar(context, message, Colors.white, Colors.red);
        setState(() {
          isLoading = false;
        });
      }
    }).onError((error, stackTrace){
      setState(() {
        isLoading = false;
      });
      snackBar(context, 'Login failed!', Colors.white, Colors.red);

    });
  }

  resendOTP(String mobile, BuildContext context)async{
    final Map<String,dynamic> data = {
      "mobile":mobile,
    };
    await AuthService().reSendOTP(data,context).then((response){

      final responseBody = json.decode(response.body??"");
      var status = responseBody['response']['status'];
      var message = responseBody['response']['message'];

      print('responseBody-$responseBody');

      if (status.toString().toUpperCase() =='success'.toUpperCase()) {
        snackBar(context, 'Sent OTP', Colors.white, Colors.green);
      }
      else {
        print('LoginErrorState-${responseBody['message']}');
        snackBar(context, message, Colors.white, Colors.red);
      }
    }).onError((error, stackTrace){
      snackBar(context, error.toString(), Colors.white, Colors.red);

    });
  }

}
