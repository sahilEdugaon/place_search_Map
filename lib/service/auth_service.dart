
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../utils/snack_bar.dart';
import '../views/bottom_nav/bottom_nav.dart';
import '../views/register_screen.dart';


class AuthService {
  String urlCreateUser = "https://cba.albrandz.in/cba/api/passenger/profile";
  String otpUrl = "https://cba.albrandz.in/cba/api/passenger/login/otp";
  String otpVerifyUrl = "https://cba.albrandz.in/cba/api/passenger/verify/otp";
  String resendOTP = "https://cba.albrandz.in/cba/api/passenger/resend/otp";
  String checkAuthUser = "https://cba.albrandz.in/cba/api/passenger/profile";
  var box = Hive.box('details');

  Future<http.Response> otpService(Map<String, dynamic> data) async {
    print('data: $data');
    print('encoded data: ${json.encode(data)}');

    try {
      http.Response response = await http.post(
        Uri.parse(otpUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      print('response: $response');
      print('statusCode: ${response.statusCode}');
      print('body: ${response.body}');
      var decodedResponse = jsonDecode(response.body);
      var status = decodedResponse['response']['status'];

      if (response.statusCode == 200) {
        return response;
      } else {
        // Handle non-200 status codes
        print('Error: Received status code ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } on SocketException catch (e) {
      print('SocketException: $e');
      // Handle network errors here
      throw Exception('Network error');
    } on HttpException catch (e) {
      print('HttpException: $e');
      // Handle HTTP errors here
      throw Exception('HTTP error');
    } on FormatException catch (e) {
      print('FormatException: $e');
      // Handle data format errors here
      throw Exception('Data format error');
    } catch (err) {
      print('Exception: $err');
      throw Exception('Unexpected error');
    }
  }
  Future<http.Response> otpVerify(Map<String, dynamic> data) async {
    print('data: $data');
    print('encoded data: ${json.encode(data)}');

    try {
      http.Response response = await http.post(
        Uri.parse(otpVerifyUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      print('response: $response');
      print('statusCode: ${response.statusCode}');
      print('body: ${response.body}');
      var decodedResponse = jsonDecode(response.body);
      var status = decodedResponse['response']['status'];

      if (response.statusCode == 200) {
        return response;
      } else {
        // Handle non-200 status codes
        print('Error: Received status code ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } on SocketException catch (e) {
      print('SocketException: $e');
      // Handle network errors here
      throw Exception('Network error');
    } on HttpException catch (e) {
      print('HttpException: $e');
      // Handle HTTP errors here
      throw Exception('HTTP error');
    } on FormatException catch (e) {
      print('FormatException: $e');
      // Handle data format errors here
      throw Exception('Data format error');
    } catch (err) {
      print('Exception: $err');
      throw Exception('Unexpected error');
    }
  }
  Future<http.Response> checkAuth(String getTken,BuildContext context, mobileNo) async {
    print('data: $getTken');

    try {
      http.Response response = await http.get(
        Uri.parse(checkAuthUser),
        headers: {
          'Authorization': 'Bearer $getTken',
        },
      );

      print('response: $response');
      print('statusCode: ${response.statusCode}');
      print('body: ${response.body}');
      Future.delayed(const Duration(seconds: 1));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body??"");
        var status = responseBody['body']['profile']??"";
        print('status-$status');
        var getPin = responseBody['body']['pin']??"";
        print('getPin-$getPin');
        var getToken = responseBody['header']??"";
        print(getToken);
        print('checkAuth');
        print([responseBody,status,getPin,getToken]);

        if(status != null && status.toString().isNotEmpty && getPin.toString().isNotEmpty){
          ///  home page
          await box.put('token', getToken.toString());
          box.put('mobile', mobileNo.toString());
          box.put('name', status['firstName']??status['name']);
          box.put('email', status['email']);

          // Remove all previous routes and navigate to HomeScreen.
          Get.offAll(() => const BottomNavigationScreen());
          snackBar(context, 'Login Successful', Colors.white, Colors.green);

        }
        else{
          /// Create User
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) =>   RegisterScreen(mobileNo:mobileNo, getToken: '$getTken',)),
                (route) => false,
          );
        }

        return response;
      } else {
        // Handle non-200 status codes
        print('Error: Received status code ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } on SocketException catch (e) {
      print('SocketException: $e');
      // Handle network errors here
      throw Exception('Network error');
    } on HttpException catch (e) {
      print('HttpException: $e');
      // Handle HTTP errors here
      throw Exception('HTTP error');
    } on FormatException catch (e) {
      print('FormatException: $e');
      // Handle data format errors here
      throw Exception('Data format error');
    } catch (err) {
      print('Exception: $err');
      throw Exception('Unexpected error');
    }
  }

  Future<http.Response> reSendOTP(Map<String, dynamic> data,BuildContext context) async {
    print('data: $data');
    print('encoded data: ${json.encode(data)}');

    try {
      http.Response response = await http.put(
        Uri.parse(resendOTP),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      print('response: $response');
      print('statusCode: ${response.statusCode}');
      print('body: ${response.body}');

      if (response.statusCode == 200) {
        // final responseBody = json.decode(response.body??"");
        // var status = responseBody['response']['status'];
        // var message = responseBody['response']['message'];
        //
        // if(status.toString().toUpperCase() =='success'.toUpperCase()){
        //   snackBar(context, 'OTP Sent', Colors.white, Colors.green);
        // }
        return response;
      } else {
        // Handle non-200 status codes
        print('Error: Received status code ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } on SocketException catch (e) {
      print('SocketException: $e');
      // Handle network errors here
      throw Exception('Network error');
    } on HttpException catch (e) {
      print('HttpException: $e');
      // Handle HTTP errors here
      throw Exception('HTTP error');
    } on FormatException catch (e) {
      print('FormatException: $e');
      // Handle data format errors here
      throw Exception('Data format error');
    } catch (err) {
      print('Exception: $err');
      throw Exception('Unexpected error');
    }
  }

  Future<http.Response?> createAccountService(
      Map<String, dynamic> data, BuildContext context, String getTken) async {
    print('data: $data');
    print('encoded data: ${json.encode(data)}');

    try {
      http.Response response = await http.post(
        Uri.parse(urlCreateUser),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $getTken',
        },
        body: json.encode(data), // Ensure the body is JSON encoded
      );

      print('response: $response');
      print('response body: ${response.body}');
      print('response statusCode: ${response.statusCode}');

      if (response.statusCode == 200) {
        return response;
      } else {
        // Handle non-200 status codes
        print('Error: Received status code ${response.statusCode}');
        final responseBody = json.decode(response.body);
        print(responseBody);

        final errorMessage = responseBody['message'] ?? 'Unknown error occurred';
        print(errorMessage);
        return response;
        //snackBar(context, errorMessage, Colors.white, Colors.red);

       // throw http.Response(errorMessage, response.statusCode, reasonPhrase: response.reasonPhrase);
      }
    } on SocketException catch (e) {
      print('SocketException: $e');
      throw Exception('Network error');
    } on HttpException catch (e) {
      print('HttpException: $e');
      throw Exception('HTTP error');
    } on FormatException catch (e) {
      print('FormatException: $e');
      throw Exception('Data format error');
    } catch (err) {
      print('Exception: $err');
      throw Exception('Unexpected error');
    }
  }

}

