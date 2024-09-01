import 'package:flutter/material.dart';

import '../utils/colors_constant.dart';


class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final TextStyle textStyle;
  final IconData? icons;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icons,
    this.color = ColorsConstant.buttonColor,
    this.textStyle = const TextStyle(color: Colors.white),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var finalHeight = MediaQuery.of(context).size.height;
    var finalWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: finalHeight/15,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: textStyle,
            ),
            Icon(icons, color: Colors.white, size: finalHeight/40,)
          ],
        ),
      ),
    );
  }
}
