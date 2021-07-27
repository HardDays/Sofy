import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/size_config.dart';
import 'package:sofy_new/models/api_article_topic_model.dart';
import 'package:sofy_new/models/favortes/api_fav_topics_answer_model.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/providers/preferences_provider.dart';
import 'package:sofy_new/widgets/articles/articles_categories_with_header.dart';
import 'package:sofy_new/widgets/articles/background.dart';
import 'package:sofy_new/widgets/fullscreen_preloader.dart';

import '../rest_api.dart';

class ArticlesCategoriesScreen extends StatefulWidget {
  @override
  _ArticlesCategoriesScreen createState() => _ArticlesCategoriesScreen();
}

class _ArticlesCategoriesScreen extends State<ArticlesCategoriesScreen> {
  List<ApiArticleTopicModel> topicsList = [];
  List<ApiFavTopicsInfoModel> topicsList2 = [];
  @override
  void initState() {
    super.initState();
    /*Analytics().sendEventReports(
      event: settings_screen_show,
    );*/
    getArticleTopics();
  }

  @override
  Widget build(BuildContext context) {
    final height = SizeConfig.screenHeight;
    return Scaffold(
        backgroundColor: kMainScreenScaffoldBackColor,
        body: topicsList.length > 0 ? Padding(
            padding: EdgeInsets.only(left: 0.0, right: 0.0, top: height / 20.8/ Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical),
            child: Stack(
              children: [
                Background(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                        borderRadius: BorderRadius.circular(60),
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        radius: 25,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 50.0,
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Container(
                                  child: SvgPicture.asset(
                                    'assets/svg/back_vector.svg',
                                    color: kNavigBarInactiveColor,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: height / 179.2/ Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical),
                              alignment: Alignment.center,
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('all_categories'),
                                style: TextStyle(
                                    fontFamily: Fonts.Exo2,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24/ Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical, //24
                                    color: kNavigBarInactiveColor),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        }),
                    Padding(
                      padding: EdgeInsets.only(left: 21.0/ Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical, right: 21.0, top: height / 50.29/ Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical),
                      child: ArticlesCategoriesWithHeader(
                        listOfTopics: topicsList,
                      ),
                    ),
                  ],
                ),
              ],
            )) : FullscreenPreloader());
  }

  Future<void> getArticleTopics() async {
    String userToken = await PreferencesProvider().getAnonToken();
    RestApi().getTopicsList(context, token: userToken).then((values) {
      setState(() {
        topicsList = values;
      });
    });
  }
}

class FadeRoute<T> extends MaterialPageRoute<T> {
  FadeRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return new FadeTransition(opacity: animation, child: child);
  }
}
