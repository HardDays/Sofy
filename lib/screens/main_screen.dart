import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:sofy_new/constants/app_colors.dart';

import 'package:sofy_new/models/playlist_data.dart';
import 'package:sofy_new/providers/PageProvider.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/providers/player.dart';
import 'package:sofy_new/providers/preferences_provider.dart';
import 'package:sofy_new/screens/my_playlist_screen.dart';
import 'package:sofy_new/screens/player_screen.dart';
import 'package:sofy_new/screens/playlist_screen.dart';
import 'package:sofy_new/screens/recomendation_screen.dart';
import 'package:sofy_new/screens/setting_screen.dart';
import 'package:sofy_new/widgets/bottom_bar.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

import '../rest_api.dart';
import 'arcticles_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  double height, width;
  List<Widget> screensList = [];
  var selectedTab = SelectedTab.player;

  PCProvider pcProvider;

  void _handleIndexChanged(int i) {
    setState(() {
      selectedTab = SelectedTab.values[i];
    });
    print(selectedTab);
    switch(selectedTab) {
      case SelectedTab.patterns:
        if (!Provider.of<PlaylistData>(context,
            listen: false)
            .isPlayListNullApi(context))
          pcProvider.animateToPage(
            index: RecommendationScreen.PAGE_INDEX,
          );
        break;
      case SelectedTab.player:
        pcProvider.animateToPage(
          index: PlayerScreen.PAGE_INDEX,
        );
        break;
      case SelectedTab.article:
        pcProvider.animateToPage(
          index: ArticlesScreen.PAGE_INDEX,
        );
        break;
      case SelectedTab.settings:
        pcProvider.animateToPage(
          index: SettingsScreen.PAGE_INDEX,
        );
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    initScreenLists();
    getIDFA();
  }

  @override
  void dispose() {
    Provider.of<Player>(context, listen: false).stopVibrations();
    super.dispose();
  }

  Future<void> getIDFA() async {
    await AppTrackingTransparency.requestTrackingAuthorization();
  }

  void initScreenLists() {
    screensList = [
      PlayerScreen(),
      RecommendationScreen(),
      PlayListScreen(),
      MyPlaylistScreen(),
      SettingsScreen(),
      ArticlesScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    pcProvider = Provider.of<PCProvider>(context, listen: false);
    return RateMyAppBuilder(
      builder: (context) {
        return Scaffold(
          backgroundColor: kMainScreenScaffoldBackColor,
          body: Stack(
            children: <Widget>[
              PageView(
                pageSnapping: false,
                scrollDirection: Axis.horizontal,
                controller: Provider.of<PCProvider>(context).pageController,
                physics: NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  //stop when screen is change
                  //Provider.of<Player>(context, listen: false).stopVibrations();
                  pcProvider.updatePageIndex(index: index);

                  print('index = ' + index.toString());
                  setState(() {
                    if (index == 0) {
                      selectedTab = SelectedTab.player;
                    }
                    if (index == 1) {
                      selectedTab = SelectedTab.patterns;
                    }
                    if (index == 3) {
                      selectedTab = SelectedTab.player;
                    }
                    if (index == 4) {
                      selectedTab = SelectedTab.settings;
                    }
                    if (index == 5) {
                      selectedTab = SelectedTab.article;
                    }
                  });
                },
                children: screensList,
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      color: Colors.transparent,
                      height: height / 9.5, //112px
                      child: Container(
                        height: height / 9.5, //86px
                        padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: _isIPhoneX(MediaQuery.of(context)) ? 20.0 : 0.0),
                        decoration: BoxDecoration(
                            color: kMainBottomBArBackColor,
                            borderRadius:
                            BorderRadius.all(Radius.circular(0.0)),
                            border: Border.all(color: kWelcomButtonLightColor)),
                        child: Center(
                            child: SalomonBottomBar(
                              currentIndex: SelectedTab.values.indexOf(selectedTab),
                              onTap: _handleIndexChanged,
                              selectedItemColor: Colors.white,
                              unselectedItemColor: kNavigBarInactiveColor,
                              curve: Curves.decelerate,
                              items: [
                                SalomonBottomBarItem(
                                  icon: SvgPicture.asset(
                                    'assets/svg/modes.svg',
                                    height: 21,
                                    width: 19,
                                    color: selectedTab == SelectedTab.patterns ? Colors.white : kNavigBarInactiveColor,
                                  ),
                                  title: Text(
                                    AppLocalizations.of(context)
                                        .translate('patterns'),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Gilroy',
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  selectedColor: kNavigBarInactiveColor,
                                  unselectedColor: Colors.transparent,
                                ),
                                SalomonBottomBarItem(
                                  icon: SvgPicture.asset(
                                    'assets/svg/player.svg',
                                    height: 20,
                                    width: 32,
                                    color: selectedTab == SelectedTab.player ? Colors.white : kNavigBarInactiveColor,
                                  ),
                                  title: Text(
                                    AppLocalizations.of(context)
                                        .translate('player'),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Gilroy',
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  selectedColor: kNavigBarInactiveColor,
                                  unselectedColor: Colors.transparent,
                                ),
                               SalomonBottomBarItem(
                                  icon: SvgPicture.asset(
                                    'assets/svg/articles.svg',
                                    height: 20,
                                    width: 18,
                                    color: selectedTab == SelectedTab.article ? Colors.white : kNavigBarInactiveColor,
                                  ),
                                  title: Text(
                                    AppLocalizations.of(context)
                                        .translate('articles'),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Gilroy',
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  selectedColor: kNavigBarInactiveColor,
                                  unselectedColor: Colors.transparent,
                                ),
                                SalomonBottomBarItem(
                                  icon: SvgPicture.asset(
                                    'assets/svg/settings.svg',
                                    height: 21,
                                    width: 21,
                                    color: selectedTab == SelectedTab.settings ? Colors.white : kNavigBarInactiveColor,
                                  ),
                                  title: Text(
                                    AppLocalizations.of(context)
                                        .translate('settings'),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Gilroy',
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  selectedColor: kNavigBarInactiveColor,
                                  unselectedColor: Colors.transparent,
                                ),
                              ],
                            )),
                      ))),
            ],
          ),
        );
      },
      rateMyApp: RateMyApp(
        preferencesPrefix: 'rateMyApp_',
        minDays: 0,
        minLaunches: 5,
        remindDays: 0,
        remindLaunches: 5,
        googlePlayIdentifier: 'sofy.vibrator.massage.app',
        //TODO CHECK iOs Identifier
        appStoreIdentifier: '1491556149',
      ),
      onInitialized: (context, rateMyApp) {
        rateMyApp.conditions.forEach((condition) {
          if (condition is DebuggableCondition) {
            print(condition.valuesAsString);
          }
        });

        print('Are all conditions met ? ' +
            (rateMyApp.shouldOpenDialog ? 'Yes' : 'No'));
        if (rateMyApp.shouldOpenDialog) {
          rateMyApp.showStarRateDialog(
            context,
            title: AppLocalizations.of(context).translate('Rate this app'),
            message:
                AppLocalizations.of(context).translate('You like this app'),
            // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
            actionsBuilder: (context, stars) {
              // Triggered when the user updates
              // the star rating.
              return [
                // Return a list of actions (that will be shown at the bottom of the dialog).
                FlatButton(
                  child: Text('OK', style: TextStyle(fontSize: 18)),
                  onPressed: () async {
                    print('Thanks for the ' +
                        (stars == null ? '0' : stars.round().toString()) +
                        ' star(s) !');
                    // You can handle the result as you want (for instance if the user puts 1 star then open your contact page, if he puts more then open the store page, etc...).
                    // This allows to mimic the behavior of the default "Rate" button. See "Advanced > Broadcasting events" for more information :
                    //TODO Finish after approve
                    await rateMyApp.launchStore();
                    await rateMyApp
                        .callEvent(RateMyAppEventType.laterButtonPressed);
                    Navigator.pop<RateMyAppDialogButton>(
                        context, RateMyAppDialogButton.later);
                  },
                ),
              ];
            },
            // Set to false if you want to show the native Apple app rating dialog on iOS.
            dialogStyle: DialogStyle(
              // Custom dialog styles.
              titleAlign: TextAlign.center,
              messageAlign: TextAlign.center,
              messagePadding: EdgeInsets.only(bottom: 20),
            ),
            starRatingOptions: StarRatingOptions(),
            // Custom star bar rating options.
            onDismissed: () => rateMyApp.callEvent(RateMyAppEventType
                .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
          );
        }
      },
    );
  }

  bool _isIPhoneX(MediaQueryData mediaQuery) {
    if (Platform.isIOS) {
      var size = mediaQuery.size;
      if (size.height > 812.0 || size.width > 812.0) {
        return true;
      }
    }
    return false;
  }

  Color getColor({PCProvider pcProvider, int pageIndex, bool forText = true}) {
    return pcProvider.pageIndex == pageIndex
        ? kAppPinkDarkColor
        : forText ? kNavigBarInactiveColor : kMainBottomBArBackColor;
  }

  FontWeight getFontWeight({PCProvider pcProvider, int pageIndex}) {
    return pcProvider.pageIndex == pageIndex
        ? FontWeight.bold
        : FontWeight.normal;
  }
}

enum SelectedTab { patterns, player, article, settings }
