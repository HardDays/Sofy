import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/models/api_article_topic_model.dart';

class ArticlesCategoriesWithHeader extends StatelessWidget {
  const ArticlesCategoriesWithHeader({
    Key key,
    this.title,
    this.listOfTopics,
    this.textColor = kArticlesHeaderTextColor,
    this.fontTitleSize = 24,
    this.fontListSize = 14,
    this.cardHeight = 50,
    this.cardWidth = 50,
    this.imageRadius = 8,
    this.callback,
  }) : super(key: key);
  final String title;
  final List<ApiArticleTopicModel> listOfTopics;
  final Color textColor;
  final double fontTitleSize;
  final double fontListSize;
  final double cardHeight;
  final double cardWidth;
  final double imageRadius;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
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
            fontSize: fontTitleSize,
            letterSpacing: -0.065 * fontTitleSize,
          ),
        ),
        SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: Stack(
            children: [
              Container(
                color: kArticlesPopCatBgColor,
                padding: EdgeInsets.all(22),
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: listOfTopics.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          print(listOfTopics[index].id);

                          // Analytics().sendEventReports(
                          //   event: 'article_${listOfTopics[index].id}_click'
                          //       .replaceAll(' ', '_'),
                          // );
                          // Navigator.push(
                          //   context,
                          //   CustomMaterialPageRoute(
                          //       builder: (context) => ArticleDetailsScreen(
                          //           articleId: listOfTopics[index].id)),
                          // );
                        },
                        child: Column(
                          children: [
                            index != 0 ? SizedBox(height: 21) : Container(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Stack(
                                      alignment: AlignmentDirectional.center,
                                      children: [
                                        Container(
                                          height: 28,
                                          width: 28,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors:
                                                  kArticlePopCatIconBorderColor,
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        Container(
                                          height: 26,
                                          width: 26,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: ExtendedImage.network(
                                              listOfTopics[index].coverImg,
                                              cache: true,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            color: kArticlePopCatIconBgColor,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 16,
                                      height: cardHeight,
                                    ),
                                    Text(
                                      listOfTopics[index].name.length < 30
                                          ? listOfTopics[index].name
                                          : '${listOfTopics[index].name.substring(0, 30)}...',
                                      style: TextStyle(
                                          fontFamily: 'Hind Guntur',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: kArticlePopCatListTextColor),
                                    ),
                                  ],
                                ),
                                Container(
                                    child: Stack(
                                  children: <Widget>[
                                    Container(
                                      child: SvgPicture.asset(
                                        'assets/svg/arrow_next_vector.svg',
                                        color: textColor,
                                        height: fontTitleSize,
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                            focusColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(60),
                                            radius: fontTitleSize * 2,
                                            onTap: callback),
                                      ),
                                    ),
                                  ],
                                )),
                              ],
                            ),
                            index != listOfTopics.length - 1
                                ? SizedBox(height: 19)
                                : Container(),
                            index != listOfTopics.length - 1
                                ? Container(
                                    height: 1,
                                    width: width,
                                    color: kArticlesDividerColor)
                                : Container(),
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        )
      ],
    );
  }
}
