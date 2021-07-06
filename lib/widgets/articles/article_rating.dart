import 'package:flutter/material.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/models/api_article_model.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/screens/bloc/setting_bloc.dart';
import 'package:sofy_new/widgets/articles/sofy_badge.dart';
import 'package:sofy_new/widgets/articles/sofy_info.dart';
import 'package:sofy_new/widgets/articles/sofy_text_button.dart';
import 'package:sofy_new/widgets/articles/vote_divider.dart';

class ArticleRating extends StatelessWidget {
  ArticleRating({Key key, this.article}) : super(key: key);
  final ApiArticleModel article;
  SettingBloc _settingBloc = SettingBloc();

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
                padding: EdgeInsets.only(top: 25),
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
                        child: Icon(Icons.star_border,
                            size: size < 24 ? size : 24,
                            color: SofyLikeColors.StarColor),
                      );
                    },
                  ),
                ),
              ),
              /*
  "no_answers" : "Sorry, everyone is silent :(",
               */
              article.rating < 0
                  ? Padding(
                      padding: const EdgeInsets.only(top: 41),
                      child: SofyTextButton(
                        callback: () {
                          print('like it');
                        },
                        label: AppLocalizations.of(context).translate('done'),
                      ),
                    )
                  : SofyInfo(
                      text: AppLocalizations.of(context)
                          .translate('thank_you_for_your_answer')),
              Padding(
                padding: const EdgeInsets.only(top: 56),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SofyBadge(
                      text: article.likesCount,
                      path: 'assets/svg/article_likes.svg',
                    ),
                    SofyBadge(
                      text: article.repliesCount,
                      path: 'assets/svg/article_comments.svg',
                    ),
                    InkWell(
                      child: SofyBadge(path: 'assets/svg/article_share.svg'),
                      onTap: () {
                        _settingBloc.shareArticle(article.title,
                            context: context);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
