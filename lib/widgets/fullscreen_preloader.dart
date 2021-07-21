import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/helper/size_config.dart';

class FullscreenPreloader extends StatelessWidget {
  const FullscreenPreloader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = SizeConfig.screenHeight;
    return Stack(
      alignment: Alignment.bottomCenter,
        children: [
      Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: ArticlesColors.BottomLg,
          ))),
      Center(
        child: Container(
          child: CircularProgressIndicator(
            color: kAppPinkDarkColor,
          ),
          height: height / 10,
          width: height / 10,
        ),
      ),
    ]);
    // return SingleChildScrollView(
    //     physics: NeverScrollableScrollPhysics(),
    //     child: Stack(
    //       children: [
    //         Column(
    //           children: [
    //             SizedBox(height: 200),
    //             Center(child: Text('I INSERT SHIMMER HERE')),
    //           ],
    //         )
    //       ],
    //     ));
  }
}
