import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SofyBadge extends StatelessWidget {
  const SofyBadge({Key key, this.text = '', this.path = ''}) : super(key: key);

  final String path;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.h),
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: SofyBadgeColors.BgColor,
          boxShadow: [
            BoxShadow(
              color: SofyBadgeColors.PositiveShadowColor,
              offset: Offset(4, 4),
              blurRadius: 10,
            ),
          ],
          borderRadius: BorderRadius.circular(28.r),
        ),
        child: Container(
          height: 36.h,
          decoration: BoxDecoration(
            color: SofyBadgeColors.BgColor,
            boxShadow: [
              BoxShadow(
                color: SofyBadgeColors.NagativeShadowColor,
                offset: Offset(-4, -4),
                blurRadius: 10,
              ),
            ],
            borderRadius: BorderRadius.circular(28.r),
          ),
          child: Row(
            children: [
              path != ''
                  ? Padding(
                    padding: EdgeInsets.only(left: 18.w, right: 7.5.w),
                    child: SvgPicture.asset(path, color: SofyBadgeColors.IconColor),
                  )
                  : Container(width: 0),
              text != ''
                  ? Padding(
                padding: EdgeInsets.only(right: 17.w),
                    child: Text(
                        text,
                        style: TextStyle(fontSize: 13.sp, color: SofyBadgeColors.Text),
                      ),
                  )
                  : SizedBox(width: 10.5.w),
            ],
          ),
        ),
      ),
    );
  }
}
