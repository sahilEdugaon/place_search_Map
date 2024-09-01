import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:final_taxi_app/views/submit_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../custom_widgets/custom_button.dart';
import '../service/auth_service.dart';
import '../utils/snack_bar.dart';
import 'bottom_nav/bottom_nav.dart';


class RegisterScreen extends StatefulWidget {
  final String mobileNo;
  final String getToken;
  const RegisterScreen({super.key,required this.mobileNo,required this.getToken});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;
  bool _isChecked = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  String? selectedGender ;
  var box = Hive.box('details');

  @override
  void initState() {
    // Remove the "+91" prefix
    String cleanedNumber = widget.mobileNo.replaceFirst("+91", "");
    numberController.text = cleanedNumber;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  "assets/images/Images-4.png",
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: SizedBox(
                height: screenHeight/1.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create Profile",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenHeight / 38,
                      ),
                    ),
                    SizedBox(height: screenHeight / 50),
        
                    Text("Enter Full Name *"),
                    TextField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        hintText: 'Enter Full Name',
                        contentPadding: EdgeInsets.all(0),
                        prefixIcon: Icon(Icons.person_2_outlined, color: Colors.grey,),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey, width: 1),
                        ),),
                    ),
                    SizedBox(height: screenHeight / 50),
        
                    const Text("Mobile No."),
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
                      initialCountryCode: 'IN',
                      disableLengthCheck: true,
                      textAlign: TextAlign.left,
                      controller: numberController,
                      keyboardType: TextInputType.phone,
                      readOnly: true,
                      onChanged: (phone) {
                        print(phone.completeNumber);
                      },
                    ),
                    SizedBox(height: screenHeight / 50),
        
                    const Text("Email ID"),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Enter Email',
                        contentPadding: EdgeInsets.all(0),
                        prefixIcon: Icon(Icons.mail_outline, color: Colors.grey,),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey, width: 1),
                        ),),
                    ),
                    SizedBox(height: screenHeight/50),
        
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: screenWidth/2.3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Date of birth"),
                              TextField(
                                controller: dobController,
                                keyboardType: TextInputType.datetime,
                                decoration: InputDecoration(
                                  hintText: 'DOB',
                                  contentPadding: EdgeInsets.all(0),
                                  prefixIcon: Icon(Icons.calendar_today_outlined, color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                                  ),
                                ),
                                onTap: () async {
                                  FocusScope.of(context).requestFocus(FocusNode()); // Prevent keyboard from appearing
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                  );
                                  if (pickedDate != null) {
                                    setState(() {

                                      print('pickedDate-$pickedDate');

                                      // Format the date into the desired format
                                      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

                                      dobController.text = formattedDate;
                                    });

                                    print('dobController-${dobController.text}');
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: screenWidth/2.3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Gender"),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.male_outlined, color: Colors.grey,),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                                  ),
                                ),
                                value: selectedGender,
                                items: ['Male', 'Female', 'Other']
                                    .map((gender) => DropdownMenuItem<String>(
                                  value: gender,
                                  child: Text(gender, style: TextStyle(fontSize: screenHeight/52),),
                                ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedGender = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight/50),
        
                    Text("Pin (6 Digit)"),
                    TextField(
                      controller: pinController,
                      maxLength: 6,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintText: '******',
                        contentPadding: EdgeInsets.all(0),
                        prefixIcon: Icon(Icons.lock_outline, color: Colors.grey,),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        counterText: "",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey, width: 1),
                        ),),
                    ),
        
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isChecked = !_isChecked;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey, // Outline color
                                  width: 1, // Outline width
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Container(
                                width: screenWidth/14,
                                height: screenHeight/30,
                                color: _isChecked ? Colors.transparent : Colors.transparent,
                                child: _isChecked
                                    ? Icon(
                                  Icons.check,
                                  size: screenHeight/30,
                                  color: Colors.green,
                                )
                                    : null,
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth/50,),
                          Wrap(
                            children: [
                              Text('I have reviewed and agree to the Terms of Use\n& acknowledge the Privacy Policy',
                                style: TextStyle(fontSize: screenHeight/70,),),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 8,),
                 isLoading == false
                  ?CustomButton(
                      text: "Continue",
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                      onPressed: () {
                        if(numberController.text.isEmpty || nameController.text.isEmpty ||
                            dobController.text.isEmpty || selectedGender == null ||
                            emailController.text.isEmpty|| pinController.text.isEmpty){
                          snackBar(context, 'Please Enter All Dataddd', Colors.white, Colors.red);
                          print('iiif');
                        }
                        else if(EmailValidator.validate(emailController.text)==false){
                          snackBar(context, 'Please Enter Valid Email', Colors.white, Colors.red);
                        }
                        else if(_isChecked==false){
                          snackBar(context, 'Please Accept the Privacy Policies', Colors.white, Colors.red);
                        }
                        else{
                          print('onpressed');
                          // print([
                          //   fullNameController.text,phoneController.text,emailController.text,dobController.text,gender!,pinController.text
                          // ]);
                          createUser(nameController.text,widget.mobileNo,emailController.text,dobController.text,selectedGender!,pinController.text,context);
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => const SubmitProfileScreen(),));

                        }

                      },
                    )
                     :const Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  createUser(String fullName,String mobileNo,String emailId, String dob,
      String gender,String cretePIn , BuildContext context)async{

    setState(() {
       isLoading = true;
    });
    final Map<String,dynamic> data = {
      "name": fullName,
      "email": emailId,
      "dob": dob,
      "gender": gender,
      "pin": cretePIn
    };
    await AuthService().createAccountService(data,context,widget.getToken).then((response) async {

      final responseBody = json.decode(response!.body??"");
      var status = responseBody['response']['status']??"";
      var message = responseBody['response']['message']??"";
      var token = responseBody['header']??"";

      print('responseBody-$responseBody');
      setState(() {
        isLoading = false;
      });
      if (status.toString().toUpperCase() =='success'.toUpperCase()) {
        await box.put('token', token);
        box.put('mobile', widget.mobileNo);
        box.put('name', fullName);
        box.put('email', emailId);

        Get.offAll(() => const SubmitProfileScreen());
        snackBar(context, message, Colors.white, Colors.green);
      }
      else {
        print('LoginErrorState-${responseBody['message']}');
        snackBar(context, message, Colors.white, Colors.red);
      }
    }).onError((error, stackTrace){
      snackBar(context, 'Create User failed!', Colors.white, Colors.red);
      setState(() {
        isLoading = false;
      });
    });
  }

}
