import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/helper/size_config.dart';
import 'package:sofy_new/models/api_article_model.dart';
import 'package:sofy_new/models/api_article_question_model.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/rest_api.dart';
import 'package:sofy_new/screens/bloc/story_bloc.dart';
import 'package:sofy_new/screens/story_screen.dart';
import 'package:sofy_new/widgets/articles/sofy_button.dart';
import 'package:sofy_new/widgets/articles/vote_divider.dart';
import 'package:sofy_new/widgets/material_page_route.dart';

class ArticleQuestion extends StatelessWidget {
  const ArticleQuestion({Key key, this.question, this.articleId, this.article}) : super(key: key);
  final ApiArticleQuestionModel question;
  final int articleId;
  final ApiArticleModel article;

  @override
  Widget build(BuildContext context) {
    double height = SizeConfig.screenHeight;

    return Column(
      children: [
        SofyDivider(icon: Icons.help),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 21),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 23.0),
                child: Text(
                  question.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Stack(alignment: Alignment.topCenter, children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
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
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 40, 8, 8),
                            child: Text(
                              AppLocalizations.of(context).translate('share_answer'),
                              style: TextStyle(
                                color: SofyQuestionColors.Text,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Hind Guntur',
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Alert(
                              context: context,
                              type: AlertType.error,
                              title: "RFLUTTER ALERT",
                              desc: "Flutter is more awesome with RFlutter Alert.",
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    "COOL",
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  width: 120,
                                )
                              ],
                            ).show();
                            // Navigator.push(
                            //   context,
                            //   CustomMaterialPageRoute(
                            //     builder: (context) => ArticleAnswerScreen(
                            //       articleId: articleId.toString(),
                            //       articleTitle: articleTitle,
                            //       questionId: question.id,
                            //     ),
                            //   ),
                            // );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: SofyQuestionColors.FormBgColor,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            padding: const EdgeInsets.fromLTRB(21, 16, 21, 24),
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
                                  textCapitalization: TextCapitalization.characters,
                                  style: TextStyle(fontFamily: 'Hind Guntur', fontSize: height / 48.33, fontWeight: FontWeight.w600, color: SofyQuestionColors.Text),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: SofyQuestionColors.InputBgColor,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: SofyQuestionColors.InputBgColor),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: SofyQuestionColors.InputBgColor),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    disabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: SofyQuestionColors.InputBgColor),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    contentPadding: EdgeInsets.only(left: 16.0, bottom: 7.0),
                                    hintStyle: TextStyle(fontFamily: 'Hind Guntur', fontSize: height / 64, fontWeight: FontWeight.w600, color: SofyQuestionColors.Text),
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
                ExtendedImage.asset(
                  'assets/answer_title_image.png',
                  height: 80,
                  width: 80,
                ),
              ]),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: SofyButton(
                  label: AppLocalizations.of(context).translate('show_answers'),
                  callback: () {
                    // Analytics().sendEventReports(
                    //   event:
                    //   'articles_orgasms_categories_details_${13}_click'
                    //       .replaceAll(' ', '_'),
                    // );
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
