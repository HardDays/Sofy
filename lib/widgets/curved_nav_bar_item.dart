import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/size_config.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CurvedNavBarItem extends StatelessWidget {
  const CurvedNavBarItem({Key key, @required this.title, @required this.svgAsset, this.selected = false}) : super(key: key);
  final bool selected;
  final String title;
  final String svgAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: selected ? Colors.white : null, shape: BoxShape.circle),
      padding: selected ? null : EdgeInsets.only(top: 10.h),
      width: selected ? 40.w : null,
      height: selected ? 40.h : null,

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          selected
              ? Expanded(
                  child: SvgPicture.asset(
                    svgAsset,
                    color: Color(0xFFE1397C),
                    width: 25.w,
                    height: 25.h,
                  ),
                )
              : SvgPicture.asset(
                  svgAsset,
                  color: Color(0xFFE1D2D5),
                  width: 25.w,
                  height: 25.h,
                ),
          if (!selected)
            SizedBox(
              height: 5.h,
            ),
          if (!selected)
            Text(
              AppLocalizations.of(context).translate(title),
              style: TextStyle(
                color: selected ? Color(0XFFFAA3B8) : Color(0xFFE1D2D5),
              ),
            ),
        ],
      ),
    );
  }
}
