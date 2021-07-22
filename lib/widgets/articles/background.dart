
import 'package:flutter/material.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/size_config.dart';

class Background extends StatelessWidget {
  const Background({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Stack(children: [
    //   Container(
    //       height: 4.6/ Layout.multiplier * SizeConfig.blockSizeVertical,
    //       width: SizeConfig.screenWidth,
    //       decoration: BoxDecoration(
    //           gradient: LinearGradient(
    //             begin: Alignment.topCenter,
    //             end: Alignment.bottomCenter,
    //             colors: ArticlesColors.BottomLg,
    //           )))
    // ]);
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: ArticlesColors.BottomLg,
        ),
      ),
    );
  }
}