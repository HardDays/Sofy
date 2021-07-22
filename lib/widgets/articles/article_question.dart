import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/size_config.dart';
import 'package:sofy_new/models/api_article_model.dart';
import 'package:sofy_new/models/api_article_question_model.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/rest_api.dart';
import 'package:sofy_new/screens/article_answer_screen.dart';
import 'package:sofy_new/screens/bloc/analytics.dart';
import 'package:sofy_new/screens/bloc/story_bloc.dart';
import 'package:sofy_new/screens/story_screen.dart';
import 'package:sofy_new/widgets/articles/sofy_button.dart';
import 'package:sofy_new/widgets/articles/vote_divider.dart';
import 'package:sofy_new/widgets/material_page_route.dart';

class ArticleQuestion extends StatelessWidget {
  ArticleQuestion({Key key, this.question, this.articleId, this.article}) : super(key: key);
  final ApiArticleQuestionModel question;
  final int articleId;
  final ApiArticleModel article;

  @override
  Widget build(BuildContext context) {
    double height = SizeConfig.screenHeight;

    return Column(
      children: [
        SofyDivider(icon: FontAwesomeIcons.question),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 21 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 23.0 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical),
                child: Text(
                  question.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: SofyQuestionColors.Text,
                    fontFamily: Fonts.Roboto,
                    fontSize: 20 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Stack(alignment: Alignment.topCenter, children: [
                Padding(
                  padding: EdgeInsets.only(top: 40 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical),
                  child: Container(
                    decoration: BoxDecoration(
                      color: SofyQuestionColors.FormBgColor,
                      boxShadow: [
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
                        Center(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(8 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical, 40 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                8 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical, 8 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical),
                            child: Text(
                              AppLocalizations.of(context).translate('share_answer'),
                              style: TextStyle(
                                color: SofyQuestionColors.QText,
                                fontSize: 16 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                fontWeight: FontWeight.bold,
                                fontFamily: Fonts.HindGuntur,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (_, __, ___) => ArticleAnswerScreen(articleId: articleId.toString(), articleTitle: article.title, questionId: question.id),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: SofyQuestionColors.FormBgColor,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            padding: EdgeInsets.fromLTRB(21 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical, 16 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                21 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical, 24 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: SofyQuestionColors.InputShadowColor,
                                    offset: Offset(4, 4),
                                    blurRadius: 10,
                                  ),
                                  BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(-4, -4),
                                    blurRadius: 10.0,
                                  ),
                                ],
                              ),
                              child: TextField(
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontFamily: Fonts.HindGuntur, fontSize: height / 48.33, fontWeight: FontWeight.w600, color: SofyQuestionColors.Text),
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
                                        fontSize: height / 64 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                        fontWeight: FontWeight.w600,
                                        color: SofyQuestionColors.InputHintColor),
                                    hintText: AppLocalizations.of(context).translate('answer_hint'),
                                  ),
                                  enabled: false),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: SizeConfig.screenWidth / 5 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                  height: SizeConfig.screenWidth / 5 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(color: Color.fromRGBO(255, 255, 255, 0.25), offset: Offset(-4, -4), blurRadius: 10),
                    BoxShadow(color: Color.fromRGBO(219, 196, 219, 0.25), offset: Offset(4, 4), blurRadius: 10)
                  ], borderRadius: BorderRadius.all(Radius.circular(100))),
                  child: Image.asset('assets/answer_title_image.png'),
                ),
              ]),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical),
                child: SofyButton(
                  label: AppLocalizations.of(context).translate('show_answers'),
                  callback: () {
                    Analytics().sendEventReports(
                      event: EventsOfAnalytics.go_to_stories_click,
                      attr: {'id': articleId, 'name': article.title},
                    );
                    Navigator.push(
                      context,
                      CustomMaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (_) => StoryBloc(restApi: RestApi(systemLang: AppLocalizations.of(context).locale.languageCode), articleId: articleId),
                          child: StoryScreen(article: article),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
