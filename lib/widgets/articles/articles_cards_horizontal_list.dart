import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/size_config.dart';
import 'package:sofy_new/models/api_article_articles_model.dart';
import 'package:sofy_new/models/subscribe_data.dart';
import 'package:sofy_new/screens/arcticle_details_screen.dart';
import 'package:sofy_new/screens/bloc/analytics.dart';
import 'package:sofy_new/screens/subscribe_screen.dart';
import 'package:sofy_new/widgets/articles/article_card.dart';
import 'package:sofy_new/widgets/articles/header_button.dart';

class ArticlesCardsHorizontalList extends StatelessWidget {
  ArticlesCardsHorizontalList(
      {Key key, this.lineHeight = 1, this.frozenCardTextColor, this.listOfArticles, this.callback, this.title = '', this.cardHeight, this.cardRadius, this.cardWidth, this.frozenCardFontSize, this.frozenCardHeight, this.titleFontSize})
      : super(key: key);
  final List<ApiArticlesModel> listOfArticles;
  final double cardHeight;
  final double cardWidth;
  final double frozenCardHeight;
  final double frozenCardFontSize;
  final Color frozenCardTextColor;
  final double lineHeight;
  final double cardRadius;
  final String title;
  final VoidCallback callback;
  final double titleFontSize;

  @override
  Widget build(BuildContext context) {
    double width = SizeConfig.screenWidth;
    return Column(
      children: [
        title == ''
            ? Container()
            : Container(
          height: 64,
          width: width,
          padding: EdgeInsets.fromLTRB(22, 16, 22, 16),
          child: HeaderButton(
            text: title,
            callback: callback,
            fontSize: titleFontSize,
            textColor: kArticlesHeaderTextColor,
          ),
        ),
        Container(
          height: cardHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: listOfArticles.length,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: [
                  index == 0 ? SizedBox(width: 22 / Layout.width * Layout.multiplier * SizeConfig.blockSizeHorizontal) : SizedBox(width: 7.5 / Layout.width * Layout.multiplier * SizeConfig.blockSizeHorizontal),
                  ArticleCard(
                    title: listOfArticles[index].title,
                    path: listOfArticles[index].coverImg,
                    height: cardHeight,
                    width: cardWidth,
                    frozenHeight: frozenCardHeight,
                    fontSize: frozenCardFontSize,
                    textColor: frozenCardTextColor,
                    radius: cardRadius,
                    isPaid: listOfArticles[index].isPaid,
              lineHeight:lineHeight,
                    callback: () async {
                      bool isAppPurchase = Provider.of<SubscribeData>(context, listen: false).isAppPurchase;
                      if (listOfArticles[index].isPaid == 1) {
                        if (isAppPurchase) {
                          Analytics().sendEventReports(event: EventsOfAnalytics.article_show, attr: {
                            "name": listOfArticles[index].title,
                            'id': listOfArticles[index].id
                          });
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => ArticleDetailsScreen(
                                articleId: listOfArticles[index].id,
                              ),
                            ),
                          );
                        } else {
                          Analytics().sendEventReports(event: EventsOfAnalytics.splash_show, attr: {
                            "name": listOfArticles[index].title,
                            'id': listOfArticles[index].id,
                            'source': 'onboarding/speed_change/modes_screen/settings_screen',
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubscribeScreen(isFromSplash: false),
                            ),
                          );
                        }
                      } else {
                        Analytics().sendEventReports(event: EventsOfAnalytics.article_show, attr: {
                          "name": listOfArticles[index].title,
                          'id': listOfArticles[index].id,
                        });
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => ArticleDetailsScreen(
                              articleId: listOfArticles[index].id,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  index == listOfArticles.length - 1 ? SizedBox(width: 22) : SizedBox(width: 7.5),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}