import 'package:flutter/material.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SofyTextButton extends StatelessWidget {
  const SofyTextButton(
      {Key key, this.label = 'text btn', this.callback})
      : super(key: key);
  final String label;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Text(
          label,
          style: TextStyle(
              color: SofyTextButtonColors.LabelColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto'),
        ),
      ),
      onTap: callback,
    );
  }
}
