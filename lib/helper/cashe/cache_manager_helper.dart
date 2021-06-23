
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheManagerHelper {

  static Future loadImageToMemory(String url) async {
    DefaultCacheManager cacheManager = DefaultCacheManager();
    return cacheManager.getSingleFile(url);
  }

  static void loadImages(List<String> urls, {VoidCallback finishedDownloading}) {
    var filter = urls.where((element) {
      var urlPattern = r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
      return new RegExp(urlPattern, caseSensitive: false).hasMatch(element);
    }).toList();

    if (filter.length == 0) {
      finishedDownloading();
      return;
    }
    var totalCount = filter.length;

    filter.forEach((element) {
        loadImageToMemory(element).then((value) {
          totalCount--;
          if (totalCount <= 0) {
            finishedDownloading();
          }
        }).catchError((onError) {
          totalCount--;
          if (totalCount <= 0) {
            finishedDownloading();
          }
        });
    });
  }

}