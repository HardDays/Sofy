import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/helper/size_config.dart';
import 'package:sofy_new/widgets/articles/background.dart';

class FullscreenPreloader extends StatelessWidget {
  const FullscreenPreloader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = SizeConfig.screenHeight;
    return Stack(alignment: Alignment.bottomCenter, children: [
      Background(),
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
    // return Single
  }
}

