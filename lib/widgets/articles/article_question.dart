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
import 'package:sofy_new/screens/bloc/analytics.dart';
import 'package:sofy_new/screens/bloc/story_bloc.dart';
import 'package:sofy_new/screens/story_screen.dart';
import 'package:sofy_new/widgets/articles/sofy_button.dart';
import 'package:sofy_new/widgets/articles/vote_divider.dart';
import 'package:sofy_new/widgets/material_page_route.dart';
import 'package:sofy_new/widgets/story/story_input_card.dart';

class ArticleQuestion extends StatelessWidget {
  ArticleQuestion({Key key, this.question, this.articleId, this.article}) : super(key: key);
  final ApiArticleQuestionModel question;
  final int articleId;
  final ApiArticleModel article;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SofyDivider(icon: FontAwesomeIcons.question),
        SizedBox(
          height: 40 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
        ),
        Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 21 / Layout.width * Layout.multiplier * SizeConfig.blockSizeHorizontal,
              ), child: Text(
              question.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: SofyQuestionColors.Text,
                  fontFamily: Fonts.RobotoBold,
                  fontSize: 20 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                  fontWeight: FontWeight.bold,
                  height: 1.7),
            ),),
            SizedBox(
              height: 15 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
            ),
            StoryInputCard(question: question, article: article, articleId: articleId, enabled: false),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 21 / Layout.width * Layout.multiplier * SizeConfig.blockSizeHorizontal,
            vertical: 30 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
          ),
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
                  builder: (context) =>
                      BlocProvider(
                        create: (_) =>
                            StoryBloc(restApi: RestApi(systemLang: AppLocalizations
                                .of(context)
                                .locale
                                .languageCode), articleId: articleId),
                        child: StoryScreen(article: article),
                      ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
