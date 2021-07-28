import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/size_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SofyInfo extends StatelessWidget {
  const SofyInfo({Key key, this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Badge(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
      elevation: 0.0,
      shape: BadgeShape.square,
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: kSettingInActiveButtonColor, borderRadius: BorderRadius.all(Radius.circular(13.r))),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: SofyRateColors.CardTextColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              fontFamily: Fonts.HindGuntur),
        ),
      ),
      showBadge: false,
    );
  }
}
