import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:sofy_new/constants/constants.dart';

import 'api_playlist_model.dart';

class PlaylistNameData extends ChangeNotifier {

  bool _inAdding = false;

  bool get isInAddingMode => _inAdding;


  int _currentPlaylistNameIndex = 0;

  void updateInAddingMode({bool flag}) {
    _inAdding = flag;
    notifyListeners();
  }

  int get currentPlaylistName {
    return _currentPlaylistNameIndex;
  }

  ///API

  List<ApiPlayListModel> _apiPlaylists;
  List<ApiPlayListModel> _apiPlaylistsForRecomendScreen;
  ApiPlayListModel _currentPlaylistItem;

  void updateCurrentPlaylistApi(ApiPlayListModel playlistItem, {bool notify = true}) {
    _currentPlaylistItem = playlistItem;
    if (notify) notifyListeners();
  }

  ApiPlayListModel getCurrentPlaylistNameApi() {
    return _currentPlaylistItem;
  }

  List<ApiPlayListModel> get apiPlaylistsForRecomendScreen =>
      _apiPlaylistsForRecomendScreen;

  ApiPlayListModel getPlaylistNameByIndexApi({int index}) {
    return _apiPlaylists[index];
  }

  ApiPlayListModel getPlaylistNameByIDApi({int id}) {
    return _apiPlaylists.firstWhere((value) => value.id == id, orElse: null);
  }

  ApiPlayListModel getCurrentPlaylistNameByIndexApi() {
    return _apiPlaylists[_currentPlaylistNameIndex];
  }

  void updateCurrentPlaylistNameIndexApi(int index, {bool notify = true}) {
    _currentPlaylistNameIndex = index;
    _currentPlaylistItem = _apiPlaylists[index];
    if (notify) notifyListeners();
  }

  void resetCurrentPlaylistNameIndexApi(int index) {
    if (_apiPlaylists != null && _apiPlaylists.isNotEmpty)
      updateCurrentPlaylistNameIndexApi(0);
  }

  UnmodifiableListView<ApiPlayListModel> get apiPlaylistNamesList {
    return UnmodifiableListView(_apiPlaylists);
  }

  UnmodifiableListView<ApiPlayListModel> getPlaylistsForRecomendScreenApi() {
    List<ApiPlayListModel> tempList = [];
    for (var playlist in _apiPlaylists) {
      if (playlist.id != standardPlaylistId)
        tempList.add(playlist);
    }
    return UnmodifiableListView(tempList);
  }

  bool isPlayListNullApi() {
    return _apiPlaylists == null;
  }

  int get playlistNamesCountApi {
    return _apiPlaylists != null ? _apiPlaylists.length : 0;
  }

  void addModelApi(ApiPlayListModel playlistName) {
    _apiPlaylists.add(playlistName);
    notifyListeners();
  }

  void updateListApi({List<ApiPlayListModel> list}) {
    if (_apiPlaylists != null) _apiPlaylists.clear();
    _apiPlaylists = list;
    if (list.isNotEmpty) {
      _apiPlaylistsForRecomendScreen = getPlaylistsForRecomendScreenApi();
      updateCurrentPlaylistApi(_apiPlaylistsForRecomendScreen[0]);
    } else
      _apiPlaylistsForRecomendScreen = list;
    notifyListeners();
  }

  void deleteModelApi(ApiPlayListModel playlistName) {
    _apiPlaylists.remove(playlistName);
    notifyListeners();
  }

  String getCurrentNameApi(String lang) {
    if (isPlayListNullApi())
      return 'Playlist Name';
    else
      return lang == 'ru ' ? getCurrentPlaylistNameApi().titleRu : getCurrentPlaylistNameApi().titleEn;
  }
}
