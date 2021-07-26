import 'package:flutter/material.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/size_config.dart';

class SofyDivider extends StatelessWidget {
  const SofyDivider({Key key, this.icon = const IconData(1), this.size = 9}) : super(key: key);

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    double width = SizeConfig.screenWidth;
    return Container(
      // padding: EdgeInsets.only(
      //     top: 14 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
      //     bottom: 14 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
          // left: 20.0 / Layout.width * Layout.multiplier * SizeConfig.blockSizeHorizontal,
          // right: 20.0 / Layout.width * Layout.multiplier * SizeConfig.blockSizeHorizontal
        // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 1.0,
            width: width / 3,
            color: Color.fromARGB(172, 237, 195, 237),
          ),
          icon == IconData(1)
              ? Container()
              : Container(
                  margin: EdgeInsets.only(left: 21.0),
                  child: Icon(
                    icon,
                    color: SvgColors.Done1Color,
                    size: size / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                  )),
          icon == IconData(1)
              ? Container()
              : Container(
                  margin: EdgeInsets.only(right: 5.0, left: 5.0),
                  child: Icon(
                    icon,
                    color: SvgColors.Done2Color,
                    size: size / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                  )),
          icon == IconData(1)
              ? Container()
              : Container(
                  margin: EdgeInsets.only(right: 21.0),
                  child: Icon(
                    icon,
                    color: SvgColors.Done1Color,
                    size: size / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                  )),
          Container(
            height: 1.0,
            width: width / 3,
            color: Color.fromARGB(172, 237, 195, 237),
          ),
        ],
      ),
    );
  }
}
