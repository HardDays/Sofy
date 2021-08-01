import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/size_config.dart';
import 'package:sofy_new/models/api_article_poll_model.dart';
import 'package:sofy_new/models/api_article_variants_model.dart';
import 'package:sofy_new/screens/bloc/analytics.dart';
import 'package:sofy_new/screens/bloc/article_vote_bloc.dart';
import 'package:sofy_new/widgets/articles/sofy_button.dart';
import 'package:sofy_new/widgets/articles/sofy_vote_button.dart';
import 'package:sofy_new/widgets/articles/sofy_vote_result.dart';
import 'package:sofy_new/widgets/articles/vote_divider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ArticleVote extends StatelessWidget {
  const ArticleVote({Key key, this.poll}) : super(key: key);
  final ApiArticlePollModel poll;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SofyDivider(icon: FontAwesomeIcons.check, size: 8.h), // scaled yet
        SizedBox(
          height: 40.h,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 21.w),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: 23.w,
                ),
                child: Text(
                  poll.blockName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: Fonts.RobotoBold,
                    color: SofyVoteColors.Text,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    height: 1.7,
                  ),
                ),
              ),
              BlocBuilder<ArticleVoteBloc, ArticleVoteState>(
                builder: (context, state) {
                  bool isResult = state is ArticleVoteStatePostedVote || (poll.variants.where((element) => !element.selected).length != poll.variants.length);
                  return Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(0),
                        itemCount: state.variants.length,
                        itemBuilder: (BuildContext context, int index) {
                          ApiArticleVariantsModel variant = state.variants[index];
                          // результаты
                          if ((isResult && state is ArticleVoteStateInit) || state is ArticleVoteStatePostedVote)
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: 16.h,
                              ),
                              child: SofyVoteResult(
                                variant: variant,
                              ),
                            );

                          // варианты
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 6.h,
                            ),
                            child: SofyVoteButton(
                                label: variant.content,
                                callback: () {
                                  Analytics().sendEventReports(event: EventsOfAnalytics.vote_variant_selected, attr: {
                                    "name": variant.content,
                                    'variant_id': variant.id,
                                    'pollId': variant.pollId,
                                  });
                                  BlocProvider.of<ArticleVoteBloc>(context).add(ArticleVoteEventSetVote(variantId: variant.id));
                                },
                                isBordered: variant.selected),
                          );
                        },
                      ),
                      SizedBox(
                        height: 16 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                      ),
                      isResult && state is ArticleVoteStateInit
                          ? Container()
                          : state is ArticleVoteStateSettedVote
                              ? Padding(
                                  padding: EdgeInsets.only(
                                    top: 14.h,
                                    bottom: 30.h,
                                  ),
                                  child: SofyButton(
                                      width: SizeConfig.screenWidth,
                                      label: poll.buttonName,
                                      callback: () {
                                        Analytics().sendEventReports(event: EventsOfAnalytics.reply_click, attr: {
                                          "name": poll.blockName,
                                          'variant_id': BlocProvider.of<ArticleVoteBloc>(context).selectedVariantsId,
                                          'pollId': poll.variants[0].id,
                                        });
                                        BlocProvider.of<ArticleVoteBloc>(context).add(ArticleVoteEventVote());
                                      }),
                                )
                              : Container(),
                      SizedBox(
                        height: 13.h,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
