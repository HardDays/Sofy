import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/providers/app_localizations.dart';

class SettingsInfoDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context).translate('not_vibrating'),
        style: TextStyle(
          fontFamily: 'Proxima Nova',
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.normal,
          fontSize: height / 52,
//          height: 1.44,
//          color: Colors.white,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            "OK",
            style: TextStyle(
              color: kAppPinkDarkColor,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
      elevation: 25,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: kAppPinkLightColor,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).translate('make_sure'),
            style: TextStyle(
              fontFamily: 'Proxima Nova',
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              fontSize: height / 60,
              height: 1.44,
//          color: Colors.white,
            ),
          ),
          getAdditionalText(context, height / 60),
        ],
      ),
    );
  }

  Widget getAdditionalText(BuildContext context, height) => Platform.isIOS
      ? Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              AppLocalizations.of(context).translate('not_vibrating_ios_1'),
              style: TextStyle(
                fontFamily: 'Proxima Nova',
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                fontSize: height,
                height: 1.44,
//          color: Colors.white,
              ),
            ),
            Text(
              AppLocalizations.of(context).translate('not_vibrating_ios_2'),
              style: TextStyle(
                fontFamily: 'Proxima Nova',
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                fontSize: height,
                height: 1.44,
//          color: Colors.white,
              ),
            ),
          ],
        )
      : Container();
}