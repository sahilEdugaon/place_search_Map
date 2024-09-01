import 'package:flutter/material.dart';

import '../utils/colors_constant.dart';

class CustomContainerTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final String labelTexts;
  final Color leftBorderColor;

  const CustomContainerTextField({
    Key? key,
    this.hintText,
    required this.controller,
    required this.labelTexts,
    this.obscureText = false,
    this.suffixIcon,
    this.leftBorderColor = ColorsConstant.buttonColor, // Default left border color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var finalHeight = MediaQuery.of(context).size.height;
    var finalWidth = MediaQuery.of(context).size.width;
    return Container(
      height: finalHeight/13,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border(
          left: BorderSide(color: leftBorderColor, width: 4.0), // Left border color
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
            labelStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          labelText: labelTexts
        ),
      ),
    );
  }
}
