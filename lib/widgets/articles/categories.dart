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

class Categories extends StatelessWidget {
  const Categories({
    Key key,
    this.title = '',
    this.listOfTopics,
    this.textColor = kArticlesHeaderTextColor,
    this.fontTitleSize = 24,
    this.lineHeight = 1,
    this.titListPadd = 14,
    this.callback,
  }) : super(key: key);
  final String title;
  final List<ApiArticleTopicModel> listOfTopics;
  final Color textColor;
  final double fontTitleSize;
  final double lineHeight;
  final double titListPadd;
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
                  fontFamily: SizeConfig.lang == 'en' ? Fonts.Allerta : Fonts.SFProMedium,
                  color: textColor,
                  fontSize: fontTitleSize,
                  fontWeight: FontWeight.normal,
                  letterSpacing: -0.065 * fontTitleSize,
                ),
              )
            : Container(),
        title != '' ? SizedBox(height: titListPadd) : Container(),
        ClipRRect(
          borderRadius: BorderRadius.circular(12 / Layout.width * Layout.multiplier * SizeConfig.blockSizeHorizontal),
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 2 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical),
                color: kArticlesPopCatBgColor,
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: listOfTopics.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Analytics().sendEventReports(
                            event: EventsOfAnalytics.show_articles_categories,
                            attr: {'name': listOfTopics[index].name},
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
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16 / Layout.width * Layout.multiplier * SizeConfig.blockSizeHorizontal,
                                vertical: 16 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            height: 28 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                            width: 28 / Layout.width * Layout.multiplier * SizeConfig.blockSizeHorizontal,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: kArticlePopCatIconBorderColor,
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius: BorderRadius.circular(5 / Layout.width * Layout.multiplier * SizeConfig.blockSizeHorizontal),
                                            ),
                                          ),
                                          Container(
                                            height: 27 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                            width: 27 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                            decoration: BoxDecoration(
                                              color: kArticlePopCatIconBorderColor[2],
                                              borderRadius: BorderRadius.circular(5 / Layout.width * Layout.multiplier * SizeConfig.blockSizeHorizontal),
                                            ),
                                          ),
                                          Container(
                                            height: 18 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                            width: 18 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                            child: ExtendedImage.network(listOfTopics[index].coverImg, cache: true),
                                            decoration: BoxDecoration(
                                              color: kArticlePopCatIconBgColor,
                                              borderRadius: BorderRadius.circular(5 / Layout.width * Layout.multiplier * SizeConfig.blockSizeHorizontal),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 16 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                        width: 16 / Layout.width * Layout.multiplier * SizeConfig.blockSizeHorizontal,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          top: 7 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                        ),
                                        width: 212 / Layout.width * Layout.multiplier * SizeConfig.blockSizeHorizontal,
                                        child: Text(
                                          listOfTopics[index].name,
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontFamily: SizeConfig.lang == 'en' ? Fonts.HindGuntur : Fonts.RalewayRegular,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                            color: ArticlesColors.TextColorCat,
                                            height: lineHeight,
                                          ),
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
                                          height: 12.73 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
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
                            ),
                            index != listOfTopics.length - 1 ? Container(height: 1, width: width * 0.7, color: ArticlesColors.Divider) : Container(),
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
