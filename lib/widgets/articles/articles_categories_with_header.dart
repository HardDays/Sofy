import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/size_config.dart';
import 'package:sofy_new/models/api_article_topic_model.dart';
import 'package:sofy_new/screens/articles_categories_details_screen.dart';
import 'package:sofy_new/screens/bloc/analytics.dart';
import 'package:sofy_new/widgets/material_page_route.dart';

class ArticlesCategoriesWithHeader extends StatelessWidget {
  const ArticlesCategoriesWithHeader({
    Key key,
    this.title = '',
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
    double width = SizeConfig.screenWidth;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        title != ''
            ? Text(
                title,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: Fonts.Allerta,
                  color: textColor,
                  fontSize: fontTitleSize,
                  fontWeight: FontWeight.normal,
                  letterSpacing: -0.065,
                ),
              )
            : Container(),
        title != '' ? SizedBox(height: 14) : Container(),
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: Stack(
            children: [
              Container(
                color: kArticlesPopCatBgColor,
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: listOfTopics.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: EdgeInsets.fromLTRB(22, 11, 22, 0),
                        child: InkWell(
                          onTap: () {
                            Analytics().sendEventReports(
                              event: EventsOfAnalytics.show_articles_categories, attr: {'name': listOfTopics[index].name},
                            );
                            Navigator.push(
                              context,
                              CustomMaterialPageRoute(
                                  builder: (context) => ArticlesCategoriesDetailsScreen(
                                        categoryId: listOfTopics[index].id,
                                        screenTitle: listOfTopics[index].name,
                                      )),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
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
                                                colors: kArticlePopCatIconBorderColor,
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius: BorderRadius.circular(5),
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
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        width: 16,
                                        height: cardHeight,
                                      ),
                                      Text(
                                        listOfTopics[index].name.length < 30 ? listOfTopics[index].name : '${listOfTopics[index].name.substring(0, 30)}...',
                                        style: TextStyle(
                                          fontFamily: Fonts.HindGuntur,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: ArticlesColors.TextColorCat,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                      child: Stack(
                                    children: <Widget>[
                                      Container(
                                        child: SvgPicture.asset(
                                          'assets/svg/arrow_next_vector.svg',
                                          color: ArticlesColors.TextColorCat,
                                          height: fontTitleSize * 0.7,
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
                                              borderRadius: BorderRadius.circular(60),
                                              radius: fontTitleSize * 2,
                                              onTap: callback),
                                        ),
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                              index != listOfTopics.length - 1
                                  ? Container(height: 1, width: width * 0.7, color: ArticlesColors.Divider)
                                  : Container(
                                      height: 11,
                                    ),
                            ],
                          ),
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
