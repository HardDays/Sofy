import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofy_new/models/api_article_articles_model.dart';
import 'package:sofy_new/models/api_article_topic_model.dart';
import 'package:sofy_new/models/favortes/api_fav_topics_answer_model.dart';
import 'package:sofy_new/providers/preferences_provider.dart';
import 'package:sofy_new/rest_api.dart';

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  ArticlesBloc({this.restApi, this.languageCode}) : super(ArticlesStateLoading());
  final RestApi restApi;
  final String languageCode;

  @override
  Stream<ArticlesState> mapEventToState(ArticlesEvent event) async* {
    if (event is ArticlesEventLoad) {
      yield ArticlesStateLoading();
      try {
        String userToken = await PreferencesProvider().getAnonToken();

        List<ApiArticleTopicModel> listOfTopicsPopular = await restApi.getArticleTopicsPopularWithoutCtx(token: userToken);
        Future.wait(listOfTopicsPopular.map((e) => precacheImage(CachedNetworkImageProvider(e.coverImg), event.context)).toList());

        List<ApiFavTopicsInfoModel> listOfFavoritesTopics = await restApi.getFavoritesTopicsWithoutCtx(token: userToken);
        Future.wait(listOfFavoritesTopics.map((e) => precacheImage(CachedNetworkImageProvider(e.icon,), event.context)).toList());

        List<ApiArticleTopicModel> listOfArticleTopic = await restApi.getTopicsListWithoutCtx(token: userToken);
        Future.wait(listOfArticleTopic.map((e) => precacheImage(CachedNetworkImageProvider(e.coverImg), event.context)).toList());

        List<ApiArticlesModel> listOfArticles = await restApi.getNewArticlesWithoutCtx(token: userToken);
        Future.wait(listOfArticles.map((e) => precacheImage(CachedNetworkImageProvider(e.coverImg), event.context)).toList());

        List<ApiArticlesModel> listOfPopularArticles = await restApi.getPopularArticlesWithoutCtx(token: userToken);
        Future.wait(listOfPopularArticles.map((e) => precacheImage(CachedNetworkImageProvider(e.coverImg), event.context)).toList());

        List<ApiArticlesModel> femaleSexuality = await restApi.getArticlesWithoutCtx(languageCode == 'ru' ? 21 : 22, token: userToken);
        Future.wait(femaleSexuality.map((e) => precacheImage(CachedNetworkImageProvider(e.coverImg), event.context)).toList());

        List<ApiArticlesModel> interestingAboutSex = await restApi.getArticlesWithoutCtx(languageCode == 'ru' ? 11 : 12, token: userToken);
        Future.wait(interestingAboutSex.map((e) => precacheImage(CachedNetworkImageProvider(e.coverImg), event.context)).toList());

        List<ApiArticlesModel> orgasms = await restApi.getArticlesWithoutCtx(languageCode == 'ru' ? 13 : 14, token: userToken);
        Future.wait(orgasms.map((e) => precacheImage(CachedNetworkImageProvider(e.coverImg), event.context)).toList());


        List<ApiArticlesModel> wmdta = await restApi.getArticlesWithoutCtx(languageCode == 'ru' ? 19 : 20, token: userToken);
        List<ApiArticlesModel> sip = await restApi.getArticlesWithoutCtx(languageCode == 'ru' ? 27 : 28, token: userToken);
        List<ApiArticlesModel> tin = await restApi.getArticlesWithoutCtx(languageCode == 'ru' ? 29 : 30, token: userToken);
        List<ApiArticlesModel> usd = await restApi.getArticlesWithoutCtx(languageCode == 'ru' ? 17 : 18, token: userToken);

        List<ApiArticleTopicModel> pp = [];

        for (int i = 0; i < (listOfTopicsPopular.length > 4 ? 4 : listOfTopicsPopular.length); i++) pp.add(listOfTopicsPopular[i]);

        yield ArticlesStateResult(
            listOfArticles: listOfArticles,
            listOfFavoritesTopics: listOfFavoritesTopics,
            listOfPopularArticles: listOfPopularArticles,
            listOfTopicsPopular: listOfTopicsPopular,
            femaleSexuality: femaleSexuality,
            interestingAboutSex: interestingAboutSex,
            listOfArticleTopic: listOfArticleTopic,
            orgasms: orgasms,
            popularCategories: pp,
            wmdta: wmdta,
            sip: sip,
            tin: tin,
            usd: usd
        );
      } catch (e) {
        yield ArticlesStateError('Ошибка загрузки');
      }
    }
    return;
  }
}

abstract class ArticlesState {}

class ArticlesStateLoading extends ArticlesState {}

class ArticlesStateResult extends ArticlesState {
  ArticlesStateResult(
      {this.listOfArticles = const [],
      this.listOfFavoritesTopics = const [],
      this.listOfArticleTopic = const [],
      this.listOfPopularArticles = const [],
      this.listOfTopicsPopular = const [],
      this.femaleSexuality = const [],
      this.interestingAboutSex = const [],
      this.orgasms = const [],
      this.popularCategories = const [],
        this.wmdta = const [],
        this.sip = const [],
        this.tin = const [],
        this.usd = const []
      });

  final List<ApiArticlesModel> listOfArticles;
  final List<ApiArticleTopicModel> listOfTopicsPopular;
  final List<ApiArticleTopicModel> popularCategories;
  final List<ApiArticleTopicModel> listOfArticleTopic;
  final List<ApiArticlesModel> listOfPopularArticles;
  final List<ApiFavTopicsInfoModel> listOfFavoritesTopics;
  final List<ApiArticlesModel> femaleSexuality; // 21
  final List<ApiArticlesModel> interestingAboutSex; // 11
  final List<ApiArticlesModel> orgasms; // 13
  final List<ApiArticlesModel> wmdta;
  final List<ApiArticlesModel> sip;
  final List<ApiArticlesModel> tin;
  final List<ApiArticlesModel> usd;
}

class ArticlesStateError extends ArticlesState {
  ArticlesStateError(this.error);

  String error = '';
}

abstract class ArticlesEvent {
  const ArticlesEvent();
}

class ArticlesEventLoad extends ArticlesEvent {
  final BuildContext context;
  const ArticlesEventLoad(this.context);
}
