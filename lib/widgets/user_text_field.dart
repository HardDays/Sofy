import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';

// ignore: must_be_immutable
class UserTextField extends StatefulWidget {
  final Function onTap;
  final String text;
  final String iconUrl;
  final BorderRadius borderRadius;
  double height;
  final bool isPass;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool enable;

  UserTextField(
      {this.onTap,
      this.text,
      this.iconUrl,
      this.height,
      this.borderRadius,
      this.isPass,
      this.controller,
      this.textInputType,
      this.enable});

  @override
  _UserTextField createState() => _UserTextField();
}

class _UserTextField extends State<UserTextField> {
  @override
  Widget build(BuildContext context) {
    if (widget.height == 0) {
      widget.height = 0;
    } else {
      widget.height = MediaQuery.of(context).size.height;
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: widget.height / 40.72),
      height: widget.height / 14.45,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: kSettingInActiveButtonColor,
        borderRadius: widget.borderRadius,
      ),
      child: Container(
          child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: widget.height / 49.77),
            alignment: Alignment.center,
            child: AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                height: widget.height / 32.0,
                width: widget.height / 32.0,
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  widget.iconUrl,
                  color: kSettingActiveButtonColor,
                )),
          ),
          Expanded(
              child: Container(
                  padding: EdgeInsets.only(right: 15.0),
                  alignment: Alignment.center,
                  height: widget.height / 14.45,
                  child: TextField(
                    enabled: widget.enable,
                      maxLines: 1,
                      style: TextStyle(
                          fontFamily: Fonts.GilroyBold,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          fontSize: widget.height / 59.73,
                          color: Color(0xff836771)),
                      obscureText: widget.isPass,
                      controller: widget.controller,
                      keyboardType: widget.textInputType,
                      decoration: InputDecoration(
                          labelStyle: TextStyle(
                              fontFamily: Fonts.GilroyBold,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              fontSize: widget.height / 64,
                              color: Color(0x40836771)),
                          labelText: widget.text,
                          border: InputBorder.none))))
        ],
      )),
    );
  }
}
