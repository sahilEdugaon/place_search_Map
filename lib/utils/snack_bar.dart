import 'package:flutter/material.dart';

void snackBar(BuildContext context, String title,Color textColor ,Color backgroungColor) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroungColor,
          content: Text(title,textAlign: TextAlign.center,style: TextStyle(color: textColor),)
      )
  );
}
