import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/helper/size_config.dart';

class StoryBackground extends StatelessWidget {
  const StoryBackground({
    Key key,
    @required this.coverImg,
  }) : super(key: key);

  final String coverImg;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        child: ExtendedImage.network(
          coverImg,
          cache: true,
          fit: BoxFit.cover,
        ),
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
      ),
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: BoxDecoration(color: SofyStoryColors.TransparentColor),
        ),
      ),
    ]);
  }
}
