import 'package:flutter/material.dart';
import 'package:sofy_new/constants/app_colors.dart';

class SofyTextButton extends StatelessWidget {
  const SofyTextButton(
      {Key key, this.label = 'text btn', this.callback, this.fontSize = 16})
      : super(key: key);
  final String label;
  final double fontSize;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Text(
          label,
          style: TextStyle(
              color: SofyTextButtonColors.LabelColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto'),
        ),
      ),
      onTap: callback,
    );
  }
}
