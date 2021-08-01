import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/size_config.dart';
import 'package:sofy_new/models/api_article_articles_model.dart';
import 'package:sofy_new/models/subscribe_data.dart';
import 'package:sofy_new/providers/PageProvider.dart';
import 'package:sofy_new/providers/preferences_provider.dart';
import 'package:sofy_new/screens/bloc/analytics.dart';
import 'package:sofy_new/screens/subscribe_screen.dart';
import 'package:sofy_new/widgets/articles/article_card.dart';
import 'package:sofy_new/widgets/articles/background.dart';
import 'package:sofy_new/widgets/fullscreen_preloader.dart';

import '../rest_api.dart';
import 'arcticle_details_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ArticlesCategoriesDetailsScreen extends StatefulWidget {
  final String screenTitle;
  final int categoryId;

  ArticlesCategoriesDetailsScreen({Key key, @required this.screenTitle, @required this.categoryId}) : super(key: key);

  @override
  _ArticlesCategoriesDetailsScreen createState() => _ArticlesCategoriesDetailsScreen();
}

class _ArticlesCategoriesDetailsScreen extends State<ArticlesCategoriesDetailsScreen> {
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

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    PCProvider pcProvider = Provider.of<PCProvider>(context, listen: false);

    return Material(
      child: Stack(
        children: [
          Background(),
          !isLoading
              ? Padding(
                  padding: EdgeInsets.only(top: height / 20.83),
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
                                    borderRadius: BorderRadius.circular(60.r),
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    radius: 25.r,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: 50.w,
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                                            child: Container(
                                              child: SvgPicture.asset(
                                                'assets/svg/back_vector.svg',
                                                color: kNavigBarInactiveColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(bottom: (height / 179.2).h),
                                          child: Text(
                                            widget.screenTitle,
                                            style: TextStyle(
                                                fontFamily: Fonts.Exo2,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24.sp, //24
                                                color: kNavigBarInactiveColor),
                                          ),
                                          width: SizeConfig.screenWidth * 0.75,
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                    }),
                              )),
                          Expanded(
                            child: GridView.count(
                              childAspectRatio: 170.w / 220.h,
                              physics: BouncingScrollPhysics(),
                              crossAxisCount: 2,
                              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                              crossAxisSpacing: 11.h,
                              mainAxisSpacing: 11.h,
                              children: List<Widget>.generate(
                                articlesList.length,
                                (index) {
                                  return ArticleCard(
                                    title: articlesList[index].title,
                                    path: articlesList[index].coverImg,
                                    textColor: kArticleCardTextColor,
                                    height: 220.h,
                                    radius: 25.r,
                                    width: 170.w,
                                    frozenHeight: 57.h + 11.h,
                                    fontSize: 14.sp,
                                    isPaid: articlesList[index].isPaid,
                                    lineHeight: 1.193,
                                    callback: () {
                                      bool isAppPurchase = Provider.of<SubscribeData>(context, listen: false).isAppPurchase;
                                      if (articlesList[index].isPaid == 1) {
                                        if (isAppPurchase) {
                                          Analytics().sendEventReports(event: EventsOfAnalytics.article_show, attr: {
                                            "name": articlesList[index].title,
                                          });
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) => ArticleDetailsScreen(
                                                articleId: articlesList[index].id,
                                              ),
                                            ),
                                          );
                                        } else {
                                          Analytics().sendEventReports(event: EventsOfAnalytics.splash_show, attr: {
                                            "name": articlesList[index].title,
                                            'source': 'onboarding/speed_change/modes_screen/settings_screen',
                                          });
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => SubscribeScreen(isFromSplash: false),
                                            ),
                                          );
                                        }
                                      } else {
                                        Analytics().sendEventReports(event: EventsOfAnalytics.article_show, attr: {
                                          "name": articlesList[index].title,
                                        });
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (BuildContext context) => ArticleDetailsScreen(
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
                )
              : FullscreenPreloader(),
        ],
      ),
    );
  }

  Future<void> getArticles() async {
    String userToken = await PreferencesProvider().getAnonToken();
    RestApi().getArticles(context, widget.categoryId, token: userToken).then((values) {
      setState(() {
        isLoading = false;
        articlesList = values;
      });
    });
  }
}

class FadeRoute<T> extends MaterialPageRoute<T> {
  FadeRoute({WidgetBuilder builder, RouteSettings settings}) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return new FadeTransition(opacity: animation, child: child);
  }
}
