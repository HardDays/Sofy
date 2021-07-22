import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/size_config.dart';

class SofyInfo extends StatelessWidget {
  const SofyInfo({Key key, this.text}) : super(key: key);
final String text;
  @override
  Widget build(BuildContext context) {
    double height = SizeConfig.screenHeight;

    return Padding(
      padding: EdgeInsets.only(
          top: height / 29.86/ Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
          left: 20.0/ Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
          right: 20.0/ Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical),
      child: Badge(
        padding: EdgeInsets.all(3/ Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical),
        elevation: 0.0,
        shape: BadgeShape.square,
        borderRadius: BorderRadius.circular(6.0/ Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical),
        child: Container(
          padding: EdgeInsets.all(20/ Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: kSettingInActiveButtonColor,
              borderRadius: BorderRadius.all(
                  Radius.circular(13.0/ Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical))),
          child: Text(text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kWelcomDarkTextColor,
              fontSize: 13/ Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
              height: 1.343/ Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
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
