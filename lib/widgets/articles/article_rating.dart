import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/size_config.dart';
import 'package:sofy_new/models/api_article_model.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/rest_api.dart';
import 'package:sofy_new/screens/bloc/analytics.dart';
import 'package:sofy_new/screens/bloc/article_rating_bloc.dart';
import 'package:sofy_new/widgets/articles/sofy_info.dart';
import 'package:sofy_new/widgets/articles/sofy_text_button.dart';
import 'package:sofy_new/widgets/articles/vote_divider.dart';

// ignore: must_be_immutable
class ArticleRating extends StatelessWidget {
  ArticleRating({Key key, this.article, this.articleId}) : super(key: key);
  final ApiArticleModel article;
  final int articleId;

  @override
  Widget build(BuildContext context) {
    double width = SizeConfig.screenWidth;

    return Column(
      children: [
        SofyDivider(icon: Icons.done),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 21),
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
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      fontFamily: Fonts.HindGuntur,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              BlocProvider<ArticleRatingBloc>(
                create: (BuildContext context) =>
                    ArticleRatingBloc(restApi: RestApi(), articleId: articleId),
                child: BlocBuilder<ArticleRatingBloc, ArticleRatingState>(
                    builder: (context, state) {
                  return Column(
                    children: [
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
                              return InkWell(
                                onTap: () {
                                  print(index);
                                  if (!(state
                                          is ArticleRatingStatePostedRating ||
                                      article.rating > 0))
                                    BlocProvider.of<ArticleRatingBloc>(context)
                                        .add(ArticleRatingEventSetRating(
                                            rating: index + 1));
                                },
                                child: state is ArticleRatingStateInit
                                    ? article.rating > index
                                        ? Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: Icon(Icons.star,
                                                size: size < 24 ? size : 24,
                                                color: SofyLikeColors
                                                    .SelectedStarColor),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: Icon(Icons.star_border,
                                                size: size < 24 ? size : 24,
                                                color: SofyLikeColors
                                                    .UnselectedStarColor),
                                          )
                                    : state is ArticleRatingStateSettedRating ||
                                            state
                                                is ArticleRatingStatePostedRating
                                        ? state.rating > index
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: Icon(Icons.star,
                                                    size: size < 24 ? size : 24,
                                                    color: SofyLikeColors
                                                        .SelectedStarColor),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: Icon(Icons.star_border,
                                                    size: size < 24 ? size : 24,
                                                    color: SofyLikeColors
                                                        .UnselectedStarColor),
                                              )
                                        : Container(),
                              );
                            },
                          ),
                        ),
                      ),
                      state is ArticleRatingStateInit
                          ? article.rating < 0
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 41),
                                  child: SofyTextButton(
                                    callback: () {
                                      if (state
                                          is ArticleRatingStateSettedRating) {
                                        Analytics().sendEventReports(
                                          event: EventsOfAnalytics.reply_click,
                                          attr: {
                                            'id': articleId,
                                          },
                                        );
                                        BlocProvider.of<ArticleRatingBloc>(context).add(ArticleRatingEventPostRating(rating: state.rating));
                                      }
                                    },
                                    label: AppLocalizations.of(context)
                                        .translate('done'),
                                  ),
                                )
                              : SofyInfo(
                                  text: AppLocalizations.of(context)
                                      .translate('thank_you_for_your_answer'))
                          : state is ArticleRatingStateSettedRating
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 41),
                                  child: SofyTextButton(
                                    callback: () {
                                      print('like it');
                                      if (state
                                          is ArticleRatingStateSettedRating)
                                        BlocProvider.of<ArticleRatingBloc>(
                                                context)
                                            .add(ArticleRatingEventPostRating(
                                                rating: state.rating));
                                    },
                                    label: AppLocalizations.of(context)
                                        .translate('done'),
                                  ),
                                )
                              : state is ArticleRatingStatePostedRating ||
                                      article.rating < 0
                                  ? SofyInfo(
                                      text: AppLocalizations.of(context)
                                          .translate(
                                              'thank_you_for_your_answer'))
                                  : Container(),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
