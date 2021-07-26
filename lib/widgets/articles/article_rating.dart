import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        SofyDivider(icon: Icons.star, size: 11,),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 21 / Layout.width * Layout.multiplier * SizeConfig.blockSizeHorizontal),
          child: Column(
            children: [
              SizedBox(height: 40/ Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,),

              Center(
                child: Text(
                  AppLocalizations.of(context).translate('do_you_like_this_article'),
                  style: TextStyle(
                    fontSize: 20 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                    fontWeight: FontWeight.bold,
                    fontFamily: Fonts.RobotoBold,                      height: 1.7, color: SofyRateColors.Text

                  ),
                ),
              ),
              SizedBox(height: 18/ Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,),
              Center(
                child: Text(
                  AppLocalizations.of(context).translate('please_rate_this_article'),
                  style: TextStyle(
                    fontSize: 15 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                    fontWeight: FontWeight.normal,
                    fontFamily: Fonts.HindGuntur,
                    height: 1.7, color: SofyRateColors.Text
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 27.5/ Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,),
              BlocProvider<ArticleRatingBloc>(
                create: (BuildContext context) => ArticleRatingBloc(restApi: RestApi(), articleId: articleId),
                child: BlocBuilder<ArticleRatingBloc, ArticleRatingState>(builder: (context, state) {
                  return Column(
                    children: [
                      Container(
                        height: width / 10 < 24 ? width / 10 : 24,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(0.0),
                          itemCount: 10,
                          itemBuilder: (BuildContext context, int index) {
                            double size = width / 10;
                            return GestureDetector(
                                onTap: () {
                                  print(index);
                                  if (!(state is ArticleRatingStatePostedRating || article.rating > 0))
                                    BlocProvider.of<ArticleRatingBloc>(context).add(ArticleRatingEventSetRating(rating: index + 1));
                                },
                                child: Container(
                                  child: state is ArticleRatingStateInit
                                      ? article.rating > index
                                          ? Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 4),
                                              child: Icon(Icons.star, size: size < 24 ? size : 24, color: SofyLikeColors.SelectedStarColor),
                                            )
                                          : Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 4),
                                              child: Icon(Icons.star_border, size: size < 24 ? size : 24, color: SofyLikeColors.UnselectedStarColor),
                                            )
                                      : state is ArticleRatingStateSettedRating || state is ArticleRatingStatePostedRating
                                          ? state.rating > index
                                              ? Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 4),
                                                  child: Icon(Icons.star, size: size < 24 ? size : 24, color: SofyLikeColors.SelectedStarColor),
                                                )
                                              : Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 4),
                                                  child: Icon(Icons.star_border, size: size < 24 ? size : 24, color: SofyLikeColors.UnselectedStarColor),
                                                )
                                          : Container(),
                                ));
                          },
                        ),
                      ),
                      SizedBox(height: 35/ Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,),
                      state is ArticleRatingStateInit
                          ? article.rating < 0
                              ? BlocProvider.of<ArticleRatingBloc>(context).voting
                                  ? Container(
                                      child: CircularProgressIndicator(
                                        color: kAppPinkDarkColor,
                                      ),
                                      height: 16 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                      width: 16 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                    )
                                  : SofyTextButton(
                                      callback: () {
                                        if (state is ArticleRatingStateSettedRating) {
                                          Analytics().sendEventReports(
                                            event: EventsOfAnalytics.articles_feedback,
                                            attr: {
                                              'id': articleId,
                                              'name': article.title,
                                            },
                                          );
                                          BlocProvider.of<ArticleRatingBloc>(context).add(ArticleRatingEventPostRating(rating: state.rating));
                                        }
                                      },
                                      label: AppLocalizations.of(context).translate('done'),
                                    )
                              : SofyInfo(text: AppLocalizations.of(context).translate('thank_you_for_your_answer'))
                          : state is ArticleRatingStateSettedRating
                              ? BlocProvider.of<ArticleRatingBloc>(context).voting
                                  ? Container(
                                      child: CircularProgressIndicator(
                                        color: kAppPinkDarkColor,
                                      ),
                                      height: 16 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                      width: 16 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                    )
                                  : SofyTextButton(
                                      callback: () {
                                        if (state is ArticleRatingStateSettedRating) {
                                          Analytics().sendEventReports(
                                            event: EventsOfAnalytics.articles_feedback,
                                            attr: {
                                              'id': articleId,
                                              'name': article.title,
                                            },
                                          );
                                          BlocProvider.of<ArticleRatingBloc>(context).add(ArticleRatingEventPostRating(rating: state.rating));
                                        }
                                      },
                                      label: AppLocalizations.of(context).translate('done'),
                                    )
                              : state is ArticleRatingStatePostedRating || article.rating < 0
                                  ? SofyInfo(text: AppLocalizations.of(context).translate('thank_you_for_your_answer'))
                                  : Container(),
                      SizedBox(height: 18/ Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,),
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
