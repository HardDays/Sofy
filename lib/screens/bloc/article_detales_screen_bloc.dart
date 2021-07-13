import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sofy_new/models/api_article_details_info_model.dart';
import 'package:sofy_new/models/api_profile_model.dart';
import 'package:sofy_new/providers/preferences_provider.dart';
import 'package:sofy_new/rest_api.dart';
import 'package:sofy_new/screens/arcticle_details_screen.dart';

class ArticleDetailsBloc
    extends Bloc<ArticleDetailsEvent, ArticleDetailsState> {
  ArticleDetailsBloc({this.restApi}) : super(ArticleDetailsStateLoading());
  final RestApi restApi;
  WidgetSysInfo widgetSysInfo = WidgetSysInfo();

  @override
  Stream<ArticleDetailsState> mapEventToState(
      ArticleDetailsEvent event) async* {
    if (event is ArticleDetailsEventLoad) {
      yield ArticleDetailsStateLoading();
      try {
        String userToken = await PreferencesProvider().getAnonToken();
        ApiArticleDetailsInfoModel articleDetails = await restApi
            .getArticleDetailsWithoutCtx(event.articleId.toString(),
                token: userToken);
        ApiProfileModel author = await restApi.getUserProfile(
            id: articleDetails.article.authorUserId, token: userToken);
        yield ArticleDetailsStateResult(articleDetails: articleDetails, author: author);
      } catch (e) {
        yield ArticleDetailsStateError('Ошибка загрузки');
      }
    }
    return;
  }
}

abstract class ArticleDetailsState {}

class ArticleDetailsStateLoading extends ArticleDetailsState {}

class ArticleDetailsStateResult extends ArticleDetailsState {
  ArticleDetailsStateResult({
    this.articleDetails,
    this.author,
  });

  final ApiArticleDetailsInfoModel articleDetails;
  final ApiProfileModel author;
}

class ArticleDetailsStateError extends ArticleDetailsState {
  ArticleDetailsStateError(this.error);

  String error = '';
}

abstract class ArticleDetailsEvent {}

class ArticleDetailsEventLoad extends ArticleDetailsEvent {
  ArticleDetailsEventLoad({this.articleId});

  final int articleId;
}
