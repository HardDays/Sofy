import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/models/api_article_topic_model.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/providers/preferences_provider.dart';
import 'package:sofy_new/screens/bloc/analytics.dart';
import 'package:sofy_new/screens/subscribe_screen.dart';
import 'package:sofy_new/widgets/progress_indicator.dart';

import '../rest_api.dart';
import 'bloc/local_notification_service.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  double height = 0;
  double width = 0;
  int slidePage = 0;
  int liquidDuration = 650;
  bool press1 = false,
      press2 = false,
      press3 = false,
      press4 = false,
      press4_1 = false,
      press5_1 = false,
      press5 = false,
      press6 = false,
      press7 = false;
  double percent = 0.0;

  //LiquidController liquidController;
  PageController pageController = PageController(
    initialPage: 0,
  );

  int swipeIndex = 0;
  bool isCatChoose = false;

  List<ApiArticleTopicModel> topicsList = new List<ApiArticleTopicModel>();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    //liquidController = LiquidController();
    //getDataFromServer();
    getArticleTopics();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(new AssetImage('assets/on_boarding1_1.png'), context);
    precacheImage(new AssetImage('assets/on_boarding1_center.png'), context);
    precacheImage(new AssetImage('assets/on_boarding2_center.png'), context);
    precacheImage(new AssetImage('assets/on_boarding3_center.png'), context);
    precacheImage(new AssetImage('assets/on_boarding4_center.png'), context);
    precacheImage(new AssetImage('assets/on_boarding5_center.png'), context);
    precacheImage(new AssetImage('assets/on_boarding6_poitns.png'), context);
    precacheImage(new AssetImage('assets/on_boarding6_top_left.png'), context);
    precacheImage(new AssetImage('assets/on_boarding6_center.png'), context);
    //cache artcle icon
    precacheImage(
        new Image.network(
                'https://space.sofyapp.info/topics_icons/interesting_2.png')
            .image,
        context);
    precacheImage(
        new Image.network(
                'https://space.sofyapp.info/topics_icons/orgasm_2.png')
            .image,
        context);
    precacheImage(
        new Image.network('https://space.sofyapp.info/topics_icons/bdsm_2.png')
            .image,
        context);
    precacheImage(
        new Image.network('https://space.sofyapp.info/topics_icons/man_2.png')
            .image,
        context);
    precacheImage(
        new Image.network(
                'https://space.sofyapp.info/topics_icons/blowjob_2.png')
            .image,
        context);
    precacheImage(
        new Image.network(
                'https://space.sofyapp.info/topics_icons/problems_2.png')
            .image,
        context);
    precacheImage(
        new Image.network(
                'https://space.sofyapp.info/topics_icons/positions_2.png')
            .image,
        context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Builder(
        builder: (context) => Stack(
          children: [
            /*LiquidSwipe(
              pages: getPages(),
              enableLoop: false,
              fullTransitionValue: 600,
              positionSlideIcon: 0.5,
              liquidController: liquidController,
              waveType: WaveType.liquidReveal,
              enableSlideIcon: false,
              onPageChangeCallback: (index) {
                slidePage = index;
                checkSwiperIndex(index: index);
              },
              currentUpdateTypeCallback: (index) {
                print('currentUpdateTypeCallback');
              },
            ),*/
            PageView(
              controller: pageController,
              children: getPages(),
              onPageChanged: (index) {
                slidePage = index;
                checkSwiperIndex(index: index);
              },
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 14.93),
                child: Container(
                  margin: EdgeInsets.only(
                      right: MediaQuery.of(context).size.height / 48.43,
                      left: MediaQuery.of(context).size.height / 48.43),
                  child: Row(
                    children: [
                      indicatorContainer(0),
                      indicatorContainer(1),
                      indicatorContainer(2),
                      indicatorContainer(3),
                      indicatorContainer(4),
                      //indicatorContainer(5),
                    ],
                  ),
                )),
            Positioned(
                top: MediaQuery.of(context).size.height / 17.53,
                right: MediaQuery.of(context).size.height / 29.3,
                child: Container(
                    width: 15,
                    height: 15,
                    decoration: new BoxDecoration(
                      color: kArticlesWhiteColor,
                      shape: BoxShape.circle,
                    ))),
            Positioned(
                top: MediaQuery.of(context).size.height / 17.53,
                right: MediaQuery.of(context).size.height / 29.4,
                child: Container(
                  child: Image.asset('assets/star_white2.png',
                      height: 19,
                      width: 19,
                      color: //slidePage == 8
                          slidePage == 5
                              ? indicatorActiveColor
                              : kWelcomButtonDarkColor),
                ))
          ],
        ),
      ),
    );
  }

  Future<void> checkSwiperIndex({int index}) async {
    switch (index) {
      case 0:
        break;
      case 1:
        Analytics().sendEventReports(event: onbording_screen_1_show);
        break;
      case 2:
        Analytics().sendEventReports(event: onbording_screen_2_show);
        break;
      case 3:
        Analytics().sendEventReports(event: onbording_screen_3_show);
        break;
      case 4:
        //Analytics().sendEventReports(event: onbording_screen_4_show);
        await PreferencesProvider().saveFirstInit();
        Analytics().sendEventReports(event: onbording_screen_5_show);
        Future.delayed(Duration(seconds: 1), () {
          getFavoritesTopics();
          getNewArticles();
          getPopularArticle();
          getPopularTopics();
        });
        break;
      case 5:
        /*await PreferencesProvider().saveFirstInit();
        Analytics().sendEventReports(event: onbording_screen_5_show);
        Future.delayed(Duration(seconds: 1), () {
          getFavoritesTopics();
          getNewArticles();
          getPopularArticle();
          getPopularTopics();
        });*/
        break;
    }
  }

  String formatPropString(bool b1, bool b2, bool b3, List<String> s) {
    String result = '';
    if (b1) result = result + s[0];
    if (b2) result = result + ',' + s[1];
    if (b2) result = result + ',' + s[2];
    if (result.startsWith(',')) result = result.substring(1);
    return result;
  }

  List<Container> getPages() {
    return [
      //screen1_1,
      screen2,
      screen3,
      //screen4_1,
      screen5_1,
      //screen4,
      //screen5,
      screen6,
      subscribeScreen
    ];
  }

  Widget get subscribeScreen =>
      Container(child: SubscribeScreen(isFromSplash: true));

  Widget get screen1 => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffFDF3FF), Color(0xffF9EBF8), Color(0xffF9EAF7)],
              stops: [0.45, 0.89, 0.96]),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Image.asset('assets/on_boarding2_tol_left.png',
                  height: MediaQuery.of(context).size.height / 3.66),
            ),
            Positioned(
              right: 0,
              bottom: MediaQuery.of(context).size.height / 16.48,
              child: Image.asset('assets/on_boarding2_bottom_right.png',
                  height: MediaQuery.of(context).size.height / 7.47),
            ),
            Positioned(
              right: 0,
              top: MediaQuery.of(context).size.height / 12.1,
              child: Image.asset('assets/on_boarding2_points.png',
                  height: MediaQuery.of(context).size.height / 7.42),
            ),
            Container(
              width: width,
              height: height,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 9.53,
                  bottom: MediaQuery.of(context).size.height / 18.66),
              child: Column(
                children: [
                  Expanded(
                      child: Container(
                        child: Text(
                            AppLocalizations.of(context)
                                .translate('new_on_boarding_relax')
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: onBoardingTitleColor,
                                fontFamily: kFontFamilyExo2,
                                fontSize:
                                    MediaQuery.of(context).size.height / 24.88,
                                letterSpacing: 0.015)),
                      ),
                      flex: 0),
                  Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.height / 7.84),
                        child: Text(
                            AppLocalizations.of(context)
                                .translate('new_on_boarding_with_sofy'),
                            style: TextStyle(
                              color: onBoardingTitleColor,
                              fontFamily: 'Kalam',
                              fontSize: MediaQuery.of(context).size.height / 32,
                            )),
                      ),
                      flex: 0),
                  Expanded(child: Container()),
                  Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.height / 40.15,
                            right: MediaQuery.of(context).size.height / 40.15,
                            bottom: MediaQuery.of(context).size.height / 19.06),
                        child: Text(
                            AppLocalizations.of(context)
                                .translate('new_on_boarding_1'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: onBoardingSubTitleColor,
                              fontFamily: kFontFamilyGilroyBold,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              height: 1.3,
                              fontSize:
                                  MediaQuery.of(context).size.height / 38.4,
                            )),
                      ),
                      flex: 0),
                  Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xffFDB0C1), Color(0xffFF95AC)]),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x39FF98AD),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: Offset(2, 5),
                            ),
                          ],
                        ),
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.height / 42.66,
                            right: MediaQuery.of(context).size.height / 42.66),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.0),
                            onTap: () async {
                              setState(() {
                                press1 = true;
                              });
                              Future.delayed(Duration(seconds: 1), () {
                                setState(() {
                                  press1 = false;
                                });
                              });
                              pageController.animateToPage(1,
                                  duration: Duration(milliseconds: 350),
                                  curve: Curves.easeInOut);
                              /*liquidController.animateToPage(
                                  page: 1, duration: liquidDuration);*/
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: new Ink(
                              child: Container(
                                alignment: Alignment.center,
                                height:
                                    MediaQuery.of(context).size.height / 14.45,
                                child: Text(
                                    AppLocalizations.of(context)
                                        .translate('new_on_boarding_next')
                                        .toUpperCase(),
                                    style: TextStyle(
                                        color: press1
                                            ? kArticlesWhiteColor.withOpacity(0.7)
                                            : kArticlesWhiteColor,
                                        fontFamily: kFontFamilyGilroyBold,
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                49.78,
                                        letterSpacing: 0.01)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      flex: 0)
                ],
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height / 20.66),
                child: Image.asset('assets/on_boarding1_1.png',
                    height: MediaQuery.of(context).size.height / 3.34),
              ),
            )
          ],
        ),
      );

  Widget get screen1_1 => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: kAppPinkDarkColor,
        child: Stack(
          children: [
            //subscribeScreen,
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: kAppPinkDarkColor),
            Positioned(
              left: 0,
              top: 0,
              child: Image.asset('assets/on_boarding1_top_left.png',
                  height: MediaQuery.of(context).size.height / 2.89),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Image.asset('assets/on_boarding_cloud2.png',
                  height: MediaQuery.of(context).size.height / 4.58),
            ),
            Positioned(
              right: 0,
              top: MediaQuery.of(context).size.height / 4.87,
              child: Image.asset('assets/on_boarding_poitns.png',
                  height: MediaQuery.of(context).size.height / 5.64),
            ),
            Container(
              width: width,
              height: height,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 9.53,
                  bottom: MediaQuery.of(context).size.height / 18.66),
              child: Column(
                children: [
                  Expanded(
                      child: Container(
                        child: Text(
                            AppLocalizations.of(context)
                                .translate('new_on_boarding_relax')
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: kArticlesWhiteColor,
                                fontFamily: kFontFamilyExo2,
                                fontSize:
                                    MediaQuery.of(context).size.height / 24.88,
                                letterSpacing: 0.015)),
                      ),
                      flex: 0),
                  Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.height / 7.84),
                        child: Text(
                            AppLocalizations.of(context)
                                .translate('new_on_boarding_with_sofy'),
                            style: TextStyle(
                              color: kArticlesWhiteColor,
                              fontFamily: 'Kalam',
                              fontSize: MediaQuery.of(context).size.height / 32,
                            )),
                      ),
                      flex: 0),
                  Expanded(child: Container()),
                  Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.height / 40.15,
                            right: MediaQuery.of(context).size.height / 40.15,
                            bottom: MediaQuery.of(context).size.height / 19.06),
                        child: Text(
                            AppLocalizations.of(context)
                                .translate('new_on_boarding_1'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: kArticlesWhiteColor,
                              fontFamily: kFontFamilyGilroyBold,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              height: 1.3,
                              fontSize:
                                  MediaQuery.of(context).size.height / 38.4,
                            )),
                      ),
                      flex: 0),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xffFFE1E8), Color(0xffFFBECD)]),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(240, 127, 152, 0.2),
                            spreadRadius: 5,
                            blurRadius: 5,
                            offset: Offset(5, 5),
                          ),
                        ],
                      ),
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.height / 42.66,
                          right: MediaQuery.of(context).size.height / 42.66),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12.0),
                          onTap: () async {
                            setState(() {
                              press2 = true;
                            });
                            Future.delayed(Duration(seconds: 1), () {
                              setState(() {
                                press2 = false;
                              });
                            });
                            pageController.animateToPage(1,
                                duration: Duration(milliseconds: 350),
                                curve: Curves.easeInOut);
                            /*liquidController.animateToPage(
                                page: 1, duration: liquidDuration);*/
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: new Ink(
                            child: Container(
                              alignment: Alignment.center,
                              height:
                                  MediaQuery.of(context).size.height / 14.45,
                              child: Text(
                                  AppLocalizations.of(context)
                                      .translate('new_on_boarding_next')
                                      .toUpperCase(),
                                  style: TextStyle(
                                      color: press2
                                          ? kWelcomDarkTextColor
                                              .withOpacity(0.7)
                                          : kWelcomDarkTextColor,
                                      fontFamily: kFontFamilyGilroyBold,
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              49.78,
                                      letterSpacing: 0.01)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    flex: 0,
                  )
                ],
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height / 20.66),
                child: Image.asset('assets/on_boarding1_center.png',
                    height: MediaQuery.of(context).size.height / 3.34),
              ),
            )
          ],
        ),
      );

  Widget get screen2 => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffFDF3FF), Color(0xffF9EBF8), Color(0xffF9EAF7)],
              stops: [0.45, 0.89, 0.96]),
        ),
        // color: kMainScreenScaffoldBackColor,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Image.asset('assets/on_boarding2_tol_left.png',
                  height: MediaQuery.of(context).size.height / 3.66),
            ),
            Positioned(
              right: 0,
              bottom: MediaQuery.of(context).size.height / 16.48,
              child: Image.asset('assets/on_boarding2_bottom_right.png',
                  height: MediaQuery.of(context).size.height / 7.47),
            ),
            Positioned(
              right: 0,
              top: MediaQuery.of(context).size.height / 12.1,
              child: Image.asset('assets/on_boarding2_points.png',
                  height: MediaQuery.of(context).size.height / 7.42),
            ),
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 5.33),
              child: Image.asset('assets/on_boarding2_center.png',
                  height: MediaQuery.of(context).size.height),
            ),
            Container(
              width: width,
              height: height,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 9.53,
                  bottom: MediaQuery.of(context).size.height / 18.66),
              child: Column(
                children: [
                  Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Text('SOFY',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: TextStyle(
                                color: onBoardingTitleColor,
                                fontFamily: kFontFamilyExo2,
                                fontSize:
                                    MediaQuery.of(context).size.height / 22.88,
                                letterSpacing: 0.015)),
                      ),
                      flex: 0),
                  Expanded(child: Container()),
                  Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 26.35,
                            left: MediaQuery.of(context).size.height / 26.35,
                            right: MediaQuery.of(context).size.height / 26.35,
                            bottom: MediaQuery.of(context).size.height / 19.06),
                        child: Text(
                            AppLocalizations.of(context)
                                .translate('new_on_boarding_2'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: onBoardingSubTitleColor,
                              height: 1.3,
                              fontFamily: kFontFamilyGilroyBold,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              fontSize:
                                  MediaQuery.of(context).size.height / 38.4,
                            )),
                      ),
                      flex: 0),
                  Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xffFDB0C1), Color(0xffFF95AC)]),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x39FF98AD),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: Offset(2, 5),
                            ),
                          ],
                        ),
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.height / 42.66,
                            right: MediaQuery.of(context).size.height / 42.66),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.0),
                            onTap: () async {
                              setState(() {
                                press3 = true;
                              });
                              Future.delayed(Duration(seconds: 1), () {
                                setState(() {
                                  press3 = false;
                                });
                              });
                              pageController.animateToPage(1,
                                  duration: Duration(milliseconds: 350),
                                  curve: Curves.easeInOut);
                              /*liquidController.animateToPage(
                                  page: 1, duration: liquidDuration);*/
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: new Ink(
                              child: Container(
                                alignment: Alignment.center,
                                height:
                                    MediaQuery.of(context).size.height / 14.45,
                                child: Text(
                                    AppLocalizations.of(context)
                                        .translate('new_on_boarding_next')
                                        .toUpperCase(),
                                    style: TextStyle(
                                        color: press3
                                            ? kWelcomDarkTextColor
                                                .withOpacity(0.7)
                                            : kWelcomDarkTextColor,
                                        fontFamily: kFontFamilyGilroyBold,
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                49.78,
                                        letterSpacing: 0.01)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      flex: 0)
                ],
              ),
            ),
          ],
        ),
      );

  Widget get screen4_1 => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffFDF3FF), Color(0xffF9EBF8), Color(0xffF9EAF7)],
              stops: [0.45, 0.89, 0.96]),
        ),
        // color: kMainScreenScaffoldBackColor,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Image.asset('assets/on_boarding2_tol_left.png',
                  height: MediaQuery.of(context).size.height / 3.66),
            ),
            Positioned(
              right: 0,
              bottom: MediaQuery.of(context).size.height / 16.48,
              child: Image.asset('assets/on_boarding2_bottom_right.png',
                  height: MediaQuery.of(context).size.height / 7.47),
            ),
            Positioned(
              right: 0,
              top: MediaQuery.of(context).size.height / 12.1,
              child: Image.asset('assets/on_boarding2_points.png',
                  height: MediaQuery.of(context).size.height / 7.42),
            ),
            Container(
              alignment: Alignment.center,
              child: Column(children: [
                Padding(
                    padding: EdgeInsets.only(top: height / 5.4),
                    child: Row(children: [
                      Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.all(0.0),
                              itemCount: topicsList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      top: height / 74.66,
                                      left: 20.0,
                                      right: 20.0),
                                  child: InkWell(
                                    onTap: () {
                                      topicsList[index].selected =
                                          !topicsList[index].selected;

                                      isCatChoose = true;

                                      if (topicsList[index].selected) {
                                        sendDeleteFavTopic(true,
                                            topicsList[index].id.toString());
                                      } else {
                                        sendDeleteFavTopic(false,
                                            topicsList[index].id.toString());
                                      }
                                      setState(() {});
                                      //Analytics().sendEventReports(event: subscription_purchase_y_click);
                                    },
                                    child: Badge(
                                      padding: EdgeInsets.all(3),
                                      elevation: 0.0,
                                      shape: BadgeShape.square,
                                      borderRadius: BorderRadius.circular(6.0),
                                      child: Container(
                                        height: height / 13.17,
                                        padding: EdgeInsets.only(
                                            left: 20.0, right: 16.0),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: kSettingInActiveButtonColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(13.0)),
                                          border: Border.all(
                                            color: topicsList[index].selected
                                                ? kAppPinkDarkColor
                                                : Colors.transparent,
                                            width: 1.3,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Row(children: [
                                              Container(
                                                  height: height / 29.86,
                                                  width: height / 29.86,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        kSettingActiveButtonColor,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5.0)),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Image.network(
                                                      topicsList[index]
                                                          .coverImg,
                                                      color: kArticlesWhiteColor,
                                                      height: height / 49.77)),
                                              Container(
                                                  margin: EdgeInsets.only(
                                                      left: height / 52.7),
                                                  child: Text(
                                                    topicsList[index].name,
                                                    style: TextStyle(
                                                      color:
                                                          kWelcomDarkTextColor,
                                                      fontFamily: kFontFamilyGilroyBold,
                                                      fontSize: height / 56.0,
                                                      height: 1.343,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                  )),
                                            ]),
                                            CircleAvatar(
                                              radius: 8.0,
                                              backgroundColor:
                                                  topicsList[index].selected
                                                      ? kAppPinkDarkColor
                                                      : kArticlesWhiteColor,
                                              child: Icon(
                                                Icons.check,
                                                size: 12,
                                                color: kArticlesWhiteColor,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      showBadge: false,
                                    ),
                                  ),
                                );
                              },),)
                    ],),)
              ],),
            ),
            Container(
              width: width,
              height: height,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 9.53,
                  bottom: MediaQuery.of(context).size.height / 18.66),
              child: Column(
                children: [
                  Expanded(
                      child: Container(
                        child: Text(
                            AppLocalizations.of(context)
                                .translate('new_on_boarding_choose')
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: onBoardingTitleColor,
                                fontFamily: kFontFamilyExo2,
                                fontSize:
                                    MediaQuery.of(context).size.height / 26.35,
                                letterSpacing: 0.015)),
                      ),
                      flex: 0),
                  Expanded(
                      child: Container(
                        child: Text(
                            AppLocalizations.of(context)
                                .translate('new_on_boarding_choose_sub')
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: onBoardingTitleColor,
                                fontFamily: kFontFamilyExo2,
                                fontSize:
                                    MediaQuery.of(context).size.height / 47.15,
                                letterSpacing: 0.015)),
                      ),
                      flex: 0),
                  Expanded(child: Container()),
                  Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xffFDB0C1), Color(0xffFF95AC)]),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x39FF98AD),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: Offset(2, 5),
                            ),
                          ],
                        ),
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.height / 42.66,
                            right: MediaQuery.of(context).size.height / 42.66),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.0),
                            onTap: () async {
                              if (isCatChoose) {
                                setState(() {
                                  press4_1 = true;
                                });
                                Future.delayed(Duration(seconds: 1), () {
                                  setState(() {
                                    press4_1 = false;
                                  });
                                });
                                pageController.animateToPage(3,
                                    duration: Duration(milliseconds: 350),
                                    curve: Curves.easeInOut);
                                /*liquidController.animateToPage(
                                    page: 3, duration: liquidDuration);*/
                              }
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: new Ink(
                              child: Container(
                                alignment: Alignment.center,
                                height:
                                    MediaQuery.of(context).size.height / 14.45,
                                child: Text(
                                    AppLocalizations.of(context)
                                        .translate('new_on_boarding_next')
                                        .toUpperCase(),
                                    style: TextStyle(
                                        color: press4_1
                                            ? kWelcomDarkTextColor
                                                .withOpacity(0.7)
                                            : kWelcomDarkTextColor,
                                        fontFamily: kFontFamilyGilroyBold,
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                49.78,
                                        letterSpacing: 0.01)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      flex: 0)
                ],
              ),
            ),
          ],
        ),
      );

  BadgeAnimationType animationType = BadgeAnimationType.fade;
  Duration animationDuration = Duration(milliseconds: 350);
  bool showRaisedButtonBadge = false;
  String textLow = '✓ ';
  String textMedium = '✓ ';
  String textHigh = '✓ ';
  String textMin = '✓ ';
  String textAverage = '✓ ';
  String textMax = '✓ ';
  String textLong = '✓ ';
  String textFast = '✓ ';
  String textWithout = '✓ ';
  String textNotPause = '✓ ';
  String textPause = '✓ ';
  String textAccelerating = '✓ ';
  double badgeFontSize = 15;

  Widget get screen3 => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: kAppPinkDarkColor,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Image.asset('assets/on_boarding3_top_left.png',
                  height: MediaQuery.of(context).size.height / 4.86),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Image.asset('assets/on_boarding3_bottom_left.png',
                  height: MediaQuery.of(context).size.height / 6.04),
            ),
            Positioned(
              left: 0,
              top: MediaQuery.of(context).size.height / 6.44,
              child: Image.asset('assets/on_boarding3_poitns.png',
                  height: MediaQuery.of(context).size.height / 6.01),
            ),
            Positioned(
              right: 0,
              top: MediaQuery.of(context).size.height / 8.52,
              child: Image.asset('assets/on_boarding3_top_right.png',
                  height: MediaQuery.of(context).size.height / 6.6),
            ),
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 5.33),
              child: Image.asset('assets/on_boarding3_center.png',
                  height: MediaQuery.of(context).size.height),
            ),
            Container(
              width: width,
              height: height,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 9.53,
                  bottom: MediaQuery.of(context).size.height / 18.66),
              child: Column(
                children: [
                  Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                            AppLocalizations.of(context)
                                .translate('new_on_boarding_sex')
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: TextStyle(
                                color: kArticlesWhiteColor,
                                fontFamily: kFontFamilyExo2,
                                fontSize:
                                    MediaQuery.of(context).size.height / 24.88,
                                letterSpacing: 0.015)),
                      ),
                      flex: 0),
                  Expanded(
                      child: Container(
                        child: Text(
                            AppLocalizations.of(context)
                                .translate('new_on_boarding_about_sex')
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: kArticlesWhiteColor,
                                fontFamily: kFontFamilyExo2,
                                fontSize:
                                MediaQuery.of(context).size.height / 36.35,
                                letterSpacing: 0.015)),
                      ),
                      flex: 0),
                  Expanded(child: Container()),
                  Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 26.35,
                            left: MediaQuery.of(context).size.height / 26.35,
                            right: MediaQuery.of(context).size.height / 26.35,
                            bottom: MediaQuery.of(context).size.height / 19.06),
                        child: Text(
                            AppLocalizations.of(context)
                                .translate('new_on_boarding_3'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: kArticlesWhiteColor,
                              height: 1.3,
                              fontFamily: kFontFamilyGilroyBold,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              fontSize:
                                  MediaQuery.of(context).size.height / 38.4,
                            )),
                      ),
                      flex: 0),
                  Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xffFFE1E8), Color(0xffFFBECD)]),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(240, 127, 152, 0.2),
                              spreadRadius: 5,
                              blurRadius: 5,
                              offset: Offset(5, 5),
                            ),
                          ],
                        ),
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.height / 42.66,
                            right: MediaQuery.of(context).size.height / 42.66),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.0),
                            onTap: () async {
                              setState(() {
                                press4 = true;
                              });
                              Future.delayed(Duration(seconds: 1), () {
                                setState(() {
                                  press4 = false;
                                });
                              });
                              pageController.animateToPage(2,
                                  duration: Duration(milliseconds: 350),
                                  curve: Curves.easeInOut);
                              /*liquidController.animateToPage(
                                  page: 2, duration: liquidDuration);*/
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: new Ink(
                              child: Container(
                                alignment: Alignment.center,
                                height:
                                    MediaQuery.of(context).size.height / 14.45,
                                child: Text(
                                    AppLocalizations.of(context)
                                        .translate('new_on_boarding_next')
                                        .toUpperCase(),
                                    style: TextStyle(
                                        color: press4
                                            ? kWelcomDarkTextColor
                                                .withOpacity(0.7)
                                            : kWelcomDarkTextColor,
                                        fontFamily: kFontFamilyGilroyBold,
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                49.78,
                                        letterSpacing: 0.01)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      flex: 0)
                ],
              ),
            ),
          ],
        ),
      );

  Widget get screen5_1 => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
    decoration: BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xffFDF3FF), Color(0xffF9EBF8), Color(0xffF9EAF7)],
          stops: [0.45, 0.89, 0.96]),
    ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Image.asset('assets/on_boarding3_top_left.png',
                  height: MediaQuery.of(context).size.height / 4.86),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Image.asset('assets/on_boarding3_bottom_left.png',
                  height: MediaQuery.of(context).size.height / 6.04),
            ),
            Positioned(
              left: 0,
              top: MediaQuery.of(context).size.height / 6.44,
              child: Image.asset('assets/on_boarding3_poitns.png',
                  height: MediaQuery.of(context).size.height / 6.01),
            ),
            Positioned(
              right: 0,
              top: MediaQuery.of(context).size.height / 8.52,
              child: Image.asset('assets/on_boarding3_top_right.png',
                  height: MediaQuery.of(context).size.height / 6.6),
            ),
            Positioned(
              right: 0,
              top: MediaQuery.of(context).size.height / 1.74,
              child: Transform.rotate(
                  angle: 60,
                  child: Image.asset('assets/on_boarding3_poitns.png',
                      height: MediaQuery.of(context).size.height / 6.01)),
            ),
            /*Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery
                          .of(context)
                          .size
                          .height / 38.95,
                      right: MediaQuery
                          .of(context)
                          .size
                          .height / 38.95),
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 24.88,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0x30FDE6EF)),
                )),*/
            Container(
              alignment: Alignment.center,
              child: timePicker(),
            ),
            Container(
              width: width,
              height: height,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 9.53,
                  bottom: MediaQuery.of(context).size.height / 18.66),
              child: Column(
                children: [
                  Expanded(
                      child: Container(
                        child: Text(
                            AppLocalizations.of(context)
                                .translate('new_on_boarding_reminder')
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: onBoardingTitleColor,
                                fontFamily: kFontFamilyExo2,
                                fontSize:
                                    MediaQuery.of(context).size.height / 24.88,
                                letterSpacing: 0.015)),
                      ),
                      flex: 0),
                  Expanded(
                      child: Container(
                        child: Text(
                            AppLocalizations.of(context)
                                .translate('new_on_boarding_reminder_sub')
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: onBoardingTitleColor,
                                fontFamily: kFontFamilyExo2,
                                fontSize:
                                    MediaQuery.of(context).size.height / 36.35,
                                letterSpacing: 0.015)),
                      ),
                      flex: 0),
                  Expanded(child: Container()),
                  Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 26.35,
                            left: MediaQuery.of(context).size.height / 26.35,
                            right: MediaQuery.of(context).size.height / 26.35,
                            bottom: MediaQuery.of(context).size.height / 19.06),
                        child: Text(
                            AppLocalizations.of(context)
                                .translate('new_on_boarding_6'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: onBoardingSubTitleColor,
                              height: 1.3,
                              fontFamily: kFontFamilyGilroyBold,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              fontSize:
                                  MediaQuery.of(context).size.height / 38.4,
                            )),
                      ),
                      flex: 0),
                  Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xffFDB0C1), Color(0xffFF95AC)]),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x39FF98AD),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: Offset(2, 5),
                            ),
                          ],
                        ),
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.height / 42.66,
                            right: MediaQuery.of(context).size.height / 42.66),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.0),
                            onTap: () async {
                              setState(() {
                                press5 = true;
                              });
                              Future.delayed(Duration(seconds: 1), () {
                                setState(() {
                                  press5 = false;
                                });
                              });
                              /*liquidController.animateToPage(
                                  page: 6, duration: liquidDuration);*/
                              LocalNotificationService.instance
                                  .permission()
                                  .then((value) {
                                Future.delayed(Duration(seconds: 1), () {
                                  pageController.animateToPage(3,
                                      duration: Duration(milliseconds: 350),
                                      curve: Curves.easeInOut);
                                  /*liquidController.animateToPage(
                                      page: 3, duration: liquidDuration);*/
                                });
                                Future.delayed(Duration(seconds: 3), () {
                                  setState(() {
                                    percent = 1.0;
                                  });
                                });
                                Future.delayed(Duration(seconds: 5), () {
                                  pageController.animateToPage(4,
                                      duration: Duration(milliseconds: 350),
                                      curve: Curves.easeInOut);
                                  /*liquidController.animateToPage(
                                      page: 4, duration: liquidDuration);*/
                                  Future.delayed(Duration(seconds: 1), () {
                                    setState(() {
                                      percent = 0.0;
                                    });
                                  });
                                });
                              });
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: new Ink(
                              child: Container(
                                alignment: Alignment.center,
                                height:
                                    MediaQuery.of(context).size.height / 14.45,
                                child: Text(
                                    AppLocalizations.of(context)
                                        .translate(
                                            'on_boarding_done_button_title')
                                        .toUpperCase(),
                                    style: TextStyle(
                                        color: press5_1
                                            ? kWelcomDarkTextColor
                                                .withOpacity(0.7)
                                            : kWelcomDarkTextColor,
                                        fontFamily: kFontFamilyGilroyBold,
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                49.78,
                                        letterSpacing: 0.01)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      flex: 0)
                ],
              ),
            ),
          ],
        ),
      );

  Widget get screen4 => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffFDF3FF), Color(0xffF9EBF8), Color(0xffF9EAF7)],
              stops: [0.45, 0.89, 0.96]),
        ),
        // color: kMainScreenScaffoldBackColor,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Image.asset('assets/on_boarding4_top_left.png',
                  height: MediaQuery.of(context).size.height / 3.63),
            ),
            Positioned(
              right: 0,
              top: MediaQuery.of(context).size.height / 9.73,
              child: Image.asset('assets/on_boarding4_points.png',
                  height: MediaQuery.of(context).size.height / 7.11),
            ),
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 5.33),
              child: Image.asset('assets/on_boarding4_center.png',
                  height: MediaQuery.of(context).size.height),
            ),
            Positioned(
              right: 0,
              bottom: MediaQuery.of(context).size.height / 15.37,
              child: Image.asset('assets/on_boarding2_bottom_right.png',
                  height: MediaQuery.of(context).size.height / 7.18),
            ),
            Container(
              width: width,
              height: height,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 9.53,
                  bottom: MediaQuery.of(context).size.height / 18.66),
              child: Column(
                children: [
                  Expanded(
                      child: Container(
                        child: Text(
                            AppLocalizations.of(context)
                                .translate('new_on_boarding_stories')
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: onBoardingTitleColor,
                                fontFamily: kFontFamilyExo2,
                                fontSize:
                                    MediaQuery.of(context).size.height / 26.35,
                                letterSpacing: 0.015)),
                      ),
                      flex: 0),
                  Expanded(child: Container()),
                  Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 26.35,
                            left: MediaQuery.of(context).size.height / 26.35,
                            right: MediaQuery.of(context).size.height / 26.35,
                            bottom: MediaQuery.of(context).size.height / 19.06),
                        child: Text(
                            AppLocalizations.of(context)
                                .translate('new_on_boarding_4'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: onBoardingSubTitleColor,
                              height: 1.3,
                              fontFamily: kFontFamilyGilroyBold,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              fontSize:
                                  MediaQuery.of(context).size.height / 38.4,
                            )),
                      ),
                      flex: 0),
                  Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xffFDB0C1), Color(0xffFF95AC)]),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x39FF98AD),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: Offset(2, 5),
                            ),
                          ],
                        ),
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.height / 42.66,
                            right: MediaQuery.of(context).size.height / 42.66),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.0),
                            onTap: () async {
                              setState(() {
                                press5 = true;
                              });
                              Future.delayed(Duration(seconds: 1), () {
                                setState(() {
                                  press5 = false;
                                });
                              });
                              /*liquidController.animateToPage(
                                  page: 6, duration: liquidDuration);*/
                              pageController.animateToPage(6,
                                  duration: Duration(milliseconds: 350),
                                  curve: Curves.easeInOut);
                              /*liquidController.animateToPage(
                                  page: 6, duration: liquidDuration);*/
                              Future.delayed(Duration(seconds: 3), () {
                                setState(() {
                                  percent = 1.0;
                                });
                              });
                              Future.delayed(Duration(seconds: 7), () {
                                pageController.animateToPage(7,
                                    duration: Duration(milliseconds: 350),
                                    curve: Curves.easeInOut);
                                /*liquidController.animateToPage(
                                    page: 7, duration: liquidDuration);*/
                                Future.delayed(Duration(seconds: 1), () {
                                  setState(() {
                                    percent = 0.0;
                                  });
                                });
                              });
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: new Ink(
                              child: Container(
                                alignment: Alignment.center,
                                height:
                                    MediaQuery.of(context).size.height / 14.45,
                                child: Text(
                                    AppLocalizations.of(context)
                                        .translate('new_on_boarding_next')
                                        .toUpperCase(),
                                    style: TextStyle(
                                        color: press5
                                            ? kWelcomDarkTextColor
                                                .withOpacity(0.7)
                                            : kWelcomDarkTextColor,
                                        fontFamily: kFontFamilyGilroyBold,
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                49.78,
                                        letterSpacing: 0.01)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      flex: 0)
                ],
              ),
            ),
          ],
        ),
      );

  Widget get screen5 => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: kAppPinkDarkColor,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: MediaQuery.of(context).size.height / 8.77,
              child: Image.asset('assets/on_boarding5_poitns.png',
                  height: MediaQuery.of(context).size.height / 5.1),
            ),
            Positioned(
              right: 0,
              top: MediaQuery.of(context).size.height / 12.93,
              child: Image.asset('assets/on_boarding5_top_right.png',
                  height: MediaQuery.of(context).size.height / 6.94),
            ),
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 5.33),
              child: Image.asset('assets/on_boarding5_center.png',
                  height: MediaQuery.of(context).size.height),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Image.asset('assets/on_boarding3_bottom_left.png',
                  height: MediaQuery.of(context).size.height / 6.04),
            ),
            Container(
              width: width,
              height: height,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 9.53,
                  bottom: MediaQuery.of(context).size.height / 18.66),
              child: Column(
                children: [
                  Expanded(
                      child: Container(
                        child: Text(
                            AppLocalizations.of(context)
                                .translate('new_on_boarding_chats')
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: kArticlesWhiteColor,
                                fontFamily: kFontFamilyExo2,
                                fontSize:
                                    MediaQuery.of(context).size.height / 24.88,
                                letterSpacing: 0.015)),
                      ),
                      flex: 0),
                  Expanded(child: Container()),
                  Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 26.35,
                            left: MediaQuery.of(context).size.height / 26.35,
                            right: MediaQuery.of(context).size.height / 26.35,
                            bottom: MediaQuery.of(context).size.height / 19.06),
                        child: Text(
                            AppLocalizations.of(context)
                                .translate('new_on_boarding_5'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: kArticlesWhiteColor,
                              height: 1.3,
                              fontFamily: kFontFamilyGilroyBold,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              fontSize:
                                  MediaQuery.of(context).size.height / 38.4,
                            )),
                      ),
                      flex: 0),
                  Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xffFFE1E8), Color(0xffFFBECD)]),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(240, 127, 152, 0.2),
                              spreadRadius: 5,
                              blurRadius: 5,
                              offset: Offset(5, 5),
                            ),
                          ],
                        ),
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.height / 42.66,
                            right: MediaQuery.of(context).size.height / 42.66),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.0),
                            onTap: () async {
                              setState(() {
                                press6 = true;
                              });
                              Future.delayed(Duration(seconds: 1), () {
                                setState(() {
                                  press6 = false;
                                });
                              });
                              pageController.animateToPage(6,
                                  duration: Duration(milliseconds: 350),
                                  curve: Curves.easeInOut);
                              /*liquidController.animateToPage(
                                  page: 6, duration: liquidDuration);*/
                              Future.delayed(Duration(seconds: 3), () {
                                setState(() {
                                  percent = 1.0;
                                });
                              });
                              Future.delayed(Duration(seconds: 7), () {
                                pageController.animateToPage(7,
                                    duration: Duration(milliseconds: 350),
                                    curve: Curves.easeInOut);
                                /*liquidController.animateToPage(
                                    page: 7, duration: liquidDuration);*/
                                Future.delayed(Duration(seconds: 1), () {
                                  setState(() {
                                    percent = 0.0;
                                  });
                                });
                              });
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: new Ink(
                              child: Container(
                                alignment: Alignment.center,
                                height:
                                    MediaQuery.of(context).size.height / 14.45,
                                child: Text(
                                    AppLocalizations.of(context)
                                        .translate('new_on_boarding_next')
                                        .toUpperCase(),
                                    style: TextStyle(
                                        color: press6
                                            ? kWelcomDarkTextColor
                                                .withOpacity(0.7)
                                            : kWelcomDarkTextColor,
                                        fontFamily: kFontFamilyGilroyBold,
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                49.78,
                                        letterSpacing: 0.01)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      flex: 0)
                ],
              ),
            ),
          ],
        ),
      );

  Widget get screen6 => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: kAppPinkDarkColor,
        // color: kMainScreenScaffoldBackColor,
        child: Stack(
          children: [
            /*Container(
              margin: EdgeInsets.only(top: 5),
              alignment: Alignment.center,
              child: CircularPercentIndicator(
                  radius: MediaQuery
                      .of(context)
                      .size
                      .height / 3.71,
                  lineWidth: 17.0,
                  animation: true,
                  percent: percent,
                  animationDuration: 3500,
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Colors.transparent,
                  progressColor: Color(0x70FF96AD)),
            ),*/
            Container(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(
                      MediaQuery.of(context).size.height / 3.81)),
                  child: Container(
                    child: BackdropFilter(
                      child: Container(
                        color: Colors.transparent,
                      ),
                      filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                    ),
                  ),
                )),
            Container(
              alignment: Alignment.center,
              child: CircularPercentIndicator(
                  radius: MediaQuery.of(context).size.height / 3.81,
                  lineWidth: 15.0,
                  animation: true,
                  percent: percent,
                  animationDuration: 1500,
                  backgroundColor: Color(0xffFFA1B5),
                  center: new Text(
                    "100%",
                    style: new TextStyle(
                        fontFamily: kFontFamilyExo2,
                        fontSize: MediaQuery.of(context).size.height / 20.36,
                        color: Colors.black),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: Color(0xffFCE6F4)),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: Image.asset('assets/on_boarding4_top_left.png',
                  height: MediaQuery.of(context).size.height / 3.63),
            ),
            Positioned(
              right: 0,
              top: MediaQuery.of(context).size.height / 5.73,
              child: Image.asset('assets/on_boarding2_bottom_right.png',
                  height: MediaQuery.of(context).size.height / 7.11),
            ),
            Positioned(
              right: 0,
              bottom: MediaQuery.of(context).size.height / 15.37,
              child: Image.asset('assets/on_boarding4_points.png',
                  height: MediaQuery.of(context).size.height / 7.18),
            ),
            Positioned(
              left: 0,
              top: MediaQuery.of(context).size.height / 4.37,
              child: Transform.rotate(
                  angle: 60,
                  child: Image.asset('assets/on_boarding4_points.png',
                      height: MediaQuery.of(context).size.height / 7.18)),
            ),
            Positioned(
              left: 0,
              bottom: 10,
              child: Transform.rotate(
                  angle: 60,
                  child: Image.asset('assets/on_boarding2_bottom_right.png',
                      height: MediaQuery.of(context).size.height / 5.11)),
            ),
            Positioned(
              left: MediaQuery.of(context).size.height / 17.92,
              bottom: MediaQuery.of(context).size.height / 20.36,
              child: Image.asset('assets/onboarding_7_left.png',
                  height: MediaQuery.of(context).size.height / 3.36),
            ),
            Container(
              width: width,
              height: height,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 9.53,
                  bottom: MediaQuery.of(context).size.height / 18.66),
              child: Column(
                children: [
                  Expanded(
                      child: Container(
                        child: Text(
                            AppLocalizations.of(context)
                                .translate('new_on_boarding_progress')
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: kArticlesWhiteColor,
                                fontFamily: kFontFamilyExo2,
                                fontSize:
                                    MediaQuery.of(context).size.height / 24.88,
                                letterSpacing: 0.015)),
                      ),
                      flex: 0),
                  Expanded(
                      child: Container(
                        child: Text(
                            AppLocalizations.of(context)
                                .translate('new_on_boarding_progress_sub')
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: kArticlesWhiteColor,
                                fontFamily: kFontFamilyExo2,
                                fontSize:
                                    MediaQuery.of(context).size.height / 36.35,
                                letterSpacing: 0.015)),
                      ),
                      flex: 0),
                ],
              ),
            ),
          ],
        ),
      );

  Widget timePicker() {
    bool is24Format = MediaQuery.of(context).alwaysUse24HourFormat;

    Locale myLocale = Localizations.localeOf(context);

    if (myLocale.languageCode == 'ru') {
      is24Format = true;
    }

    return Container(
        height: height / 4,
        child: CupertinoTheme(
            data: CupertinoThemeData(
                brightness: Brightness.light,
                textTheme: CupertinoTextThemeData(
                    pickerTextStyle: TextStyle(
                        fontFamily: kFontFamilyGilroy,
                        fontSize: MediaQuery.of(context).size.height / 38.95,
                        color: onBoardingSubTitleColor))),
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              use24hFormat: is24Format,
              initialDateTime: DateTime(2021, 9, 7, 21, 00),
              onDateTimeChanged: (DateTime value) {},
            )));
  }

  Widget indicatorContainer(int pos) {
    return Expanded(
        child: Container(
      height: 2,
      color: slidePage >= pos ? indicatorActiveColor : kWelcomButtonDarkColor,
      margin: EdgeInsets.only(left: 2.5, right: 2.5),
    ));
  }

  Future<void> getArticleTopics() async {
    String userToken = await PreferencesProvider().getAnonToken();
    RestApi().getTopicsList(context, token: userToken).then((values) {
      setState(() {
        topicsList = values;
        /*for (int i = 0; i <= topicsList.length; i++) {
          RestApi().sendFavCategory(topicsList[i].id.toString(), token: userToken).then((values) {});
        }*/
      });
    });
  }

  Future<void> sendDeleteFavTopic(bool isDelete, String id) async {
    String userToken = await PreferencesProvider().getAnonToken();
    if (isDelete) {
      RestApi().sendFavCategory(id, token: userToken).then((values) {});
    } else {
      RestApi().deleteFavCategory(id, token: userToken).then((values) {});
    }
  }

  Future<void> getPopularTopics() async {
    String userToken = await PreferencesProvider().getAnonToken();
    RestApi().getArticleTopicsPopular(context, token: userToken);
  }

  Future<void> getNewArticles() async {
    String userToken = await PreferencesProvider().getAnonToken();
    RestApi().getNewArticles(context, token: userToken);
  }

  Future<void> getPopularArticle() async {
    String userToken = await PreferencesProvider().getAnonToken();
    RestApi().getPopularArticles(context, token: userToken);
  }

  Future<void> getFavoritesTopics() async {
    String userToken = await PreferencesProvider().getAnonToken();
    RestApi().getFavoritesTopics(context, token: userToken);
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
