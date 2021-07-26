import 'package:flutter/material.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/size_config.dart';
import 'package:sofy_new/models/api_article_model.dart';
import 'package:sofy_new/models/api_article_question_model.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/screens/article_answer_screen.dart';
import 'package:sofy_new/screens/bloc/analytics.dart';

class StoryInputCard extends StatelessWidget {
  const StoryInputCard({
    Key key,
    @required this.question,
    @required this.article,
    @required this.articleId,
    this.enabled = true,
  }) : super(key: key);

  final ApiArticleQuestionModel question;
  final ApiArticleModel article;
  final int articleId;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 21 / Layout.width * Layout.multiplier * SizeConfig.blockSizeHorizontal),
      child: Stack(alignment: Alignment.topCenter, children: [
        Padding(
          padding: EdgeInsets.only(top: 24 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical),
          child: Container(
            decoration: BoxDecoration(
              color: SofyQuestionColors.FormBgColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.white70,
                  offset: Offset(-5, -5),
                  blurRadius: 15.0,
                ),
                BoxShadow(
                  color: SofyQuestionColors.FormShadowColor,
                  offset: Offset(5, 5),
                  blurRadius: 15.0,
                ),
              ],
              borderRadius: BorderRadius.circular(9 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB((46 - 21) / Layout.width * Layout.multiplier * SizeConfig.blockSizeHorizontal,
                      40 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical, 8 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical, 0
                    // 8 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                  ),
                  child: Text(
                    AppLocalizations.of(context).translate('share_answer'),
                    style: TextStyle(
                        color: SofyQuestionColors.QText,
                        fontSize: 16 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        fontFamily: Fonts.HindGunturBold,
                        height: 1.5),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (_, __, ___) {
                          Analytics().sendEventReports(
                            event: EventsOfAnalytics.show_answer_story_screen,
                            attr: {"name": article.title, 'id': articleId, 'questionId': question.id},
                          );
                          return ArticleAnswerScreen(articleId: articleId.toString(), articleTitle: article.title, questionId: question.id);
                        },
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: SofyQuestionColors.FormBgColor,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    padding: EdgeInsets.fromLTRB(
                      21 / Layout.width * Layout.multiplier * SizeConfig.blockSizeHorizontal,
                      16 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                      21 / Layout.width * Layout.multiplier * SizeConfig.blockSizeHorizontal,
                      24 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                    ),
                    child: Container(
                      /*
                      background: #F9D9F4;
box-shadow: -4px -4px 10px rgba(255, 255, 255, 0.6), 4px 4px 10px #ECD1E8;
                       */
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.6),
                            offset: Offset(-4, -4),
                            blurRadius: 10,
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(236, 209, 232, 1),
                            offset: Offset(4, 4),
                            blurRadius: 10.0,
                          ),
                        ],
                      ),
                      child: TextField(
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: Fonts.HindGuntur,
                              fontSize: 14 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                              fontWeight: FontWeight.w600,
                              color: SofyQuestionColors.Text,
                              height: 1),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: SofyQuestionColors.InputBgColor,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: SofyQuestionColors.InputBgColor),
                              borderRadius: BorderRadius.circular(10 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: SofyQuestionColors.InputBgColor),
                              borderRadius: BorderRadius.circular(10 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical),
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: SofyQuestionColors.InputBgColor),
                              borderRadius: BorderRadius.circular(10 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical),
                            ),
                            contentPadding: EdgeInsets.only(left: 16.0 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical),
                            hintStyle: TextStyle(
                              fontFamily: Fonts.HindGuntur,
                              fontSize: 14 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                              fontWeight: FontWeight.w600,
                              color: SofyQuestionColors.InputHintColor,
                              height: 1,
                            ),
                            hintText: AppLocalizations.of(context).translate('answer_hint'),
                          ),
                          enabled: enabled),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Stack(
          children: [
            Container(
              width: 48 / Layout.width * Layout.multiplier * SizeConfig.blockSizeHorizontal,
              height: 48 / Layout.width * Layout.multiplier * SizeConfig.blockSizeHorizontal,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(color: Color.fromRGBO(255, 255, 255, 0.6), offset: Offset(-4, -4), blurRadius: 10),
                BoxShadow(color: Color.fromRGBO(219, 196, 219, 0.41), offset: Offset(4, 4), blurRadius: 10)
              ], borderRadius: BorderRadius.all(Radius.circular(1000)), color: Color.fromRGBO(252, 239, 252, 1)),
            ),
            Container(
              width: 48 / Layout.width * Layout.multiplier * SizeConfig.blockSizeHorizontal,
              height: 48 / Layout.width * Layout.multiplier * SizeConfig.blockSizeHorizontal,
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(1000))),
              child: Image.asset('assets/answer_title_image_cut.png'),
            ),
          ],
        ),
      ]),
    );
  }
}
