
import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:sofy_new/constants/config_const.dart';
import 'package:sofy_new/providers/app_localizations.dart';


class RemoteConfigHelper {

  RemoteConfig remoteConfig;

  static final RemoteConfigHelper instance = RemoteConfigHelper();


  Future<RemoteConfig> setup() async {
    return setupRemoteConfig();
  }

  Future<RemoteConfig> setupRemoteConfig() async {
    remoteConfig = await RemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(fetchTimeout: Duration(seconds: 5), minimumFetchInterval: Duration(seconds: 5)));
    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.fetch();
      await remoteConfig.activate();
    } on Exception catch (exception) {
      // Fetch throttled.
      print(exception);
    } catch (exception) {
      print(
          'Unable to fetch remote config. Cached or default values will be '
              'used');
    }
    return remoteConfig;
  }

  String value(BuildContext context, String key) {
    String code = AppLocalizations.of(context).languageCode();
    String mainKey = code + '_' + key;

    try {
      if (remoteConfig.getBool(enabledUseMainKey)) {
        if (Platform.isIOS) {
          mainKey = 'main_' + mainKey;
        } else {
          mainKey = 'andr_main_' + mainKey;
        }
      } else {
        if (Platform.isIOS) {
          mainKey = 'config_' + mainKey;
        } else {
          mainKey = 'andr_config_' + mainKey;
        }
      }
      var value = remoteConfig.getString(mainKey);
      return value;
    } catch (NoSuchMethodError){
      return '';
    }

  }


  bool boolValue(String key) {
    return remoteConfig.getBool(enabledUseMainKey);
  }

}