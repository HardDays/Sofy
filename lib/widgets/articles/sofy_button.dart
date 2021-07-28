import 'package:flutter/material.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SofyButton extends StatelessWidget {
  const SofyButton({
    Key key,
    this.width,
    this.linearGradientColors = const [
      Color(0xFFFDB0C1),
      Color(0xFFFF95AC),
    ],
    this.label = 'button',
    this.labelColor = Colors.white,
    this.callback,
  }) : super(key: key);
  final double width;
  final List<Color> linearGradientColors;
  final Color labelColor;
  final String label;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(229, 207, 178, 205),
                offset: Offset(4, 4),
                blurRadius: 10.0,
              ),
            ],
            gradient: LinearGradient(
              colors: linearGradientColors,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(9.r),
          ),
          height: 52.h,
          width: width,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                  color: labelColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: Fonts.HindGunturBold),
            ),
          ),
        ),
      ),
      onTap: callback,
    );
  }
}
/*
width: 372px;
height: 52px;
left: 22px;
top: 2117px;

background: linear-gradient(180deg, #FDB0C1 0%, #FF95AC 100%), #C4C4C4;
box-shadow: -4px -4px 10px #FFFFFF, 4px 4px 10px rgba(207, 178, 205, 0.9), 0px 7px 18px rgba(255, 150, 173, 0.49);
border-radius: 9px;
 */
