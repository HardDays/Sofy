import 'package:flutter/material.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/models/api_article_articles_model.dart';
import 'package:sofy_new/screens/arcticle_details_screen.dart';
import 'package:sofy_new/screens/bloc/analytics.dart';
import 'package:sofy_new/widgets/articles/article_card.dart';
import 'package:sofy_new/widgets/articles/header_button.dart';
import 'package:sofy_new/widgets/material_page_route.dart';

class ArticlesCardsHeaderButton extends StatelessWidget {
  const ArticlesCardsHeaderButton(
      {Key key,
      this.listOfArticles,
      this.callback,
      this.title,
      this.cardHeight,
      this.cardRadius,
      this.cardWidth,
      this.frozenCardFontSize,
      this.frozenCardHeight,
      this.titleFontSize})
      : super(key: key);
  final List<ApiArticlesModel> listOfArticles;
  final double cardHeight;
  final double cardWidth;
  final double frozenCardHeight;
  final double frozenCardFontSize;
  final double cardRadius;

  final String title;
  final VoidCallback callback;
  final double titleFontSize;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
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
                    index == 0 ? SizedBox(width: 22) : SizedBox(width: 7.5),
                    InkWell(
                      child: ArticleCard(
                          title: listOfArticles[index].title,
                          path: listOfArticles[index].coverImg,
                          height: cardHeight,
                          width: cardWidth,
                          frozenHeight: frozenCardHeight,
                          fontSize: frozenCardFontSize,
                          textColor: kArticleCardTextColor,
                          radius: cardRadius),
                      onTap: () {
                        print(listOfArticles[index].id);

                        Analytics().sendEventReports(
                          event: 'article_${listOfArticles[index].id}_click'
                              .replaceAll(' ', '_'),
                        );
                        Navigator.push(
                          context,
                          CustomMaterialPageRoute(
                              builder: (context) => ArticleDetailsScreen(
                                  articleId: listOfArticles[index].id)),
                        );
                      },
                    ),
                    index == listOfArticles.length - 1
                        ? SizedBox(width: 22)
                        : SizedBox(width: 7.5),
                  ],
                );
              }),
        ),
      ],
    );
  }
}
