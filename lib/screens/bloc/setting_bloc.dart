import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:share/share.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingBloc {
  void launchURL(String toMailId) async {
    var url = 'mailto:$toMailId';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void shareApp({BuildContext context}) async {
    String appLink = '';
    final RenderBox box = context.findRenderObject();
    if (Platform.isIOS) {
      appLink = AppLocalizations.of(context).translate('share_text_ios');
    }
    if (Platform.isAndroid) {
      appLink = AppLocalizations.of(context).translate('share_text_android');
    }

    Share.share(appLink,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  void shareArticle(String articleName, {BuildContext context}) async {
    String appLink = '';
    final RenderBox box = context.findRenderObject();
    if (Platform.isIOS) {
      appLink = AppLocalizations.of(context).translate('share_article_ios');
    }
    if (Platform.isAndroid) {
      appLink = AppLocalizations.of(context).translate('share_article_android');
    }

    Share.share(articleName + "\n\n" + appLink,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
