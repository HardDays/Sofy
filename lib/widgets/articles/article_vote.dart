import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/size_config.dart';
import 'package:sofy_new/models/api_article_poll_model.dart';
import 'package:sofy_new/models/api_article_variants_model.dart';
import 'package:sofy_new/rest_api.dart';
import 'package:sofy_new/screens/bloc/analytics.dart';
import 'package:sofy_new/screens/bloc/article_vote_bloc.dart';
import 'package:sofy_new/widgets/articles/sofy_button.dart';
import 'package:sofy_new/widgets/articles/sofy_vote_button.dart';
import 'package:sofy_new/widgets/articles/sofy_vote_result.dart';
import 'package:sofy_new/widgets/articles/vote_divider.dart';

class ArticleVote extends StatelessWidget {
  const ArticleVote({Key key, this.poll}) : super(key: key);
  final ApiArticlePollModel poll;

  @override
  Widget build(BuildContext context) {
    return poll.variants.length > 0
        ? Column(
            children: [
              SofyDivider(icon: FontAwesomeIcons.check, size: 8), // scaled yet
              SizedBox(
                height: 40 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 21 / Layout.width * Layout.multiplier * SizeConfig.blockSizeHorizontal),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 23.0 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                      ),
                      child: Text(
                        poll.blockName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: Fonts.RobotoBold,
                          color: SofyVoteColors.Text,
                          fontSize: 20 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                          fontWeight: FontWeight.bold,
                          height: 1.7,
                        ),
                      ),
                    ),
                    BlocProvider<ArticleVoteBloc>(
                      create: (BuildContext context) => ArticleVoteBloc(restApi: RestApi(), variants: poll.variants)..add(ArticleVoteEventInit()),
                      child: BlocBuilder<ArticleVoteBloc, ArticleVoteState>(
                        builder: (context, state) {
                          bool isResult = state is ArticleVoteStatePostedVote || (poll.variants.where((element) => !element.selected).length != poll.variants.length);
                          return Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: state.variants.length,
                                itemBuilder: (BuildContext context, int index) {
                                  ApiArticleVariantsModel variant = state.variants[index];
                                  // результаты
                                  if ((isResult && state is ArticleVoteStateInit) || state is ArticleVoteStatePostedVote)
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: 16.0 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                      ),
                                      child: SofyVoteResult(
                                        variant: variant,
                                      ),
                                    );

                                  // варианты
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 6 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
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
                                            top: 14 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                            bottom: 30 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                          ),
                                          child: SofyButton(
                                              label: poll.buttonName,
                                              height: 52 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
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
                                height: 13 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : Container();
  }
}
