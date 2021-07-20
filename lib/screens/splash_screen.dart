
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/config/remote_config_helper.dart';
import 'package:sofy_new/helper/size_config.dart';
import 'package:sofy_new/models/subscribe_data.dart';
import 'package:sofy_new/providers/application_data_provider.dart';
import 'package:sofy_new/providers/preferences_provider.dart';
import 'package:sofy_new/rest_api.dart';
import 'package:sofy_new/screens/bloc/analytics.dart';
import 'package:sofy_new/screens/main_screen.dart';
import 'package:sofy_new/screens/onboarding_screen.dart';

import 'bloc/local_notification_service.dart';
import 'bloc/store_qonversion_helper.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {

  final StoreHelperQonversion _blocStore = StoreHelperQonversion();
  String userName = '';
  String userAnonToken = '';
  String userToken = '';

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    checkSessionCounter();
    Future.delayed(Duration(milliseconds: 100), () {
      checkSubs();
    });
    RemoteConfigHelper.instance.setup();
    getUserName().then((data) {
      _openScreen();
    });

    super.initState();
  }

  Future<void> getUserName() async {
    userName = await PreferencesProvider().getUserName();
    userToken = await PreferencesProvider().getUserToken();
    userAnonToken = await PreferencesProvider().getAnonToken();
    if (userName == '' && userToken == '' && userAnonToken == '') {
      return RestApi().userAnon();
    }
  }

  void checkSessionCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt('counters');
    if (count != null) {// Not first time
      if (count < 12) {
        count = count + 1;
        prefs.setInt('counters', count);
      }
      if (count >= 10) {
        isRateShowing = true;
      }
    } else {// First time
      prefs.setInt('counters', 1);
    }
  }

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);
    return Scaffold(
        body:
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: kSplashScrLinearGradColor,
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
              Center(
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Image.asset(
                        'assets/main_logo.png',
                      ),
                      height: MediaQuery.of(context).size.height / 3.23,
                      padding: EdgeInsets.only(right: 30),
                    ),
                    /*Text(
                        'SOFY',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xffE5356F),
                            fontFamily: Fonts.Exo2,
                            fontSize:
                            MediaQuery.of(context).size.height / 13.78,
                            letterSpacing: 0.015)),*/
                    /*Padding(
                      padding: EdgeInsets.only(top: 50),
                      child:SizedBox(
                        child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(kArticlesWhiteColor), strokeWidth: 2.0),
                        width: 30,
                        height: 30,
                      ) ,
                    )*/
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void checkSubs () async {
    var annual = await _blocStore.isCheckSubscribed(annual_purchase_key);
    var monthly = await _blocStore.isCheckSubscribed(monthly_purchase_key);
    if (annual || monthly) {
      Provider.of<SubscribeData>(context, listen:false).updateStatus(status:true);
      if (annual) {
        sendUserProperty('year', true);
      }
      if (monthly) {
        sendUserProperty('month', true);
      }
    } else {
      Provider.of<SubscribeData>(context, listen:false).updateStatus(status:false);
      sendUserProperty('none', false);
    }
  }

  void _openScreen() async {
    var isFirst = await PreferencesProvider().isFirstInit();
    await PreferencesProvider().saveSessions();

    print('isFirst = ' + isFirst.toString());

    Analytics().sendEventReports(event: application_start);
    if (isFirst) {
      getDataFromServer();
    } else {
      LocalNotificationService.instance.start();
      ApplicationDataProvider.downloadedApplicationData(context: context, finishedDownloading: () async {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => MainScreen(),
            transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
            transitionDuration: Duration(milliseconds: 650),
          ),
        );
      });
    }
  }

  Future getDataFromServer() async {Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (c, a1, a2) => OnBoardingScreen(),
      transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
      transitionDuration: Duration(milliseconds: 650),
    ),
  );
    ApplicationDataProvider.downloadedApplicationData(context: context, finishedDownloading: () async {});
  }

  void sendUserProperty(String sku, bool status) async {
    Map<String, dynamic> attr = {
      'sessions': await PreferencesProvider().getSessions(),
      'subscription_id': sku,
      'subscription_status': status,
    };
    Analytics().sendUserProperty(attr: attr);
  }
}
