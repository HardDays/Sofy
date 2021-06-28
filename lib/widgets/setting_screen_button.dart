import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';

// ignore: must_be_immutable
class SettingScreenButton extends StatefulWidget {
  final Function onTap;
  final String text;
  final String iconUrl;
  final BorderRadius borderRadius;
  double height;

  SettingScreenButton(
      {this.onTap, this.text, this.iconUrl, this.height, this.borderRadius});

  @override
  _SettingScreenButtonState createState() => _SettingScreenButtonState();
}

class _SettingScreenButtonState extends State<SettingScreenButton> {
  bool toggle = false;

  @override
  Widget build(BuildContext context) {
    if (widget.height == 0) {
      widget.height = 0;
    } else {
      widget.height = MediaQuery.of(context).size.height;
    }
    return Container(
      height: widget.height / 14.45,
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        borderRadius: widget.borderRadius,
        onTap: widget.onTap,
        onHighlightChanged: (status) {
          setState(() {
            toggle = !toggle;
          });
        },
        child: AnimatedContainer(
          padding: EdgeInsets.only(right: 19.0),
          height: widget.height / 14.45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: toggle
                ? kSettingActiveButtonColor
                : kSettingInActiveButtonColor,
            borderRadius: widget.borderRadius,
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: new EdgeInsets.only(top: widget.height / 49.77),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left:16.0, right: 16.0),
                          alignment: Alignment.center,
                          child: AnimatedContainer(
                              duration: Duration(seconds: 1),
                              curve: Curves.fastOutSlowIn,
                              height: widget.height / 32.0,
                              width: widget.height / 32.0,
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                widget.iconUrl,
                                color: toggle
                                    ? kArticlesWhiteColor
                                    : kSettingActiveButtonColor,
                              )),
                        ),
                        Expanded(
                          child: Text(
                            widget.text,
                            style: TextStyle(
                              fontFamily: kFontFamilyGilroyBold,
                              fontWeight: FontWeight.bold,
                              fontSize: widget.height / 64.0,
                              color: kWelcomDarkTextColor,
                            ),
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/svg/arrow_next_vector.svg',
                          height: 12.0,
                          color: toggle
                              ? kSettingInActiveButtonColor
                              : kWelcomDarkTextColor,
                        ),
                      ],
                    )),
                Container(
                  margin: EdgeInsets.only(left:16.0),
                  height: 1.0,
                  width: MediaQuery.of(context).size.width,
                  color: kSettScrBtnWidgetColor,
                )
              ]),
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
  }
}
