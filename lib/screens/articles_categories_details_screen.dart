import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/models/api_article_articles_model.dart';
import 'package:sofy_new/models/subscribe_data.dart';
import 'package:sofy_new/providers/PageProvider.dart';
import 'package:sofy_new/providers/preferences_provider.dart';
import 'package:sofy_new/screens/subscribe_screen.dart';
import 'package:sofy_new/widgets/articles/article_card.dart';
import 'package:sofy_new/widgets/playlist_lead_widget.dart';

import '../rest_api.dart';
import 'arcticle_details_screen.dart';

class ArticlesCategoriesDetailsScreen extends StatefulWidget {
  final String screenTitle;
  final int categoryId;

  ArticlesCategoriesDetailsScreen(
      {Key key, @required this.screenTitle, @required this.categoryId})
      : super(key: key);

  @override
  _ArticlesCategoriesDetailsScreen createState() =>
      _ArticlesCategoriesDetailsScreen();
}

class _ArticlesCategoriesDetailsScreen
    extends State<ArticlesCategoriesDetailsScreen> {
  List<ApiArticlesModel> articlesList = [];

  double width, height;

  @override
  void initState() {
    super.initState();
    /*Analytics().sendEventReports(
      event: settings_screen_show,
    );*/
    getArticles();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    PCProvider pcProvider = Provider.of<PCProvider>(context, listen: false);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: kLinearGradResultColor,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: height / 20.83),
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      width: width,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                            borderRadius: BorderRadius.circular(60),
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            radius: 25,
                            child: Row(
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
                                  padding:
                                      EdgeInsets.only(bottom: height / 179.2),
                                  alignment: Alignment.center,
                                  child: Text(
                                    widget.screenTitle,
                                    style: TextStyle(
                                        fontFamily: kFontFamilyExo2,
                                        fontWeight: FontWeight.bold,
                                        fontSize: height / 37.3, //24
                                        color: kNavigBarInactiveColor),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            }),
                      )),
                  Expanded(
                    child: GridView.count(
                      childAspectRatio: 0.85,
                      physics: BouncingScrollPhysics(),
                      crossAxisCount: 2,
                      padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: height / 44.8,
                          bottom: height / 44.8),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: List<Widget>.generate(
                        articlesList.length,
                        (index) {
                          return InkWell(
                            child: ArticleCard(
                                title: articlesList[index].title,
                                path: articlesList[index].coverImg,
                                width: height / 4.42,
                                height: height / 3.82,
                                frozenHeight: height / 3.82 * 0.25,
                                fontSize: 14,
                                textColor: kArticleCardTextColor,
                                radius: 25,
                                isPaid: articlesList[index].isPaid),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            onTap: () {
                              bool isAppPurchase = Provider.of<SubscribeData>(
                                      context,
                                      listen: false)
                                  .isAppPurchase;
                              if (articlesList[index].isPaid == 1) {
                                if (isAppPurchase) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ArticleDetailsScreen(
                                        articleId: articlesList[index].id,
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SubscribeScreen(isFromSplash: false),
                                    ),
                                  );
                                }
                              } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ArticleDetailsScreen(
                                      articleId: articlesList[index].id,
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getArticles() async {
    String userToken = await PreferencesProvider().getAnonToken();
    RestApi()
        .getArticles(context, widget.categoryId, token: userToken)
        .then((values) {
      setState(() {
        articlesList = values;
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
