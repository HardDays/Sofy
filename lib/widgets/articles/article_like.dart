import 'package:flutter/material.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/models/api_article_model.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/widgets/articles/vote_divider.dart';

class ArticleLike extends StatelessWidget {
  const ArticleLike({Key key, this.article}) : super(key: key);
  final ApiArticleModel article;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SofyDivider(icon: Icons.done),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 21),
          color: ArticleDetailsColors.BgColor,
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                  child: Text(
                    AppLocalizations.of(context)
                        .translate('do_you_like_this_article'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                  child: Text(
                    AppLocalizations.of(context)
                        .translate('please_rate_this_article'),
                    style: TextStyle(
                      color: SofyQuestionColors.Text,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Hind Guntur',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 25,bottom: 32),
                child: Container(
                  height: width / 10 < 24 ? width / 10 : 24,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(0.0),
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      double size = width / 10;
                      return Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(Icons.star_border, size: size < 24 ? size : 24, color:SofyLikeColors.StarColor),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
