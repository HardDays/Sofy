import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:sofy_new/constants/app_colors.dart';

class SofyInfo extends StatelessWidget {
  const SofyInfo({Key key, this.text}) : super(key: key);
final String text;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(
          top: height / 29.86,
          left: 20.0,
          right: 20.0),
      child: Badge(
        padding: EdgeInsets.all(3),
        elevation: 0.0,
        shape: BadgeShape.square,
        borderRadius: BorderRadius.circular(6.0),
        child: Container(
          padding: EdgeInsets.all(20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: kSettingInActiveButtonColor,
              borderRadius: BorderRadius.all(
                  Radius.circular(13.0))),
          child: Text(text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kWelcomDarkTextColor,
              fontSize: 13,
              height: 1.343,
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
        showBadge: false,
      ),
    );
  }
}
