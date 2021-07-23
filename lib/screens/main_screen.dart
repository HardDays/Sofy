import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/size_config.dart';
import 'package:sofy_new/providers/PageProvider.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/providers/player.dart';
import 'package:sofy_new/screens/player_screen_v2.dart';
import 'package:sofy_new/screens/setting_screen.dart';
import 'package:sofy_new/widgets/curved_nav_bar_item.dart';

import 'arcticles_screen.dart';
int selectedItemBar = 1;
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double height, width;
  List<Widget> screensList = [
    ArticlesScreen(),
    PlayerScreenV2(),
    SettingsScreen(),
  ];
  var selectedTab = SelectedTab.player;
  List<String> svgImagePath = [
    'assets/svg/articles.svg',
    'assets/svg/player.svg',
    'assets/svg/settings.svg'
  ];
  List<String> title = [
    'articles',
    'player',
    'settings',
  ];

  PCProvider pcProvider;

  void _handleIndexChanged(int i) {
    setState(() {
      selectedTab = SelectedTab.values[i];
    });
    print(selectedTab);
    switch (selectedTab) {
      case SelectedTab.player:
        pcProvider.animateToPage(
          index: PlayerScreen_PAGE_INDEX,
        );
        break;
      case SelectedTab.article:
        pcProvider.animateToPage(
          index: ArticlesScreen_PAGE_INDEX,
        );
        break;
      case SelectedTab.settings:
        pcProvider.animateToPage(
          index: SettingsScreen_PAGE_INDEX,
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
                  // //stop when screen is change
                  // //Provider.of<Player>(context, listen: false).stopVibrations();
                  pcProvider.updatePageIndex(index: index);
                  selectedTab = SelectedTab.values[index];
                },
                children: screensList,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  height: 92 / Layout.height *
                      Layout.multiplier *
                      SizeConfig.blockSizeVertical,
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      CurvedNavigationBar(
                        height: 75,
                        animationDuration: Duration(milliseconds: 300),
                        backgroundColor: Colors.transparent,
                        index: selectedItemBar,
                        items:List.generate(3, (index) => CurvedNavBarItem(svgAsset: svgImagePath[index], title: title[index], selected: index == selectedItemBar ? true : false,)),
                        onTap: (index) {
                          selectedItemBar = index;
                          _handleIndexChanged(index);
                        },
                      ),
                      Container(
                        width: width,
                        height: 92 / Layout.height *
                            Layout.multiplier *
                            SizeConfig.blockSizeVertical - 75,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
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

  Color getColor({PCProvider pcProvider, int pageIndex, bool forText = true}) {
    return pcProvider.pageIndex == pageIndex
        ? kAppPinkDarkColor
        : forText
            ? kNavigBarInactiveColor
            : kMainBottomBArBackColor;
  }

  FontWeight getFontWeight({PCProvider pcProvider, int pageIndex}) {
    return pcProvider.pageIndex == pageIndex
        ? FontWeight.bold
        : FontWeight.normal;
  }
}

enum SelectedTab { article, player, settings }

