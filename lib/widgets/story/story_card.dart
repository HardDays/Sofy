import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoryCard extends StatelessWidget {
  const StoryCard({Key key, this.content = 'content', this.title = 'title', this.height = 168, this.width = 278}) : super(key: key);
  final String title;
  final String content;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   boxShadow: [
      //     BoxShadow(
      //       color: Color.fromRGBO(255, 255, 255, 0.25),
      //       offset: Offset(-5, -5),
      //       blurRadius: 15,
      //     ),
      //     BoxShadow(
      //       color: Color.fromRGBO(165, 106, 130, 0.12),
      //       offset: Offset(5, 5),
      //       blurRadius: 15,
      //     ),
      //   ],
      //   borderRadius: BorderRadius.circular(15.r),
      // ),
      width: width,
      height: height,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15.r), topRight: Radius.circular(15.r)),
              color: SofyStoryColors.CardHeaderColor,
            ),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Center(
              child: AutoSizeText(
                title,
                style: TextStyle(
                  fontFamily: Fonts.HindGunturBold,
                  fontWeight: FontWeight.w800,
                  fontSize: 15.sp,
                  color: SofyStoryColors.CardHeaderTextColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(15.r), bottomLeft: Radius.circular(15.r)),
              color: SofyStoryColors.BgColor,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Center(
                child: AutoSizeText(
              content,
              style: TextStyle(
                fontFamily: Fonts.Gilroy,
                fontSize: 15.sp,
                color: SofyStoryColors.CardTextColor,
              ),
              textAlign: TextAlign.center,
            )),
          )
        ],
      ),
    );
  }
}

class StoryCard1 extends StatelessWidget {
  const StoryCard1({Key key, this.content = 'content', this.title = 'title', this.height = 168, this.width = 278}) : super(key: key);
  final String title;
  final String content;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: new BoxConstraints(
        minHeight: 50.h,
        minWidth: 0.66 * Layout.width,
        maxHeight: 200.h,
        maxWidth: 0.66 * Layout.width,
      ),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(255, 255, 255, 0.25),
              offset: Offset(-5, -5),
              blurRadius: 15,
            ),
            BoxShadow(
              color: Color.fromRGBO(165, 106, 130, 0.12),
              offset: Offset(5, 5),
              blurRadius: 15,
            ),
          ],
          borderRadius: BorderRadius.circular(15.r),
        ),
        width: width,
        height: height,
        child: Column(
          children: [
            ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: 30.h,
                maxHeight: 50.h,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15.r), topRight: Radius.circular(15.r)),
                  color: SofyStoryColors.CardHeaderColor,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: Fonts.HindGunturBold,
                      fontWeight: FontWeight.w800,
                      fontSize: 15.sp,
                      color: SofyStoryColors.CardHeaderTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: 20.h,
                maxHeight: 150.h,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(15.r), bottomLeft: Radius.circular(15.r)),
                  color: SofyStoryColors.BgColor,
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Center(
                    child: AutoSizeText(
                  content,
                  style: TextStyle(
                    fontFamily: Fonts.Gilroy,
                    fontSize: 15.sp,
                    color: SofyStoryColors.CardTextColor,
                  ),
                  textAlign: TextAlign.center,
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
