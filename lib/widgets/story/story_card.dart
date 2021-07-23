import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/size_config.dart';

class StoryCard extends StatelessWidget {
  const StoryCard({Key key, this.content = 'content', this.title = 'title', this.height = 168, this.width = 278}) : super(key: key);
  final String title;
  final String content;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: new BoxConstraints(
        minHeight: 20 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical + 30 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
        minWidth: 0.66 * Layout.width,
        maxHeight: 150 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical + 50 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
        maxWidth: 0.66 * Layout.width,
      ),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(255, 255, 255, 0.25),
              offset: Offset(-5, -5),
              blurRadius: 15,
            ),
            BoxShadow(
              color: Color.fromRGBO(165, 106, 130, 0.12),
              offset: Offset(5, 5),
              blurRadius: 15,
            ),
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        width: width,
        height: height,
        child: Column(
          children: [
            ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: 30 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                maxHeight: 50 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  color: SofyStoryColors.CardHeaderColor,
                ),
                padding: EdgeInsets.all(10),
                child: Center(
                  child: AutoSizeText(
                    title,
                    style: TextStyle(
                      fontFamily: Fonts.AbhayaLibreExtraBold,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: SofyStoryColors.CardHeaderTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: 20 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                maxHeight: 150 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
                  color: SofyStoryColors.BgColor,
                ),
                padding: EdgeInsets.all(16),
                child: Center(
                    child: AutoSizeText(
                  content,
                  style: TextStyle(
                    fontFamily: Fonts.Gilroy,
                    fontSize: 15,
                    color: SofyStoryColors.CardTextColor,
                  ),
                  textAlign: TextAlign.center,
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
