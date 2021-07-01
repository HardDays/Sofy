import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sofy_new/models/api_article_articles_model.dart';
import 'package:sofy_new/models/api_article_topic_model.dart';
import 'package:sofy_new/models/favortes/api_fav_topics_answer_model.dart';
import 'package:sofy_new/providers/preferences_provider.dart';
import 'package:sofy_new/rest_api.dart';

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  ArticlesBloc({this.restApi}) : super(ArticlesStateLoading());
  final RestApi restApi;

  @override
  Stream<ArticlesState> mapEventToState(ArticlesEvent event) async* {
    if (event is ArticlesEventLoad) {
      yield ArticlesStateLoading();
      try {
        String userToken = await PreferencesProvider().getAnonToken();
        List<ApiArticlesModel> listOfArticles =
            await restApi.getNewArticlesWithoutCtx(token: userToken);
        List<ApiArticleTopicModel> listOfTopicsPopular =
            await restApi.getArticleTopicsPopularWithoutCtx(token: userToken);

        List<ApiArticlesModel> listOfPopularArticles =
            await restApi.getPopularArticlesWithoutCtx(token: userToken);
        List<ApiFavTopicsInfoModel> listOfFavoritesTopics =
            await restApi.getFavoritesTopicsWithoutCtx(token: userToken);
        // List<ApiArticleTopicModel> listOfArticleTopic =
        //     await restApi.getTopicsListWithoutCtx(token: userToken);

        List<ApiArticlesModel> femaleSexuality =
            await restApi.getArticlesWithoutCtx(21, token: userToken);
        List<ApiArticlesModel> interestingAboutSex =
            await restApi.getArticlesWithoutCtx(11, token: userToken);
        List<ApiArticlesModel> orgasms =
            await restApi.getArticlesWithoutCtx(13, token: userToken);

        yield ArticlesStateResult(
          listOfArticles: listOfArticles,
          listOfFavoritesTopics: listOfFavoritesTopics,
          listOfPopularArticles: listOfPopularArticles,
          listOfTopicsPopular: listOfTopicsPopular,
          femaleSexuality: femaleSexuality,
          interestingAboutSex: interestingAboutSex,
          orgasms: orgasms,
        );
      } catch(e) {
        yield ArticlesStateError('Ошибка загрузки');
      }
    }
    return;
  }
}

abstract class ArticlesState {}

class ArticlesStateLoading extends ArticlesState {}

class ArticlesStateResult extends ArticlesState {
  ArticlesStateResult({
    this.listOfArticles = const [],
    this.listOfFavoritesTopics = const [],
    this.listOfPopularArticles = const [],
    this.listOfTopicsPopular = const [],
    this.femaleSexuality = const [],
    this.interestingAboutSex = const [],
    this.orgasms = const [],
  });

  final List<ApiArticlesModel> listOfArticles;
  final List<ApiArticleTopicModel> listOfTopicsPopular;
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
