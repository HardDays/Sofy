import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sofy_new/models/api_articles_answer_model.dart';
import 'package:sofy_new/models/api_profile_model.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/providers/preferences_provider.dart';
import 'package:sofy_new/screens/user_profile.dart';

import 'constants/app_colors.dart';
import 'models/PlaylistNameData.dart';
import 'models/api_answers_details_model.dart';
import 'models/api_article_articles_model.dart';
import 'models/api_article_details_info_model.dart';
import 'models/api_article_details_model.dart';
import 'models/api_article_replies.dart';
import 'models/api_article_topic_answer_model.dart';
import 'models/api_article_topic_model.dart';
import 'models/api_playlist_answer_model.dart';
import 'models/api_playlist_model.dart';
import 'models/api_vibration_answer_model.dart';
import 'models/api_vibration_model.dart';
import 'models/favortes/api_fav_topics_answer_model.dart';
import 'models/playlist_data.dart';
import 'providers/player.dart';

class RestApi {
  RestApi({this.systemLang});

  //домен сервера
  static String serverUrl = 'https://api.enjoysofy.com/v1';

  //метод авторизации
  String userAuthUrl = '/auth/email';

  //метод восстановления по мылу
  String userRecoverUrl = '/recover/email';

  //регистрация пользователя
  String userRegisterUrl = '/register/email';

  //анонимная авторизация
  String userRegisterAnonUrl = '/register/anon';

  //вибрации
  String getVibrationsUrl = '/vibration/list';

  //плейлисты
  String getPlaylistsUrl = '/vibration/playlist/list';

  //список категорий
  String getTopicsListUrl = '/article-topic/list';

  //список популярных категорий
  String getArticleTopicsPopularListUrl = '/article-topic/list-popular';

  //список статей
  String getArticlesListUrl = '/article/list';

  //список новых статей
  String getNewArticlesListUrl = '/article/list-new';

  //список популярных статей
  String getPopularArticlesListUrl = '/article/list-popular';

  //детали статьи
  String getArticleDetailsUrl = '/article/view';

  //отправка результата голосования
  String userPollAddUrl = '/article/poll/add';

  //отправка ответа
  String userAnswerAddUrl = '/article/answer/add';

  //список ответов
  String getAnswersUrl = '/article/answer/public-list';

  //отравка оценки статьи
  String userArticleRatingUrl = '/article/rating';

  //отравка/удаление избранной категории
  String sendFavCategoryUrl = '/article-topic/favorite';

  //получение списка избранных категорий
  String getListFavCategoryUrl = '/article-topic/list-favorite';

  //фото профиля
  static String userProfilePhotoUrl = '/profile/avatar';

  //метод авторизации
  String userProfileUrl = '/profile/view';

  //метод получения списка сообщений статьи
  String getArticleRepliesUrl = '/article/reply/list';

  //метод отправки сообщения
  String sendArticleReplyUrl = '/article/reply/add';

  //метод лайка сообщения
  String likeArticleReplyUrl = '/article/reply/like';

  //анонимный вход
  Future<String> userAnon() async {
    String url = serverUrl + userRegisterAnonUrl;

    Response response = await Dio(BaseOptions(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      validateStatus: (_) => true,
    )).post(url,
        options: Options(
          headers: {"Content-Type": "application/json"},
        ));

    Map<String, dynamic> responseJson = json.decode(response.toString());
    String result = responseJson['result'].toString();

    if (result != 'error') {
      await PreferencesProvider()
          .saveAnonName(responseJson['info']['user']['username']);
      await PreferencesProvider()
          .saveAnonToken(responseJson['info']['token']['auth']['token']);
      return responseJson['info']['token']['auth']['token'];
    }
  }

