import 'dart:async';

import 'package:appmetrica_sdk/appmetrica_sdk.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sofy_new/models/PlaylistNameData.dart';
import 'package:sofy_new/models/playlist_data.dart';
import 'package:sofy_new/models/subscribe_data.dart';
import 'package:sofy_new/providers/PageProvider.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/providers/player.dart';
import 'package:sofy_new/screens/bloc/analytics.dart';
import 'package:sofy_new/screens/splash_screen.dart';
import 'package:tenjin_sdk/tenjin_sdk.dart';

import 'constants/constants.dart';
import 'providers/user.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Analytics().initAmplitude();


  /// Initializing the AppMetrica SDK.
  await AppmetricaSdk().activate(apiKey: kAppmetricaSdkApiKey);
  await Firebase.initializeApp();
  await TenjinSDK.instance.init(apiKey: kTenjinFlutterApiKey);
  runZoned(() {
    runApp(MyApp());
  });

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PlaylistData>(
          create: (context) => PlaylistData(),
        ),
        ChangeNotifierProvider<PlaylistNameData>(
          create: (context) => PlaylistNameData(),
        ),
        ChangeNotifierProvider<PCProvider>(
          create: (context) => PCProvider(),
        ),
        ChangeNotifierProvider<Player>(
          create: (context) => Player(),
        ),
        ChangeNotifierProvider<SubscribeData>(
          create: (context) => SubscribeData(),
        ),
        ChangeNotifierProvider<User>(
          create: (context) => User(),
        ),
      ],
      child: MaterialApp(
        supportedLocales: [
          Locale('en', 'US'),
          Locale('ru', 'RU'),
        ],
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        debugShowCheckedModeBanner: false,
//        home: OnBoardingScreen(),
        home: SplashScreen(),
        theme: ThemeData(pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        })),
      ),
    );
  }
}