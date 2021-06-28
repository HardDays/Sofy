import 'dart:async';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/config_const.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/config/remote_config_helper.dart';
import 'package:sofy_new/models/subscribe_data.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/screens/bloc/analytics.dart';
import 'package:sofy_new/screens/bloc/store_qonversion_helper.dart';
import 'package:sofy_new/screens/main_screen.dart';
import 'package:url_launcher/url_launcher.dart';

bool isFromSplash = false;

class SubscribeScreen extends StatefulWidget {
  final bool isFromSplash;

  SubscribeScreen({Key key, @required this.isFromSplash}) : super(key: key);

  @override
  _SubscribeScreenState createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  double height;
  double width;
  bool isFree = true, isByMonth = false;

  String titleSubscribe;
  String subtitleSubscribe;

  bool press = false;

  String buttonTitle;
  final StoreHelperQonversion _blocStore = StoreHelperQonversion();

  Map<String, QProduct> _offerings;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    initPlatformState();
    Analytics().sendEventReports(
        event: widget.isFromSplash
            ? onbording_subscription_splash_show
            : subscription_splash_show,
        attr: {
          'source':
          'onboarding/speed_change/modes_screen/settings_screen',
        });
  }

  Future<void> initPlatformState() async {
    Map<String, QProduct> offerings = await _blocStore.getProducts();
    if (!mounted) return;
    setState(() {
      _offerings = offerings;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    if (isFree) {
      titleSubscribe = RemoteConfigHelper.instance
          .value(context, annualTextFirstAboveButtonKey);
      subtitleSubscribe = RemoteConfigHelper.instance
          .value(context, annualTextSecondAboveButtonKey);
      buttonTitle =
          RemoteConfigHelper.instance.value(context, annualButtonNameKey);
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: kSubscrScrLinearGradColor,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: MediaQuery.of(context).size.height / 5.1,
              child: Image.asset('assets/on_boarding6_poitns.png',
                  height: MediaQuery.of(context).size.height / 6.53),
            ),
            Positioned(
              left: 0,
              top: MediaQuery.of(context).size.height / 5.3,
              child: Image.asset('assets/on_boarding6_top_left.png',
                  height: MediaQuery.of(context).size.height / 7.7),
            ),
            ListView(children: [
              Column(
                children: <Widget>[
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                            height: widget.isFromSplash ? height / 23.5 : 0),
                        Stack(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                    width: 55,
                                    alignment: Alignment.center,
                                    child: Stack(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: width / 42.66),
                                          child: Container(
                                            child: SvgPicture.asset(
                                              widget.isFromSplash
                                                  ? 'assets/svg/close.svg'
                                                  : 'assets/svg/back_vector.svg',
                                              color: widget.isFromSplash
                                                  ? kSubscrScrSvgBtnColor
                                                  : kSubscrScrSvgBtn2Color,
                                              height: height / 30.33,
                                            ),
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                                focusColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                splashColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(60),
                                                radius: 25,
                                                onTap: () {
                                                  Analytics().sendEventReports(
                                                      event: widget.isFromSplash
                                                          ? onbording_subscription_splash_close_click
                                                          : subscription_splash_close_click,
                                                      attr: {
                                                        'source':
                                                            'onboarding/speed_change/modes_screen/settings_screen',
                                                      });
                                                  closeScreen();
                                                }),
                                          ),
                                        ),
                                      ],
                                    ))),
                            GestureDetector(
                                onTap: () async {
                                  Analytics().sendEventReports(
                                      event: subscription_restore_click);
                                  var annual = await _blocStore
                                      .restorePurchase(annual_purchase_key);
                                  var monthly = await _blocStore
                                      .restorePurchase(monthly_purchase_key);
                                  if (annual || monthly) {
                                    Provider.of<SubscribeData>(context,
                                            listen: false)
                                        .updateStatus(status: true);
                                    closeScreen();
                                  }
                                },
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(top: height / 179.2),
                                    padding:
                                        EdgeInsets.only(right: height / 42.6),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate('restore'),
                                      style: TextStyle(
                                        color: kSubscrScrRestoreColor,
                                        fontFamily: kFontFamilyExo2,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                49.77,
                                        //24
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                ))
                          ],
                        )
                      ]),
                  SizedBox(
                      height:
                          widget.isFromSplash ? height / 99.5 : height / 99.5),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(AppLocalizations.of(context).translate('enjoy'),
                        style: TextStyle(
                            color: onBoardingTitleColor,
                            fontFamily: kFontFamilyExo2,
                            fontSize:
                                MediaQuery.of(context).size.height / 24.88,
                            fontStyle: FontStyle.normal,
                            letterSpacing: 0.015)),
                  ),
                  SizedBox(height: height / 89.6),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                        AppLocalizations.of(context)
                            .translate('your_full_access'),
                        style: TextStyle(
                          color: onBoardingTitleColor,
                          fontFamily: kFontFamilyExo2,
                          fontSize: MediaQuery.of(context).size.height / 34.46,
                          fontStyle: FontStyle.normal,
                        )),
                  ),
                  SizedBox(height: height / 24.97),
                  Container(
                    child: Image.asset('assets/on_boarding6_center.png',
                        height: height / 5.11),
                  ),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height / 32),
                        purchaseItem(AppLocalizations.of(context)
                            .translate('all_sex_insights')),
                        purchaseItem(AppLocalizations.of(context)
                            .translate('all_vibration_patterns')),
                        purchaseItem(AppLocalizations.of(context)
                            .translate('speed_control')),
                        purchaseItem(
                            AppLocalizations.of(context).translate('ad_free')),
                        SizedBox(height: height / 48),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height / 42.66),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isFree = true;
                          isByMonth = false;
                          titleSubscribe = RemoteConfigHelper.instance
                              .value(context, annualTextFirstAboveButtonKey);
                          subtitleSubscribe = RemoteConfigHelper.instance
                              .value(context, annualTextSecondAboveButtonKey);
                          buttonTitle = RemoteConfigHelper.instance
                              .value(context, annualButtonNameKey);
                        });
                      },
                      child: Badge(
                        padding: EdgeInsets.all(3),
                        elevation: 0.0,
                        shape: BadgeShape.square,
                        borderRadius: BorderRadius.circular(6.0),
                        toAnimate: false,
                        badgeColor: kSubscrScrWidgColor,
                        position: BadgePosition.topEnd(end: 25, top: -12.0),
                        child: Container(
                          height: height / 12.8,
                          padding: EdgeInsets.only(
                              left: 20.0,
                              right: 16.0,
                              top: height / 74.6,
                              bottom: height / 74.6),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isFree
                                ? kSettingInActiveButtonColor
                                : kSubscrScrWidgNotColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            border: Border.all(
                              color: isFree
                                  ? kSubscrScrWidgColor
                                  : kSubscrScrWidgNotColor,
                              width: isFree ? 1.3 : 0.0,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    RemoteConfigHelper.instance
                                        .value(context, annualPlanNameKey),
                                    style: TextStyle(
                                      color: isFree
                                          ? kSubscrScrTextColor
                                          : kSubscrScrNotTextColor,
                                      fontFamily: kFontFamilyGilroyBold,
                                      fontSize: height / 52,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                  SizedBox(height: height / 150),
                                  Text(
                                    RemoteConfigHelper.instance.value(
                                        context, annualPlanDescriptionKey),
                                    style: TextStyle(
                                      color: isFree
                                          ? kSubscrScrTextColor
                                          : kSubscrScrNotTextColor,
                                      fontFamily: kFontFamilyGilroy,
                                      fontSize: height / 74.6,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              CircleAvatar(
                                radius: 8.0,
                                backgroundColor: isFree
                                    ? kSubscrScrWidgColor
                                    : kSubscrScrNotAvaColor,
                                child: Icon(
                                  Icons.check,
                                  size: 12,
                                  color: kSubscrScrNotAvaColor,
                                ),
                              )
                            ],
                          ),
                        ),
                        badgeContent: Container(
                          height: height / 44.46,
                          padding: EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 0.0, bottom: 0.0),
                          child: Center(
                              child: Text(
                            AppLocalizations.of(context).translate('discount'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: kArticlesWhiteColor,
                              fontFamily: kFontFamilyProximaNova,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                        ),
                        showBadge: isFree,
                      ),
                    ),
                  ),
                  SizedBox(height: height / 49.77),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height / 42.66),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isByMonth = true;
                          isFree = false;
                          titleSubscribe = RemoteConfigHelper.instance
                              .value(context, monthTextFirstAboveButton);
                          subtitleSubscribe = RemoteConfigHelper.instance
                              .value(context, monthTextSecondAboveButtonKey);
                          buttonTitle = RemoteConfigHelper.instance
                              .value(context, monthButtonNameKey);
                        });
                      },
                      child: Container(
                        height: height / 12.8,
                        padding: EdgeInsets.only(
                            left: 20.0,
                            right: 16.0,
                            top: height / 74.6,
                            bottom: height / 74.6),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isByMonth
                              ? kSettingInActiveButtonColor
                              : kSubscrScrWidgNotColor,
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          border: Border.all(
                            color: isByMonth
                                ? kSubscrScrWidgColor
                                : kSubscrScrWidgNotColor,
                            width: isByMonth ? 1.3 : 0.0,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  RemoteConfigHelper.instance
                                      .value(context, monthPlanNameKey),
                                  style: TextStyle(
                                    color: isByMonth
                                        ? kSubscrScrTextColor
                                        : kSubscrScrNotTextColor,
                                    fontFamily: kFontFamilyGilroyBold,
                                    fontSize: height / 52,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                                SizedBox(height: height / 150),
                                Text(
                                  RemoteConfigHelper.instance
                                      .value(context, monthPlanDescriptionKey),
                                  style: TextStyle(
                                    color: isByMonth
                                        ? kSubscrScrTextColor
                                        : kSubscrScrNotTextColor,
                                    fontFamily: kFontFamilyGilroy,
                                    fontSize: height / 74.6,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            CircleAvatar(
                              radius: 8.0,
                              backgroundColor: isByMonth
                                  ? kSubscrScrWidgColor
                                  : kSubscrScrNotAvaColor,
                              child: Icon(
                                Icons.check,
                                size: 12,
                                color: kSubscrScrNotAvaColor,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height / 49.77),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: kSubscrScrLinear2GradColor),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: kSubscrScrShadowColor,
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
                            press = true;
                          });

                          if (isByMonth) {
                            var monthly = await _blocStore
                                .makePurchased(monthly_purchase_key);
                            if (monthly) {
                              Analytics().sendEventReports(
                                  event: subscription_purchase_m_click,
                                  attr: {
                                    'product_id': 'month',
                                  });
                              Provider.of<SubscribeData>(context, listen: false)
                                  .updateStatus(status: true);
                              closeScreen();
                            }
                          } else {
                            var annual = await _blocStore
                                .makePurchased(annual_purchase_key);
                            if (annual) {
                              Analytics().sendEventReports(
                                  event: subscription_purchase_y_click,
                                  attr: {
                                    'product_id': 'annual',
                                  });
                              Provider.of<SubscribeData>(context, listen: false)
                                  .updateStatus(status: true);
                              closeScreen();
                            }
                          }
                        },
                        splashColor: kSubscrScrWidgColor,
                        highlightColor: Colors.transparent,
                        child: new Ink(
                          child: Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height / 14.45,
                            child: Text(buttonTitle,
                                style: TextStyle(
                                    color: press
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(21.0, height / 35.84, 21.0, 0),
                    child: Text(
                      AppLocalizations.of(context)
                          .translate('short_desc')
                          .replaceAll(
                              '{{market}}',
                              Platform.isAndroid
                                  ? "Google Play"
                                  : Platform.isIOS
                                      ? "iTunes"
                                      : ''),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kSubscrScrText2Color,
                        fontFamily: kFontFamilyGilroy,
                        fontSize: 10.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Padding(
                    padding: EdgeInsets.fromLTRB(21.0, 0, 21.0, 10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: width / 16.06),
                            child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  highlightColor:
                                      kSubscrScrWidgColor.withOpacity(0.2),
                                  splashColor: Colors.transparent,
                                  borderRadius: BorderRadius.circular(25.0),
                                  onTap: () {
                                    launch(
                                        "https://drive.google.com/open?id=1gHoSZJKKi64ujRa2plFKU19JSc3WHwem");
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate('terms_conditions'),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color.fromRGBO(56, 57, 79, 0.55),
                                        fontFamily: kFontFamilyGilroy,
                                        fontSize: 10.0,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: width / 16.06),
                            child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  highlightColor:
                                      kSubscrScrWidgColor.withOpacity(0.2),
                                  splashColor: Colors.transparent,
                                  borderRadius: BorderRadius.circular(25.0),
                                  onTap: () {
                                    launch(
                                        "https://drive.google.com/open?id=1X1J5svUc9mjnoRgwii0wQgD1DG6QBEAp");
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate('privacy'),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color.fromRGBO(56, 57, 79, 0.55),
                                        fontFamily: kFontFamilyGilroy,
                                        fontSize: 10.0,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                )),
                          ),
                        ]),
                  )
                ],
              )
            ])
          ],
        ),
      ),
    );
  }

  List<Widget> get listStars {
    List<Widget> list = [];
    for (int i = 0; i < 5; i++) {
      list.add(SvgPicture.asset(
        'assets/svg/star.svg',
        height: height / 58.03,
        width: width / 21.01,
      ));
      list.add(SizedBox(width: 5));
    }
    return list;
  }

  void closeScreen() {
    if (widget.isFromSplash) {
      Navigator.of(context).pushReplacement(
          FadeRoute(builder: (BuildContext context) => MainScreen()));
    } else {
      Navigator.pop(context);
    }
  }

  Widget descriptionPurchase(String text) {
    return Row(
      children: [
        SizedBox(height: 30),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: width / 4.08),
            SvgPicture.asset(
              'assets/svg/circle_check.svg',
              width: 14,
              height: 14,
            ),
            SizedBox(width: 15),
            Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: kSubscrScrTextColor,
                fontFamily: kFontFamilyProximaNova,
                fontSize: height / 50.71,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column descriptionPurchases() {
    List<Widget> widgetes = [
      descriptionPurchase(AppLocalizations.of(context).translate('unlock')),
      descriptionPurchase(
          AppLocalizations.of(context).translate('individual_vibrations')),
      descriptionPurchase(
          AppLocalizations.of(context).translate('speed_control'))
    ];
    if (Platform.isIOS) {
      widgetes.add(descriptionPurchase(
          AppLocalizations.of(context).translate('update_purchase')));
    }

    return Column(children: widgetes);
  }

  Widget purchaseItem(String text) {
    return Container(
      margin: EdgeInsets.only(bottom: height / 96),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              child: SvgPicture.asset(
                'assets/svg/circle_check.svg',
                width: 16,
                height: 16,
              ),
              margin: EdgeInsets.only(right: height / 89.6)),
          Container(
              child: Text(text,
                  style: TextStyle(
                    color: kSubscrScrTextColor,
                    fontFamily: kFontFamilyGilroyBold,
                    fontSize: height / 40.72,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  ))),
        ],
      ),
    );
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
