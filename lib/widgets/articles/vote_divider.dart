
import 'package:flutter/material.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/helper/size_config.dart';

class SofyDivider extends StatelessWidget {
  const SofyDivider({Key key, this.icon = const IconData(1)}) : super(key: key);

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    double width = SizeConfig.screenWidth;
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20, left: 20.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 1.0,
            width: width / 3 - 20,
            color: Color.fromARGB(172, 237, 195, 237),
          ),
          icon == IconData(1) ? Container() : Container(
              margin: EdgeInsets.only(left: 21.0),
              child: Icon(
                icon,
                color: SvgColors.Done1Color,
              )),
          icon == IconData(1) ? Container() : Container(
              margin: EdgeInsets.only(right: 5.0, left: 5.0),
              child: Icon(
                icon,
                color: SvgColors.Done2Color,
              )),
          icon == IconData(1) ? Container() : Container(
              margin: EdgeInsets.only(right: 21.0),
              child: Icon(
                icon,
                color: SvgColors.Done1Color,
              )),
          Container(
            height: 1.0,
            width: width / 3 - 20,
            color: Color.fromARGB(172, 237, 195, 237),
          ),
        ],
      ),
    );
  }
}