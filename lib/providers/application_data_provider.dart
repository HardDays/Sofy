import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:sofy_new/providers/preferences_provider.dart';
import 'package:sofy_new/helper/cache/cache_manager_helper.dart';
import 'package:sofy_new/rest_api.dart';

class ApplicationDataProvider {
  static void downloadedApplicationData(
      {@required BuildContext context,
      @required VoidCallback finishedDownloading}) async {
    String userToken = await PreferencesProvider().getAnonToken();
    print('======> userToken = $userToken');
    await RestApi().getPlaylists(context, token: userToken).then((values) {
      List<String> urls = values.map((m) => m.coverImg).toList();
      CacheManagerHelper.loadImages(urls, finishedDownloading: () {});
    });

    await RestApi().getVibrations(context, token: userToken).then((values) {
      List<String> urls = values.map((m) => m.coverImg).toList();
      CacheManagerHelper.loadImages(urls, finishedDownloading: () {
        finishedDownloading();
      });
    });
  }
}
