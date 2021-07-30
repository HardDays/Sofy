import 'package:appmetrica_sdk/appmetrica_sdk.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';
import 'package:device_id/device_id.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:tenjin_sdk/tenjin_sdk.dart';

class Analytics {
  Amplitude _amplitude;
  FirebaseAnalytics firebaseAnalytics;
  final facebookAppEvents = FacebookAppEvents();

  static final Analytics _instance = Analytics._internal();

  factory Analytics() => _instance;
  
  Analytics._internal() {
    // init things inside this
    _amplitude = Amplitude.getInstance(instanceName: 'sofy_new');
    firebaseAnalytics = FirebaseAnalytics();
  }

  void initAmplitude() async {
    String userId = await DeviceId.getID;
    _amplitude.init(kAmplitudeFlutterApiKey, userId: userId);
    firebaseAnalytics.setUserId(userId);

    print('Analytics use user id: $userId');
  }

  void sendUserProperty ({Map<String, dynamic> attr}) async {
    print('sendUserProperty: $attr, userId: ${await DeviceId.getID}');
    /** Amplitude **/
    _amplitude.setUserProperties(attr);
    final Identify identify = Identify();
    attr.forEach((k, v) {
      identify.set(k, v);
    });
    _amplitude.identify(identify);


    /** Firebase **/
    attr.forEach((k, v) {
      firebaseAnalytics.setUserProperty(name: k, value: v.toString());
    });
  }

  void sendEventReports ({String event, Map<String, dynamic> attr = const {}}) async {
    print('attr: $attr');

    AppmetricaSdk().reportEvent(
        name: event,
        attributes: attr,
    );

    _amplitude.logEvent(event, eventProperties: attr);

    // facebookAppEvents.logEvent(
    //   name: event,
    //   parameters: attr,
    // );

    TenjinSDK.instance.eventWithName(event);
    firebaseAnalytics.logEvent(name: event, parameters: attr);
  }
}