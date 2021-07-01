import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:sofy_new/constants/app_colors.dart';

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
      this.radius = 27})
      : super(key: key);
  final double radius;
  final double height;
  final double width;
  final double frozenHeight;
  final Color textColor;
  final double fontSize;
  final String title;
  final String path;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: textColor, fontSize: fontSize),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
