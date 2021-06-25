import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';

// ignore: must_be_immutable
class CreateAccountButton extends StatefulWidget {
  final Function onTap;
  final String text;
  final String iconUrl;
  final BorderRadius borderRadius;
  double height;
  final int backColor;

  CreateAccountButton(
      {this.onTap,
      this.text,
      this.iconUrl,
      this.height,
      this.borderRadius,
      this.backColor});

  @override
  _CreateAccountButton createState() => _CreateAccountButton();
}

class _CreateAccountButton extends State<CreateAccountButton> {
  bool toggle = false;

  @override
  Widget build(BuildContext context) {
    if (widget.height == 0) {
      widget.height = 0;
    } else {
      widget.height = MediaQuery.of(context).size.height;
    }
    return Container(
      height: widget.height / 14.00,
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
          height: widget.height / 14.00,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: toggle
                ? kSettingActiveButtonColor
                : kSettingInActiveButtonColor,
            borderRadius: widget.borderRadius,
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 13.0, right: 11.0),
                      alignment: Alignment.center,
                      child: widget.iconUrl.contains('http')
                          ? AnimatedContainer(
                          duration: Duration(seconds: 1),
                          curve: Curves.fastOutSlowIn,
                          height: widget.height / 23.57,
                          width: widget.height / 23.57,
                          alignment: Alignment.center,
                          child:
                          ClipRRect(
                            borderRadius: BorderRadius.all(
                                Radius.circular(100)),
                            child: Image.network(
                              widget.iconUrl,
                              height: widget.height / 23.57,
                              width: widget.height / 23.57,
                              fit: BoxFit.cover,
                            ),
                          ))
                          : AnimatedContainer(
                              duration: Duration(seconds: 1),
                              curve: Curves.fastOutSlowIn,
                              height: widget.height / 23.57,
                              width: widget.height / 23.57,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(widget.backColor != null ? widget.backColor : 0x00ffffff),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100.0)),
                                image: DecorationImage(
                                  image: AssetImage(widget.iconUrl),
                                  fit: BoxFit.cover,
                                ),
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
              ]),
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
  }
}
