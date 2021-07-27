import 'dart:async';
import 'package:bloc/bloc.dart';
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

        List<ApiFavTopicsInfoModel> listOfFavoritesTopics = await restApi.getFavoritesTopicsWithoutCtx(token: userToken);

        List<ApiArticleTopicModel> listOfArticleTopic = await restApi.getTopicsListWithoutCtx(token: userToken);

        List<ApiArticlesModel> listOfArticles = await restApi.getNewArticlesWithoutCtx(token: userToken);

        List<ApiArticlesModel> listOfPopularArticles = await restApi.getPopularArticlesWithoutCtx(token: userToken);

        List<ApiArticlesModel> femaleSexuality = await restApi.getArticlesWithoutCtx(languageCode == 'ru' ? 21 : 22, token: userToken);

        List<ApiArticlesModel> interestingAboutSex = await restApi.getArticlesWithoutCtx(languageCode == 'ru' ? 11 : 12, token: userToken);

        List<ApiArticlesModel> orgasms = await restApi.getArticlesWithoutCtx(languageCode == 'ru' ? 13 : 14, token: userToken);

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
            popularCategories: pp);
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
      this.popularCategories = const []});

  final List<ApiArticlesModel> listOfArticles;
  final List<ApiArticleTopicModel> listOfTopicsPopular;
  final List<ApiArticleTopicModel> popularCategories;
  final List<ApiArticleTopicModel> listOfArticleTopic;
  final List<ApiArticlesModel> listOfPopularArticles;
  final List<ApiFavTopicsInfoModel> listOfFavoritesTopics;
  final List<ApiArticlesModel> femaleSexuality; // 21
  final List<ApiArticlesModel> interestingAboutSex; // 11
  final List<ApiArticlesModel> orgasms; // 13
}

class ArticlesStateError extends ArticlesState {
  ArticlesStateError(this.error);

  String error = '';
}

abstract class ArticlesEvent {}

class ArticlesEventLoad extends ArticlesEvent {}
