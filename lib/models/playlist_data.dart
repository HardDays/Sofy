import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:sofy_new/models/subscribe_data.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/providers/preferences_provider.dart';

import 'api_vibration_model.dart';

class PlaylistData extends ChangeNotifier {
  int _swiperAnimationDuration = 500;
  bool _inAdding = false;
  int _currentVibroIndex = 0;

  bool get isInAddingMode => _inAdding;

  int get swiperAnimationDuration => _swiperAnimationDuration;

  void updateInAddingMode({bool flag}) {
    _inAdding = flag;
    notifyListeners();
  }

  int get currentVibrationIndex {
    return _currentVibroIndex;
  }

  void updateSwiperAnimationDuration({int duration, bool notify = true}) {
    _swiperAnimationDuration = duration;
    if (notify) notifyListeners();
  }

  ///API
  List<ApiVibrationModel> _playListApi;
  List<ApiVibrationModel> _favoritesApi = [];
  List<ApiVibrationModel> _vibrosByPlaylistIdApi = [];
  ApiVibrationModel _currentPlayListModelApi;

  ApiVibrationModel get currentPlayListModelApi => _currentPlayListModelApi;

  List<ApiVibrationModel> get favoritesApi => _favoritesApi;

  int get favoritesCountApi {
    return _favoritesApi.length;
  }

  void updateCurrentPlayListModelApi(
      {ApiVibrationModel model, bool notify = true}) {
    _currentPlayListModelApi = model;
    if (notify) notifyListeners();
  }

  ApiVibrationModel getPlaylistModelByIndexApi(
      {BuildContext context, int index}) {
    return getPlayListApi(context)[index];
  }

  ApiVibrationModel getCurrentPlaylistModelApi(BuildContext context) {
    return getPlayListApi(context)[_currentVibroIndex];
  }

  void updateCurrentVibroIndexApi(int index, {bool notify = true}) {
    _currentVibroIndex = index;
    if (notify) notifyListeners();
  }

  UnmodifiableListView<ApiVibrationModel> getPlayListApi(BuildContext context) {
    if (Provider.of<SubscribeData>(context, listen: false).isAppPurchase) {
      return UnmodifiableListView(_playListApi);
    }
    var list =
        _playListApi.where((element) => element.isTrial == true).toList();
    return UnmodifiableListView(list);
  }

  UnmodifiableListView<ApiVibrationModel> get vibrosByPlayListIdApi {
    return UnmodifiableListView(_vibrosByPlaylistIdApi);
  }

  bool isPlayListNullApi(BuildContext context) {
    return getPlayListApi(context) == null;
  }

  int getPlayListCountApi(BuildContext context) {
    return getPlayListApi(context) != null ? getPlayListApi(context).length : 0;
  }

  void addModelApi(ApiVibrationModel playListModel) {
    _playListApi.add(playListModel);
    notifyListeners();
  }

  void updateListApi({BuildContext context, List<ApiVibrationModel> list}) {
    if (_playListApi != null) _playListApi.clear();
    _playListApi = list;
    notifyListeners();
    checkForFavoritesApi(context);
  }

  void deleteModelApi(ApiVibrationModel playListModel) {
    _playListApi.remove(playListModel);
    notifyListeners();
  }

  String getCurrentVibrationNameApi(BuildContext context) {
    if (isPlayListNullApi(context))
      return null;
    else
      return AppLocalizations.of(context).languageCode() == 'ru' ? getCurrentPlaylistModelApi(context).titleRu : getCurrentPlaylistModelApi(context).titleEn;
  }

  void updateVibrosByPlaylistIdApi({int playlistId, bool notify = true}) {
    _vibrosByPlaylistIdApi.clear();
    List<ApiVibrationModel> tempList = [];
    for (var vibro in _playListApi)
      if (vibro.parentPlaylistId == playlistId) tempList.add(vibro);

    _vibrosByPlaylistIdApi = tempList;
    if (notify) notifyListeners();
  }

  void updateVibrosByFavoritesApi({bool notify = true}) {
    _vibrosByPlaylistIdApi.clear();
    List<ApiVibrationModel> tempList = [];
    for (var vibro in _favoritesApi) tempList.add(vibro);
    _vibrosByPlaylistIdApi = tempList;
    if (notify) notifyListeners();
  }

  Future checkForFavoritesApi(BuildContext context) async {
    if (getPlayListApi(context) == null || getPlayListApi(context).isEmpty)
      return;
    var favorites = await PreferencesProvider().getFavoritesList();
    zeroingAllFavoritesApi();
    if (favorites == null || favorites.isEmpty) {
      notifyListeners();
      return;
    }

    for (String id in favorites)
      _playListApi.forEach((vibro) {
        if (vibro.dateCreated.toString() == id) {
          vibro.favorite = true;
          _favoritesApi.add(vibro);
        }
      });
    notifyListeners();
  }

  void zeroingAllFavoritesApi() {
    for (var vibro in _playListApi) vibro.favorite = false;
    _favoritesApi.clear();
  }
}
