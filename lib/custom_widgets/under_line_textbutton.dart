import 'package:flutter/material.dart';

import '../utils/colors_constant.dart';

class UnderlineTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final TextStyle? textStyle;

  const UnderlineTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: textStyle?.copyWith(
          decoration: TextDecoration.underline,
          color: ColorsConstant.buttonColor
        ) ??
            const TextStyle(
              decoration: TextDecoration.underline,
              color: ColorsConstant.buttonColor
            ),
      ),
    );
  }
}
