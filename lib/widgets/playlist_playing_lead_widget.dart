import 'package:flutter/material.dart';
import 'package:sofy_new/constants/app_colors.dart';

class PlayingLeadWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.0,
      width: 56.0,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0x753f3d56),
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        child: Center(
          child: Container(
            height: 12,
            width: 12,
            decoration: BoxDecoration(
              color: kAppPinkDarkColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    ) ;
  }
}
