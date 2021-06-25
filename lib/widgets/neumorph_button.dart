import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';

import 'neumorphic/neumorphic_button.dart';

// ignore: must_be_immutable
class NeumorphButton extends StatefulWidget {
  final Function onTap;
  final String text;
  final String iconLeft;
  final String iconRight;
  final double height;
  final double width;

  NeumorphButton(
      {this.onTap, this.text, this.iconLeft, this.iconRight, this.height, this.width});

  @override
  _NeumorphButton createState() => _NeumorphButton();
}

class _NeumorphButton extends State<NeumorphButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Color(0xffC4C4C4),
            offset: Offset(3, 3),
            blurRadius: 10.0,
          ),
        ]),
        height: widget.height / 17.23,
        child: NeumorphicCustomButton(
            style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
                intensity: 0.6,
                shadowLightColorEmboss: Color(0xffFBE5FB),
                shadowDarkColor: Color(0xffFBE5FB),
                shadowDarkColorEmboss: Color(0xff663966),
                shadowLightColor: kArticlesWhiteColor,
                color: Color(0xffFCEFFC)),
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
            provideHapticFeedback: false,
            onClick: widget.onTap,
            padding: EdgeInsets.all(0.0),
            child: Container(
                height: widget.height / 17.23,
                width: widget.width,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFFFDB0C1),
                        const Color(0xFFFF95AC),
                      ],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffFFBFCD),
                        offset: Offset(7, 7),
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    children: <Widget>[
                      widget.iconLeft != null ? Container(
                        margin:
                        EdgeInsets.only(right: 8.0),
                        child: SvgPicture.asset(
                          widget.iconLeft,
                        ),
                      ) : Container(),
                      Center(
                          child: Text(
                            widget.text,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: kFontFamilyMontserratBold,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              fontSize: widget.height / 56,
                              height: 1.44,
                              color: kArticlesWhiteColor,
                            ),
                          ),
                        ),
                      widget.iconRight != null ? Container(
                        margin:
                        EdgeInsets.only(left: 8.0),
                        child: SvgPicture.asset(
                          widget.iconRight,
                        ),
                      ) : Container(),
                    ],
                  ),
                ))));
  }
}