  //авторизация пользователя
  userAuth(BuildContext context, String login, String pass, isFromReg) async {
    showLoaderDialog(context);

    String url = serverUrl + userAuthUrl;

    Response response = await Dio(BaseOptions(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      validateStatus: (_) => true,
    )).post(url,
        data: {"email": login, "password": pass},
        options: Options(
          headers: {"Content-Type": "application/json"},
        ));

    Navigator.pop(context);

    Map<String, dynamic> responseJson = json.decode(response.toString());
    String result = responseJson['result'].toString();

    if (result != 'error') {
      await PreferencesProvider()
          .saveUserId(responseJson['info']['user']['id'].toString());
      await PreferencesProvider()
          .saveUserName(responseJson['info']['user']['username']);
      await PreferencesProvider()
          .saveUserMail(responseJson['info']['user']['email']);
      await PreferencesProvider().saveUserPass(pass);
      await PreferencesProvider()
          .saveUserToken(responseJson['info']['token']['auth']['token']);
      if (isFromReg) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfileScreen(),
          ),
        );
      } else {
        Navigator.of(context).pop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfileScreen(),
          ),
        );
      }
    } else {
      Fluttertoast.showToast(
          msg: AppLocalizations.of(context).translate('login_error'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: kAppPinkDarkColor,
          textColor: kArticlesWhiteColor,
          fontSize: 12.0);
    }
  }

  //регистрация пользователя
  userReg(BuildContext context, String userName, String login, String pass,
      String rePass) async {
    showLoaderDialog(context);

    String url = serverUrl + userRegisterUrl;

    Response response = await Dio(BaseOptions(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      validateStatus: (_) => true,
    )).post(url,
        data: {
          "username": userName,
          "email": login,
          "password": pass,
          "password_repeat": rePass
        },
        options: Options(
          headers: {"Content-Type": "application/json"},
        ));

    Navigator.pop(context);

    Map<String, dynamic> responseJson = json.decode(response.toString());
    String result = responseJson['result'].toString();

    if (result != 'error') {
      userAuth(context, login, pass, true);
    } else {
      //парсер и вывод ошибок
      List<dynamic> errors = json.decode(json.encode(responseJson['error']));

      for (int i = 0; i < errors.length; i++) {
        Fluttertoast.showToast(
            msg: errors[i]['message'].toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: kAppPinkDarkColor,
            textColor: kArticlesWhiteColor,
            fontSize: 12.0);
      }
    }
  }

  //восстановление
  userRecover(BuildContext context, String mail) async {
    showLoaderDialog(context);

    String url = serverUrl + userRecoverUrl;

    Response response = await Dio(BaseOptions(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      validateStatus: (_) => true,
    )).post(url,
        data: {"email": mail},
        options: Options(
          headers: {"Content-Type": "application/json"},
        ));

    Navigator.pop(context);

    //Map<String, dynamic> responseJson = json.decode(response.toString());
    //String result = responseJson['result'].toString();

    //if (result != 'error') {}
  }

  showLoaderDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(kAppPinkDarkColor),
                strokeWidth: 2.0),
          );
        });
  }

  //Список плейлистов
  Future<List<ApiPlayListModel>> getPlaylists(BuildContext context,
      {String token}) async {
    Dio dio = new Dio();
    dio.options.headers["X-Api-Key"] = token;
    dio.interceptors.add(
        DioCacheManager(CacheConfig(baseUrl: serverUrl + getPlaylistsUrl))
            .interceptor);
    Response response = await dio.get(serverUrl + getPlaylistsUrl,
        options:
            buildCacheOptions(Duration(days: 1), maxStale: Duration(days: 7)));
    ApiPlayListAnswerModel apiPlayListAnswerModel =
        ApiPlayListAnswerModel.fromJson(response.data);
    //print(response.data);
    List<ApiPlayListModel> temp = List();
    if (apiPlayListAnswerModel != null &&
        apiPlayListAnswerModel.info != null &&
        apiPlayListAnswerModel.info.items != null &&
        apiPlayListAnswerModel.info.items.length > 0) {
      temp = apiPlayListAnswerModel.info.items;
    }
    if (temp.length == 0) {
      return getPlaylists(context, token: token);
    }

    if (temp.length != 0) {
      Provider.of<PlaylistNameData>(context, listen: false)
          .updateListApi(list: temp);
    } else {
      Provider.of<PlaylistNameData>(context, listen: false)
          .updateListApi(list: []);
    }
    return temp;
  }

  //Список вибраций
  Future<List<ApiVibrationModel>> getVibrations(BuildContext context,
      {String token}) async {
    Dio dio = new Dio();
    dio.options.headers["X-Api-Key"] = token;
    dio.interceptors.add(
        DioCacheManager(CacheConfig(baseUrl: serverUrl + getVibrationsUrl))
            .interceptor);
    Response response = await dio.get(serverUrl + getVibrationsUrl,
        options:
            buildCacheOptions(Duration(days: 1), maxStale: Duration(days: 7)));
    ApiVibrationAnswerModel apiVibrationAnswerModel =
        ApiVibrationAnswerModel.fromJson(response.data);
    //print(response.data);
    List<ApiVibrationModel> temp = List();
    if (apiVibrationAnswerModel != null &&
        apiVibrationAnswerModel.info != null &&
        apiVibrationAnswerModel.info.items != null &&
        apiVibrationAnswerModel.info.items.length > 0) {
      for (int i = 0; i < apiVibrationAnswerModel.info.items.length; i++) {
        /*if (Platform.isAndroid) {
          if (apiVibrationAnswerModel.info.items[i].isAndroidVisible == 1 &&
              apiVibrationAnswerModel.info.items[i].isTest == 0) {
            temp.add(apiVibrationAnswerModel.info.items[i]);
          }
        } else {
          if (apiVibrationAnswerModel.info.items[i].isIosVisible == 1 &&
              apiVibrationAnswerModel.info.items[i].isTest == 0) {
            temp.add(apiVibrationAnswerModel.info.items[i]);
          }
        }*/
        //print(apiVibrationAnswerModel.info.items[i].titleEn);
        temp.add(apiVibrationAnswerModel.info.items[i]);
      }
    }

    if (temp.length == 0) {
      return getVibrations(context, token: token);
    }
    if (temp.length != 0) {
      Provider.of<PlaylistData>(context, listen: false)
          .updateListApi(list: temp);
      //BlocProvider.of<PlayerScreenBloc>(context);
      Provider.of<Player>(context, listen: false)
          .updateCurrentPlayListModel(model: temp[0]);
    } else {
      Provider.of<PlaylistData>(context, listen: false).updateListApi(list: []);
    }

    return temp;
  }

  //Список категорий
  Future<List<ApiArticleTopicModel>> getTopicsList(BuildContext context,
      {String token}) async {
    String lang = AppLocalizations.of(context).languageCode();
    if (lang == 'ru') {
      lang = 'rus';
    } else {
      lang = 'eng';
    }
    String url = serverUrl + getTopicsListUrl + '?lang_code=' + lang;
    Dio dio = new Dio();
    dio.options.headers["X-Api-Key"] = token;
    dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: url)).interceptor);
    Response response = await dio.get(url,
        options:
            buildCacheOptions(Duration(days: 1), maxStale: Duration(days: 7)));
    ApiArticleTopicAnswerModel apiPlayListAnswerModel =
        ApiArticleTopicAnswerModel.fromJson(response.data);
    List<ApiArticleTopicModel> temp = List();
    if (apiPlayListAnswerModel != null &&
        apiPlayListAnswerModel.info != null &&
        apiPlayListAnswerModel.info.items != null &&
        apiPlayListAnswerModel.info.items.length > 0) {
      temp = apiPlayListAnswerModel.info.items;
    }
    return temp;
  }

  //Список категорий
  Future<List<ApiArticleTopicModel>> getTopicsListWithoutCtx(
      {String token}) async {
    String lang = 'eng';
    if (systemLang == 'ru')
      lang = 'rus';
    String url = serverUrl + getTopicsListUrl + '?lang_code=' + lang;
    Dio dio = new Dio();
    dio.options.headers["X-Api-Key"] = token;
    dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: url)).interceptor);
    Response response = await dio.get(url,
        options:
            buildCacheOptions(Duration(days: 1), maxStale: Duration(days: 7)));
    ApiArticleTopicAnswerModel apiPlayListAnswerModel =
        ApiArticleTopicAnswerModel.fromJson(response.data);
    List<ApiArticleTopicModel> temp = List();
    if (apiPlayListAnswerModel != null &&
        apiPlayListAnswerModel.info != null &&
        apiPlayListAnswerModel.info.items != null &&
        apiPlayListAnswerModel.info.items.length > 0) {
      temp = apiPlayListAnswerModel.info.items;
    }
    return temp;
  }

  //Список популярных категорий
  Future<List<ApiArticleTopicModel>> getArticleTopicsPopular(
      BuildContext context,
      {String token}) async {
    String lang = AppLocalizations.of(context).languageCode();
    if (lang == 'ru') {
      lang = 'rus';
    } else {
      lang = 'eng';
    }
    String url =
        serverUrl + getArticleTopicsPopularListUrl + '?lang_code=' + lang;
    Dio dio = new Dio();
    dio.options.headers["X-Api-Key"] = token;
    dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: url)).interceptor);
    Response response = await dio.get(url,
        options:
            buildCacheOptions(Duration(days: 1), maxStale: Duration(days: 7)));
    ApiArticleTopicAnswerModel apiPlayListAnswerModel =
        ApiArticleTopicAnswerModel.fromJson(response.data);
    List<ApiArticleTopicModel> temp = List();
    if (apiPlayListAnswerModel != null &&
        apiPlayListAnswerModel.info != null &&
        apiPlayListAnswerModel.info.items != null &&
        apiPlayListAnswerModel.info.items.length > 0) {
      temp = apiPlayListAnswerModel.info.items;
    }
    return temp;
  }

  //Список популярных категорий
  Future<List<ApiArticleTopicModel>> getArticleTopicsPopularWithoutCtx(
      {String token}) async {
    String lang = 'eng';
    if (systemLang == 'ru')
      lang = 'rus';
    String url =
        serverUrl + getArticleTopicsPopularListUrl + '?lang_code=' + lang;
    Dio dio = new Dio();
    dio.options.headers["X-Api-Key"] = token;
    dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: url)).interceptor);
    Response response = await dio.get(url,
        options:
            buildCacheOptions(Duration(days: 1), maxStale: Duration(days: 7)));
    ApiArticleTopicAnswerModel apiPlayListAnswerModel =
        ApiArticleTopicAnswerModel.fromJson(response.data);
    List<ApiArticleTopicModel> temp = List();
    if (apiPlayListAnswerModel != null &&
        apiPlayListAnswerModel.info != null &&
        apiPlayListAnswerModel.info.items != null &&
        apiPlayListAnswerModel.info.items.length > 0) {
      temp = apiPlayListAnswerModel.info.items;
    }
    return temp;
  }

  //Список статей по категории
  Future<List<ApiArticlesModel>> getArticles(
      BuildContext context, int categoryId,
      {String token}) async {
    String lang = AppLocalizations.of(context).languageCode();
    if (lang == 'ru') {
      lang = 'rus';
    } else {
      lang = 'eng';
    }
    String url = serverUrl +
        getArticlesListUrl +
        '?lang_code=' +
        lang +
        '&topic_id=' +
        categoryId.toString();
    Dio dio = new Dio();
    dio.options.headers["X-Api-Key"] = token;
    dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: url)).interceptor);
    Response response = await dio.get(url);
    ApiArticlesAnswerModel apiPlayListAnswerModel =
        ApiArticlesAnswerModel.fromJson(response.data, false);
    List<ApiArticlesModel> temp = List();
    if (apiPlayListAnswerModel != null &&
        apiPlayListAnswerModel.info != null &&
        apiPlayListAnswerModel.info.items != null &&
        apiPlayListAnswerModel.info.items.length > 0) {
      temp = apiPlayListAnswerModel.info.items;
    }
    return temp;
  }

  //Список статей по категории
  Future<List<ApiArticlesModel>> getArticlesWithoutCtx(
      int categoryId,
      {String token}) async {
    String lang = 'eng';
    if (systemLang == 'ru')
      lang = 'rus';
    String url = serverUrl +
        getArticlesListUrl +
        '?lang_code=' +
        lang +
        '&topic_id=' +
        categoryId.toString();
    Dio dio = new Dio();
    dio.options.headers["X-Api-Key"] = token;
    dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: url)).interceptor);
    Response response = await dio.get(url);
    ApiArticlesAnswerModel apiPlayListAnswerModel =
        ApiArticlesAnswerModel.fromJson(response.data, false);
    List<ApiArticlesModel> temp = List();
    if (apiPlayListAnswerModel != null &&
        apiPlayListAnswerModel.info != null &&
        apiPlayListAnswerModel.info.items != null &&
        apiPlayListAnswerModel.info.items.length > 0) {
      temp = apiPlayListAnswerModel.info.items;
    }
    return temp;
  }

  //Список новых статей
  Future<List<ApiArticlesModel>> getNewArticles(BuildContext context,
      {String token}) async {
    String lang = AppLocalizations.of(context).languageCode();
    if (lang == 'ru') {
      lang = 'rus';
    } else {
      lang = 'eng';
    }
    String url = serverUrl + getNewArticlesListUrl + '?lang_code=' + lang;
    Dio dio = new Dio();
    dio.options.headers["X-Api-Key"] = token;
    dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: url)).interceptor);
    Response response = await dio.get(url);
    ApiArticlesAnswerModel apiPlayListAnswerModel =
        ApiArticlesAnswerModel.fromJson(response.data, true);
    List<ApiArticlesModel> temp = List();
    if (apiPlayListAnswerModel != null &&
        apiPlayListAnswerModel.info != null &&
        apiPlayListAnswerModel.info.items != null &&
        apiPlayListAnswerModel.info.items.length > 0) {
      temp = apiPlayListAnswerModel.info.items;
    }
    return temp;
  }

  String systemLang;
  //Список новых статей BuildContext не нужен
  Future<List<ApiArticlesModel>> getNewArticlesWithoutCtx(
      {String token}) async {
    String lang = 'eng';
    if (systemLang == 'ru')
      lang = 'rus';
    String url = serverUrl + getNewArticlesListUrl + '?lang_code=' + lang;
    Dio dio = new Dio();
    dio.options.headers["X-Api-Key"] = token;
    dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: url)).interceptor);
    Response response = await dio.get(url);
    ApiArticlesAnswerModel apiPlayListAnswerModel =
        ApiArticlesAnswerModel.fromJson(response.data, true);
    List<ApiArticlesModel> temp = List();
    if (apiPlayListAnswerModel != null &&
        apiPlayListAnswerModel.info != null &&
        apiPlayListAnswerModel.info.items != null &&
        apiPlayListAnswerModel.info.items.length > 0) {
      temp = apiPlayListAnswerModel.info.items;
    }
    return temp;
  }

  //Список новых статей
  Future<List<ApiArticlesModel>> getPopularArticles(BuildContext context,
      {String token}) async {
    String lang = AppLocalizations.of(context).languageCode();
    if (lang == 'ru') {
      lang = 'rus';
    } else {
      lang = 'eng';
    }
    String url = serverUrl + getPopularArticlesListUrl + '?lang_code=' + lang;
    Dio dio = new Dio();
    dio.options.headers["X-Api-Key"] = token;
    dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: url)).interceptor);
    Response response = await dio.get(url,
        options:
            buildCacheOptions(Duration(days: 1), maxStale: Duration(days: 7)));
    ApiArticlesAnswerModel apiPlayListAnswerModel =
        ApiArticlesAnswerModel.fromJson(response.data, true);
    List<ApiArticlesModel> temp = List();
    if (apiPlayListAnswerModel != null &&
        apiPlayListAnswerModel.info != null &&
        apiPlayListAnswerModel.info.items != null &&
        apiPlayListAnswerModel.info.items.length > 0) {
      temp = apiPlayListAnswerModel.info.items;
    }
    return temp;
  }
  //Список новых статей
  Future<List<ApiArticlesModel>> getPopularArticlesWithoutCtx(
      {String token}) async {
    String lang = 'eng';
    if (systemLang == 'ru')
      lang = 'rus';
    String url = serverUrl + getPopularArticlesListUrl + '?lang_code=' + lang;
    Dio dio = new Dio();
    dio.options.headers["X-Api-Key"] = token;
    dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: url)).interceptor);
    Response response = await dio.get(url,
        options:
            buildCacheOptions(Duration(days: 1), maxStale: Duration(days: 7)));
    ApiArticlesAnswerModel apiPlayListAnswerModel =
        ApiArticlesAnswerModel.fromJson(response.data, true);
    List<ApiArticlesModel> temp = List();
    if (apiPlayListAnswerModel != null &&
        apiPlayListAnswerModel.info != null &&
        apiPlayListAnswerModel.info.items != null &&
        apiPlayListAnswerModel.info.items.length > 0) {
      temp = apiPlayListAnswerModel.info.items;
    }
    return temp;
  }

  //Детали статьи
  Future<ApiArticleDetailsInfoModel> getArticleDetails(
      BuildContext context, String articleId,
      {String token}) async {
    String url = serverUrl + getArticleDetailsUrl + '?id=' + articleId;

    Dio dio = new Dio();
    dio.options.headers["X-Api-Key"] = token;
    dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: url)).interceptor);
    Response response = await dio.get(url,
        options: buildCacheOptions(Duration(days: 1),
            maxStale: Duration(days: 7), forceRefresh: true));

    ApiArticleDetailsModel apiPlayListAnswerModel =
        ApiArticleDetailsModel.fromJson(response.data);
    ApiArticleDetailsInfoModel temp = ApiArticleDetailsInfoModel();
    if (apiPlayListAnswerModel != null && apiPlayListAnswerModel.info != null) {
      temp = apiPlayListAnswerModel.info;
    }
    return temp;
  }

  //Детали статьи
  Future<ApiArticleDetailsInfoModel> getArticleDetailsWithoutCtx(String articleId,
      {String token}) async {
    String url = serverUrl + getArticleDetailsUrl + '?id=' + articleId;

    Dio dio = new Dio();
    dio.options.headers["X-Api-Key"] = token;
    dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: url)).interceptor);
    Response response = await dio.get(url,
        options: buildCacheOptions(Duration(days: 1),
            maxStale: Duration(days: 7), forceRefresh: true));

    ApiArticleDetailsModel apiPlayListAnswerModel =
        ApiArticleDetailsModel.fromJson(response.data);
    ApiArticleDetailsInfoModel temp = ApiArticleDetailsInfoModel();
    if (apiPlayListAnswerModel != null && apiPlayListAnswerModel.info != null) {
      temp = apiPlayListAnswerModel.info;
    }
    return temp;
  }

  //анонимный вход
  Future<void> sendPollId(int id, {String token}) async {
    String url = serverUrl + userPollAddUrl;

    Response response = await Dio(BaseOptions(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      validateStatus: (_) => true,
    )).post(url,
        data: {"variant_id": id},
        options: Options(
          headers: {"X-Api-Key": token},
        ));

    Map<String, dynamic> responseJson = json.decode(response.toString());
    String result = responseJson['result'].toString();

    if (result != 'error') {}
  }

  //отправка ответа
  Future<void> sendAnswer(String id, int questionId, String text,
      {String token}) async {
    String url = serverUrl + userAnswerAddUrl;

    Response response = await Dio(BaseOptions(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      validateStatus: (_) => true,
    )).post(url,
        data: {
          "article_id": id,
          "question_id": questionId,
          "content": text,
        },
        options: Options(
          headers: {"X-Api-Key": token},
        ));

    Map<String, dynamic> responseJson = json.decode(response.toString());
    String result = responseJson['result'].toString();

    if (result != 'error') {}
  }

  //Список ответов
  Future<ApiAnswersDetailsModel> getAnswers(
      BuildContext context, String articleId, int page,
      {String token}) async {
    String url = serverUrl +
        getAnswersUrl +
        '?article_id=' +
        articleId +
        '&page=' +
        page.toString();

    Dio dio = new Dio();
    dio.options.headers["X-Api-Key"] = token;
    dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: url)).interceptor);
    Response response = await dio.get(url,
        options:
            buildCacheOptions(Duration(days: 1), maxStale: Duration(days: 7)));

    ApiAnswersDetailsModel apiPlayListAnswerModel =
        ApiAnswersDetailsModel.fromJson(response.data);
    ApiAnswersDetailsModel temp = ApiAnswersDetailsModel();
    if (apiPlayListAnswerModel != null && apiPlayListAnswerModel.info != null) {
      temp = apiPlayListAnswerModel;
    }
    return temp;
  }

  //отправка оценки статьи
  Future<void> sendArticleRating(String id, int rating, {String token}) async {
    String url = serverUrl + userArticleRatingUrl;

    Response response = await Dio(BaseOptions(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      validateStatus: (_) => true,
    )).post(url,
        data: {"article_id": id, "rating": rating},
        options: Options(
          headers: {"X-Api-Key": token},
        ));

    Map<String, dynamic> responseJson = json.decode(response.toString());
    String result = responseJson['result'].toString();

    if (result != 'error') {}
  }

  //отправка избранной категории
  Future<void> sendFavCategory(String id, {String token}) async {
    String url = serverUrl + sendFavCategoryUrl + '?id=' + id;

    Response response = await Dio(BaseOptions(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      validateStatus: (_) => true,
    )).post(url,
        data: {
          "id": id,
        },
        options: Options(
          headers: {"X-Api-Key": token},
        ));

    Map<String, dynamic> responseJson = json.decode(response.toString());
    String result = responseJson['result'].toString();

    if (result != 'error') {}
  }

  //удаление избранной категории
  Future<void> deleteFavCategory(String id, {String token}) async {
    String url = serverUrl + sendFavCategoryUrl + '?id=' + id;

    Response response = await Dio(BaseOptions(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      validateStatus: (_) => true,
    )).delete(url,
        data: {
          "id": id,
        },
        options: Options(
          headers: {"X-Api-Key": token},
        ));

    Map<String, dynamic> responseJson = json.decode(response.toString());
    String result = responseJson['result'].toString();

    if (result != 'error') {}
  }

  //Список новых статей
  Future<List<ApiFavTopicsInfoModel>> getFavoritesTopics(BuildContext context,
      {String token}) async {
    String lang = AppLocalizations.of(context).languageCode();
    if (lang == 'ru') {
      lang = 'rus';
    } else {
      lang = 'eng';
    }
    String url = serverUrl + getListFavCategoryUrl + '?lang_code=' + lang;

    Dio dio = new Dio();
    dio.options.headers["X-Api-Key"] = token;
    dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: url)).interceptor);
    Response response = await dio.get(url);

    ApiFavTopicsAnswerModel apiPlayListAnswerModel =
        ApiFavTopicsAnswerModel.fromJson(response.data);
    List<ApiFavTopicsInfoModel> temp = List();
    if (apiPlayListAnswerModel != null &&
        apiPlayListAnswerModel.info != null &&
        apiPlayListAnswerModel.info.length > 0) {
      temp = apiPlayListAnswerModel.info;
    }
    return temp;
  }

  //Список новых статей
  Future<List<ApiFavTopicsInfoModel>> getFavoritesTopicsWithoutCtx(
      {String token}) async {
    String lang = 'eng';
    if (systemLang == 'ru')
      lang = 'rus';
    String url = serverUrl + getListFavCategoryUrl + '?lang_code=' + lang;

    Dio dio = new Dio();
    dio.options.headers["X-Api-Key"] = token;
    dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: url)).interceptor);
    Response response = await dio.get(url);

    ApiFavTopicsAnswerModel apiPlayListAnswerModel =
        ApiFavTopicsAnswerModel.fromJson(response.data);
    List<ApiFavTopicsInfoModel> temp = List();
    if (apiPlayListAnswerModel != null &&
        apiPlayListAnswerModel.info != null &&
        apiPlayListAnswerModel.info.length > 0) {
      temp = apiPlayListAnswerModel.info;
    }
    return temp;
  }

  //именение данных профиля
  Future<bool> setUserProfile(
      BuildContext context, FormData image, String token) async {
    showLoaderDialog(context);
    String url = serverUrl + userProfilePhotoUrl;

    Response response = await Dio(BaseOptions(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      validateStatus: (_) => true,
    )).post(url,
        data: image,
        options: Options(
          headers: {"X-Api-Key": token},
        ));

    Map<String, dynamic> responseJson = json.decode(response.toString());
    print(response.toString());

    Navigator.pop(context);

    return true;
  }

  //авторизация пользователя
  Future<String> userProfile(
      BuildContext context, String id, String token) async {
    String url = serverUrl + userProfileUrl + '?id=' + id;

    Response response = await Dio(BaseOptions(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      validateStatus: (_) => true,
    )).get(url,
        options: Options(
          headers: {"X-Api-Key": token},
        ));

    Map<String, dynamic> responseJson = json.decode(response.toString());

    print("response = " + response.toString());
    print("cover img = " + responseJson['info']['cover_img']);
    await PreferencesProvider()
        .saveUserPhoto(responseJson['info']['cover_img']);
    return responseJson['info']['cover_img'];
  }

  //профиль пользователя
  Future<ApiProfileModel> getUserProfile({String id, String token}) async {
    String url = serverUrl + userProfileUrl + '?id=' + id;

    Response response = await Dio(BaseOptions(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      validateStatus: (_) => true,
    )).get(url,
        options: Options(
          headers: {"X-Api-Key": token},
        ));

    Map<String, dynamic> responseJson = json.decode(response.toString());

    return ApiProfileModel.fromJson(responseJson['info']);
  }

  //Список сообщений
  Future<Replies> getArticleReplies(
      BuildContext context, String articleId, int sort, String parentId,
      {String token}) async {
    String parent = parentId != null ? '&parent_id=$parentId' : '';
    String url = serverUrl +
        getArticleRepliesUrl +
        '?id=' +
        articleId +
        '&sort=' +
        sort.toString() +
        parent;
    print(url);
    Dio dio = new Dio();
    dio.options.headers["X-Api-Key"] = token;
    dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: url)).interceptor);
    Response response = await dio.get(url);
    print(response);

    Replies replies = Replies.fromJson(response.data);
    return replies;
  }

  //Список сообщений
  Future<Replies> getArticleRepliesWithoutCtx(String articleId, int sort,
      {String parentId, String token}) async {
    String parent = parentId != '' ? '&parent_id=$parentId' : '';
    String url = serverUrl +
        getArticleRepliesUrl +
        '?id=' +
        articleId +
        '&sort=' +
        sort.toString() +
        parent;
    Dio dio = new Dio();
    dio.options.headers["X-Api-Key"] = token;
    dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: url)).interceptor);
    Response response = await dio.get(url);
    Replies replies = Replies.fromJson(response.data);
    return replies;
  }

  //отправка сообщения
  Future<bool> postReply(BuildContext context, String content, String parentId,
      String articleId) async {
    showLoaderDialog(context);

    String token = await PreferencesProvider().getUserToken();

    if (token == '') {
      token = await PreferencesProvider().getAnonToken();
    }

    String url = serverUrl + sendArticleReplyUrl;

    Response response = await Dio(BaseOptions(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      validateStatus: (_) => true,
    )).post(url,
        data: {
          "content": content,
          "parent_id": parentId,
          "article_id": articleId
        },
        options: Options(
          headers: {"X-Api-Key": token},
        ));

    Navigator.pop(context);

    print(response.toString());

    Map<String, dynamic> responseJson = json.decode(response.toString());
    String result = responseJson['result'].toString();

    if (result != 'error') {
      return true;
    } else {
      return false;
    }
  }

  //отправка сообщения
  Future<bool> postReplyWithoutCtx(
      {String content, int parentId, int articleId, String token}) async {
    String url = serverUrl + sendArticleReplyUrl;

    Response response = await Dio(BaseOptions(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      validateStatus: (_) => true,
    )).post(url,
        data: {
          "content": content,
          "parent_id": parentId,
          "article_id": articleId
        },
        options: Options(
          headers: {"X-Api-Key": token},
        ));
    Map<String, dynamic> responseJson = json.decode(response.toString());
    String result = responseJson['result'].toString();
    if (result != 'error') {
      return true;
    } else {
      return false;
    }
  }

  //лайк сообщения
  Future<bool> likeReply(BuildContext context, int commentId) async {
    showLoaderDialog(context);

    String token = await PreferencesProvider().getUserToken();

    String url =
        serverUrl + likeArticleReplyUrl + '?id=' + commentId.toString();

    Response response = await Dio(BaseOptions(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      validateStatus: (_) => true,
    )).post(url,
        options: Options(
          headers: {"X-Api-Key": token},
        ));

    print(response.toString());

    Navigator.pop(context);

    Map<String, dynamic> responseJson = json.decode(response.toString());
    String result = responseJson['result'].toString();

    if (result != 'error') {
      return true;
    } else {
      return false;
    }
  }//лайк сообщения
  Future<bool> likeReplyWithoutCtx({int commentId, String token}) async {
    String url =
        serverUrl + likeArticleReplyUrl + '?id=' + commentId.toString();

    Response response = await Dio(BaseOptions(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      validateStatus: (_) => true,
    )).post(url,
        options: Options(
          headers: {"X-Api-Key": token},
        ));

    Map<String, dynamic> responseJson = json.decode(response.toString());
    String result = responseJson['result'].toString();

    if (result != 'error') {
      return true;
    } else {
      return false;
    }
  }

  //удалить лайк
  Future<bool> deleteLikeReply(BuildContext context, int commentId) async {
    showLoaderDialog(context);

    String token = await PreferencesProvider().getUserToken();

    String url =
        serverUrl + likeArticleReplyUrl + '?id=' + commentId.toString();

    Response response = await Dio(BaseOptions(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      validateStatus: (_) => true,
    )).delete(url,
        options: Options(
          headers: {"X-Api-Key": token},
        ));

    Navigator.pop(context);

    Map<String, dynamic> responseJson = json.decode(response.toString());
    String result = responseJson['result'].toString();

    if (result != 'error') {
      return true;
    } else {
      return false;
    }
  }

  //удалить лайк
  Future<bool> deleteLikeReplyWithoutCtx({int commentId, String token}) async {
    String url =
        serverUrl + likeArticleReplyUrl + '?id=' + commentId.toString();

    Response response = await Dio(BaseOptions(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      validateStatus: (_) => true,
    )).delete(url,
        options: Options(
          headers: {"X-Api-Key": token},
        ));

    Map<String, dynamic> responseJson = json.decode(response.toString());
    String result = responseJson['result'].toString();

    if (result != 'error') {
      return true;
    } else {
      return false;
    }
  }
}
