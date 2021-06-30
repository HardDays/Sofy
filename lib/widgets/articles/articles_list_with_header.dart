import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/models/api_article_articles_model.dart';
import 'package:sofy_new/providers/app_localizations.dart';

class ArticlesListWithHeader extends StatelessWidget {
  const ArticlesListWithHeader(
      {Key key,
      this.title,
      this.listOfArticles,
      this.textColor = kArticlesHeaderTextColor,
      this.fontSize = 24,
      this.cardHeight = 50,
      this.cardWidth = 50,
      this.imageRadius = 8})
      : super(key: key);
  final String title;
  final List<ApiArticlesModel> listOfArticles;
  final Color textColor;
  final double fontSize;
  final double cardHeight;
  final double cardWidth;
  final double imageRadius;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: 'Allerta Regular',
            color: textColor,
            fontSize: fontSize,
            letterSpacing: -0.065 * fontSize,
          ),
        ),
        SizedBox(height: 14),
        ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: listOfArticles.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  index != 0 ? SizedBox(height: 21) : Container(),
                  Row(
                    children: [
                      // index == 0 ? SizedBox(width: 22) : SizedBox(width: 7.5),
                      Container(
                        height: cardHeight,
                        child: Row(
                          children: [
                            ExtendedImage.network(
                              listOfArticles[index].coverImg,
                              cache: true,
                              fit: BoxFit.cover,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(imageRadius)),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              children: [
                                Text(
                            listOfArticles[index].title.length < 30
                            ? listOfArticles[index].title
                                : '${listOfArticles[index].title.substring(0, 30)}...',),
                                Text(
                                    '${listOfArticles[index].repliesCount} ${AppLocalizations.of(context).translate('comments')}'),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  index != listOfArticles.length - 1
                      ? SizedBox(height: 19)
                      : Container(),
                  index != listOfArticles.length - 1
                      ? Container(
                          height: 1, width: width, color: kArticlesDividerColor)
                      : Container(),
                ],
              );
            }),
      ],
    );
  }
}
