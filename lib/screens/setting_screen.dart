import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/models/subscribe_data.dart';
import 'package:sofy_new/providers/PageProvider.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/providers/preferences_provider.dart';
import 'package:sofy_new/providers/user.dart';
import 'package:sofy_new/screens/bloc/analytics.dart';
import 'package:sofy_new/screens/bloc/setting_bloc.dart';
import 'package:sofy_new/screens/subscribe_screen.dart';
import 'package:sofy_new/screens/user_profile.dart';
import 'package:sofy_new/screens/user_registration.dart';
import 'package:sofy_new/widgets/create_account_button.dart';
import 'package:sofy_new/widgets/setting_screen_button.dart';
import 'package:sofy_new/widgets/settings_info_dialog.dart';

import '../rest_api.dart';

class SettingsScreen extends StatefulWidget {
//  final PageController pageController;
//  final int previousPageIndex;
//  SettingsScreen({this.pageController, this.previousPageIndex});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool questionTapped = false;
  bool starTapped = false;
  bool letterTapped = false;
  bool shareTapped = false;
  List<Widget> screensList = [];
  String userName = '';
  User user;
  String avaPath;
  int avaColor;

  final _resumeDetectorKey = UniqueKey();

  final SettingBloc _bloc = SettingBloc();

  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 0,
    minLaunches: 5,
    remindDays: 0,
    remindLaunches: 5,
    googlePlayIdentifier: googlePlayIdentifier,
    //TODO CHECK iOs Identifier
    appStoreIdentifier: appStoreIdentifier
  );

  @override
  void initState() {
    super.initState();
    Analytics().sendEventReports(
      event: settings_screen_show,
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    PCProvider pcProvider = Provider.of<PCProvider>(context, listen: false);

    user = Provider.of<User>(context, listen: true);

    return FocusDetector(
      key: _resumeDetectorKey,
      child: Stack(
        children: <Widget>[
          _BackgroundLinearColor(),
          Padding(
              padding: EdgeInsets.only(left: 0.0, right: 0.0, top: height / 14.50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Container(
                          padding: EdgeInsets.only(bottom: 5.0),
                          alignment: Alignment.center,
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('settings'),
//                  'Настройки',
                            style: TextStyle(
                                fontFamily: kFontFamilyExo2,
                                fontWeight: FontWeight.bold,
                                fontSize: height / 37.33, //24
                                color: kNavigBarInactiveColor),
                          ),
                        )),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: width / 20.7,
                      right: width / 20.7,
                      top: height / 34.18),
                  child: Column(
                    children: <Widget>[
                      Visibility(
                          visible: !Provider.of<SubscribeData>(context)
                              .isAppPurchase,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                    top: 6.0,
                                    bottom: 6.0,
                                    left: 6.0,
                                    right: 21.0),
                                height: height / 10.41,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: kAppPinkDarkColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: kSettScrShadowColor,
                                      offset: Offset(7, 7),
                                      blurRadius: 10.0,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: height / 12.10,
                                      width: height / 12.10,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        image: DecorationImage(
                                          image:
                                              AssetImage('assets/image7.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: height / 56.0),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate('open_all'),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: kFontFamilyGilroyBold,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.normal,
                                            fontSize: height / 64.0,
                                            height: 1.50,
                                            color: kArticlesWhiteColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 30.0),
                                    SvgPicture.asset(
                                        'assets/svg/arrow_next_vector.svg',
                                        height: 12.0),
                                  ],
                                ),
                              ),
                              Positioned.fill(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                      highlightColor:
                                          kAppPinkDarkColor.withOpacity(0.20),
                                      splashColor:
                                          kAppPinkDarkColor.withOpacity(0.20),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                      onTap: () {
                                        Analytics().sendEventReports(
                                          event: banner_click,
                                        );
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SubscribeScreen(
                                                    isFromSplash: false),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                          height: Provider.of<SubscribeData>(context)
                                  .isAppPurchase
                              ? 0
                              : height / 18.66),
                      CreateAccountButton(
                        iconUrl: !user.isAuth ? 'assets/create_account.png' : avaPath != null ? avaPath : 'assets/create_account.png',
                        backColor: avaPath != null ? avaColor : kSettScrCreteAccBtnColor,
                        height: !user.isAuth ? 1 : 0,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        text: AppLocalizations.of(context)
                            .translate('create_an_account'),
                        onTap: () {
                          /*Analytics().sendEventReports(
                          event: not_vibrating_click,
                        );*/
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserRegistrationScreen(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: !user.isAuth ? height / 42.66 : 0),
                      CreateAccountButton(
                        iconUrl: avaPath != null ? avaPath : 'assets/create_account.png',
                        backColor: avaPath != null ? avaColor : kSettScrCreteAccBtnColor,
                        height: user.isAuth ? 1 : 0,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        text: userName,
                        onTap: () {
                          /*Analytics().sendEventReports(
                          event: not_vibrating_click,
                        );*/
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserProfileScreen(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: user.isAuth ? height / 42.66 : 0),
                      SettingScreenButton(
                        iconUrl: 'assets/svg/question_mark_vector.svg',
                        height: 1,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0)),
                        text: AppLocalizations.of(context)
                            .translate('not_vibrating'),
                        onTap: () {
                          Analytics().sendEventReports(
                            event: not_vibrating_click,
                          );
                          showDialog(
                            context: context,
                            builder: (_) => SettingsInfoDialog(),
                            barrierDismissible: true,
                          );
                        },
                      ),
                      SettingScreenButton(
                        iconUrl: 'assets/svg/star_vector.svg',
                        height: isRateShowing ? 1 : 0,
                        borderRadius: BorderRadius.all(Radius.circular(0.0)),
                        text:
                            AppLocalizations.of(context).translate('rate_us'),
                        onTap: () async {
                          final InAppReview inAppReview = InAppReview.instance;

                          if (await inAppReview.isAvailable()) {
                          inAppReview.requestReview();
                          }
                          Analytics().sendEventReports(
                            event: rate_us_click,
                          );
                        },
                      ),
                      SettingScreenButton(
                        iconUrl: 'assets/svg/letter_vector.svg',
                        height: 1,
                        borderRadius: BorderRadius.all(Radius.circular(0.0)),
                        text: AppLocalizations.of(context)
                            .translate('send_feedback'),
                        onTap: () {
                          Analytics().sendEventReports(
                            event: send_feedback_click,
                          );
                          _bloc.launchURL(feedbackEmail);
                        },
                      ),
                      SettingScreenButton(
                        iconUrl: 'assets/svg/share_vector.svg',
                        height: 1,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0)),
                        text: AppLocalizations.of(context).translate('share'),
                        onTap: () {
                          Analytics().sendEventReports(
                            event: share_click,
                          );
                          _bloc.shareApp(context: context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      onFocusGained: () {
        getUserName();
        getUserProfile();
        print('AVA PATH = ' + avaPath.toString());
        print('is auth = ' + user.isAuth.toString());
      },
    );
  }

  Future getAva() async {
    avaPath = await PreferencesProvider().getAvaNumber();
    avaColor = await PreferencesProvider().getAvaBackground();
    setState(() {});
    print('avaColor = ' + avaColor.toString());
    print('imagePath = ' + avaPath);
  }

  Future<void> getUserName() async {
    if (await PreferencesProvider().getUserPhoto() == '' && await PreferencesProvider().getAvaNumber() != '') {
      getAva();
    }
    String userPhoto = await PreferencesProvider().getUserPhoto();
    if (userPhoto.contains('http')) {
      avaPath = await PreferencesProvider().getUserPhoto();
      setState(() {});
    }
    userName = await PreferencesProvider().getUserName();
    if (userName != '') {
      user.updateIsAuth(flag: true);
    } else {
      user.updateIsAuth(flag: false);
    }
    setState(() {});
  }

  Future<void> getUserProfile() async {
    String userId = await PreferencesProvider().getUserId();
    String token = await PreferencesProvider().getUserToken();
    if (userId != '' && token != '') {
      RestApi().userProfile(context, userId, token).then((values) async {
        await PreferencesProvider().saveUserPhoto(avaPath);
        avaPath = values;
        setState(() {});
      });
    }
  }
}

class _BackgroundLinearColor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: kSettingScreenLinearGradientColor,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 1.0],
        ),
      ),
    );
  }
}