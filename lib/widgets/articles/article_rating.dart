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
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class ArticleRating extends StatelessWidget {
  ArticleRating({Key key, this.article, this.articleId}) : super(key: key);
  final ApiArticleModel article;
  final int articleId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SofyDivider(
          icon: Icons.star,
          size: 11.h,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 21.h),
          child: Column(
            children: [
              SizedBox(
                height: 40.h,
              ),
              Center(
                child: Text(
                  AppLocalizations.of(context).translate('do_you_like_this_article'),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: Fonts.RobotoBold,
                    height: 1.7,
                    color: SofyRateColors.Text,
                  ),
                ),
              ),
              SizedBox(
                height: 18.h,
              ),
              Center(
                child: Text(
                  AppLocalizations.of(context).translate('please_rate_this_article'),
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.normal, fontFamily: Fonts.HindGuntur, height: 1.7, color: SofyRateColors.Text),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 27.5.h,
              ),
              BlocBuilder<ArticleRatingBloc, ArticleRatingState>(builder: (context, state) {
                return Column(
                  children: [
                    Container(
                      height: 19.sp,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: 10,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                              onTap: () {
                                print(index);
                                if (!(state is ArticleRatingStatePostedRating || article.rating > 0)) BlocProvider.of<ArticleRatingBloc>(context).add(ArticleRatingEventSetRating(rating: index + 1));
                              },
                              child: Container(
                                child: state is ArticleRatingStateInit
                                    ? article.rating > index
                                        ? Container(height: 24.h, width: 24.h, child: Icon(Icons.star, size: 21.h, color: SofyLikeColors.SelectedStarColor))
                                        : Container(height: 24.h, width: 24.h, child: Icon(Icons.star_border_purple500_sharp, size: 21.h,color: SofyLikeColors.UnselectedStarColor))
                                    : state is ArticleRatingStateSettedRating || state is ArticleRatingStatePostedRating
                                        ? state.rating > index
                                            ? Container(height: 24.h, width: 24.h, child: Icon(Icons.star, size: 21.h, color: SofyLikeColors.SelectedStarColor))
                                            : Container(height: 24.h, width: 24.h, child: Icon(Icons.star_border_purple500_sharp, size: 21.h,color: SofyLikeColors.UnselectedStarColor))
                                        : Container(),
                              ));
                        },
                      ),
                    ),
                    SizedBox(
                      height: 35.h,
                    ),
                    state is ArticleRatingStateInit
                        ? article.rating < 0
                            ? BlocProvider.of<ArticleRatingBloc>(context).voting
                                ? Container(
                                    child: CircularProgressIndicator(
                                      color: kAppPinkDarkColor,
                                    ),
                                    height: 16.h,
                                    width: 16.h,
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
                                    height: 16.h,
                                    width: 16.h,
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
                    SizedBox(
                      height: 18.h,
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
