import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/size_config.dart';
import 'package:sofy_new/models/subscribe_data.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard(
      {Key key,
      this.title = 'Title',
      this.path = 'assets/articles/card_1.png',
      this.width = 242,
      this.height = 293,
      this.frozenHeight = 81,
      this.fontSize = 17,
      this.textColor = const Color(0x725E5C),
      this.radius = 27,
      this.isPaid = 1,
      this.callback})
      : super(key: key);
  final double radius;
  final double height;
  final double width;
  final double frozenHeight;
  final Color textColor;
  final double fontSize;
  final String title;
  final String path;
  final int isPaid;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    double screenHeight = SizeConfig.screenHeight;

    return InkWell(
      onTap: callback,
      child: Container(
        height: height,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: kArticleCardBgColor,
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              fit: StackFit.expand,
              children: [
                // Image.network(path, fit: BoxFit.cover,),
                ExtendedImage.network(
                  path,
                  fit: BoxFit.cover,
                  cache: true,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 32.0,
                            sigmaY: 32.0,
                          ),
                          child: Container(
                            width: width,
                            height: frozenHeight,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(5, 255, 255, 255),
                            ),
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.all(2),
                              child: AutoSizeText(
                                title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: fontSize,
                                  fontFamily: Fonts.Roboto,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  // ignore: null_aware_in_logical_operator
                  visible: isPaid == 1 ? true : false,
                  child: Container(
                    height: Provider.of<SubscribeData>(context).isAppPurchase ? 0.0 : screenHeight,
                    width: Provider.of<SubscribeData>(context).isAppPurchase ? 0.0 : screenHeight,
                    decoration: BoxDecoration(
                      //color: Color(0x75C4C4C4),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    alignment: Alignment.topRight,
                    child: Container(
                        height: screenHeight / 12.6,
                        width: screenHeight / 12.6,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/new_lock.png'),
                            fit: BoxFit.fill,
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
