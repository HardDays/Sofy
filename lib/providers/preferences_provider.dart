import 'package:shared_preferences/shared_preferences.dart';
import 'package:sofy_new/constants/constants.dart';

class PreferencesProvider {
  static PreferencesProvider _instance;
  Future _initialized;
  SharedPreferences _preferences;

  factory PreferencesProvider() {
    if (_instance == null) {
      _instance = PreferencesProvider._();
    }
    return _instance;
  }

  PreferencesProvider._() {
    _initialized = _initPreferences();
  }

  Future _initPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future saveSessions() async {
    await _initialized;
    return await _preferences.setInt(KEY_SESSIONS, ((await getSessions())+1));
  }

  Future<int> getSessions() async {
    await _initialized;
    return _preferences.getInt(KEY_SESSIONS) ?? 0;
  }

  Future saveFavorites(List<String> favorites) async {
    await _initialized;
    return await _preferences.setStringList(KEY_FAVORITES, favorites);
  }

  Future saveFirstInit() async {
    await _initialized;
    return await _preferences.setBool(KEY_FIRST_INIT, false);
  }

  Future isFirstInit() async {
    await _initialized;
    return _preferences.getBool(KEY_FIRST_INIT) ?? true;
  }

  Future saveOrRemoveFavorite(String id) async {
    var favorites = await getFavoritesList();
    favorites.contains(id) ? favorites.remove(id) : favorites.add(id);
    return await saveFavorites(favorites);
  }

  Future<List<String>> getFavoritesList() async {
    await _initialized;
    return _preferences.getStringList(KEY_FAVORITES) ?? List();
  }

  Future saveDBVersion(int version) async {
    await _initialized;
    return await _preferences.setInt(KEY_DB_VERSION, version);
  }

  Future dbVersion() async {
    await _initialized;
    return _preferences.getInt(KEY_DB_VERSION) ?? -1;
  }

  Future saveUserId(String userId) async {
    await _initialized;
    return await _preferences.setString(KEY_USER_ID, userId);
  }

  Future getUserId() async {
    await _initialized;
    return _preferences.getString(KEY_USER_ID) ?? '';
  }

  Future saveUserName(String userName) async {
    await _initialized;
    return await _preferences.setString(KEY_USER_NAME, userName);
  }

  Future getUserName() async {
    await _initialized;
    return _preferences.getString(KEY_USER_NAME) ?? '';
  }

  Future getAvaNumber() async {
    await _initialized;
    return _preferences.getString(KEY_USER_AVA_NUMBER) ?? '';
  }

  Future getAvaBackground() async {
    await _initialized;
    return _preferences.getInt(KEY_USER_AVA_COLOR) ?? '';
  }

  Future saveUserMail(String userMail) async {
    await _initialized;
    return await _preferences.setString(KEY_USER_MAIL, userMail);
  }

  Future saveAvaNumber(String number) async {
    await _initialized;
    return await _preferences.setString(KEY_USER_AVA_NUMBER, number);
  }

  Future saveAvaBackground(int color) async {
    await _initialized;
    return await _preferences.setInt(KEY_USER_AVA_COLOR, color);
  }

  Future getUserMail() async {
    await _initialized;
    return _preferences.getString(KEY_USER_MAIL) ?? '';
  }

  Future saveUserPass(String userPass) async {
    await _initialized;
    return await _preferences.setString(KEY_USER_PASS, userPass);
  }

  Future getUserPass() async {
    await _initialized;
    return _preferences.getString(KEY_USER_PASS) ?? '';
  }

  Future saveUserPhoto(String userPhoto) async {
    await _initialized;
    return await _preferences.setString(KEY_USER_PHOTO, userPhoto);
  }

  Future getUserPhoto() async {
    await _initialized;
    return _preferences.getString(KEY_USER_PHOTO) ?? '';
  }

  Future saveUserToken(String userToken) async {
    await _initialized;
    return await _preferences.setString(KEY_USER_AUTH_TOKEN, userToken);
  }

  Future getUserToken() async {
    await _initialized;
    return _preferences.getString(KEY_USER_AUTH_TOKEN) ?? '';
  }

  Future logout() async {
    saveUserToken('');
    saveUserPhoto('');
    saveUserMail('');
    saveUserPass('');
    saveUserPass('');
    saveUserName('');
    saveAvaBackground(0);
    saveAvaNumber('');
  }


  Future saveAnonToken(String anonToken) async {
    await _initialized;
    return await _preferences.setString(KEY_ANON_AUTH_TOKEN, anonToken);
  }

  Future getAnonToken() async {
    await _initialized;
    return _preferences.getString(KEY_ANON_AUTH_TOKEN) ?? '';
  }

  Future saveAnonName(String anonName) async {
    await _initialized;
    return await _preferences.setString(KEY_ANON_NAME, anonName);
  }

  Future getAnonName() async {
    await _initialized;
    return _preferences.getString(KEY_ANON_NAME) ?? '';
  }
}
