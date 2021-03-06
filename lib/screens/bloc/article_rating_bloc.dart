import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sofy_new/helper/size_config.dart';
import 'package:sofy_new/providers/preferences_provider.dart';
import 'package:sofy_new/rest_api.dart';

class ArticleRatingBloc extends Bloc<ArticleRatingEvent, ArticleRatingState> {
  ArticleRatingBloc({this.articleId}) : super(ArticleRatingStateInit());
  final RestApi restApi = RestApi(systemLang: SizeConfig.lang);
  final int articleId;
  bool voting = false;
  int _rating;

  @override
  Stream<ArticleRatingState> mapEventToState(ArticleRatingEvent event) async* {
    if (event is ArticleRatingEventSetRating) {
      _rating = event.rating;
      try {
        yield ArticleRatingStateSettedRating(rating: event.rating);
      } catch (e) {
        yield ArticleRatingStateError('Ошибка загрузки');
      }
    }
    if (event is ArticleRatingEventPostRating) {
      voting = true;
      yield ArticleRatingStateSettedRating(rating: event.rating);
      try {
        String userToken = await PreferencesProvider().getAnonToken();
        await restApi.sendArticleRating(articleId.toString(), event.rating, token: userToken);
        voting = false;
        yield ArticleRatingStatePostedRating(rating: event.rating);
      } catch (e) {
        yield ArticleRatingStateError('Ошибка загрузки');
      }
    }
    return;
  }
}

abstract class ArticleRatingState {
  ArticleRatingState({this.rating = 0});

  final int rating;
}

class ArticleRatingStateInit extends ArticleRatingState {
  ArticleRatingStateInit({this.rating = 0}) : super(rating: rating);

  final int rating;
}

class ArticleRatingStateSettedRating extends ArticleRatingState {
  ArticleRatingStateSettedRating({this.rating = 0}) : super(rating: rating);

  final int rating;
}

class ArticleRatingStatePostedRating extends ArticleRatingState {
  ArticleRatingStatePostedRating({this.rating = 0}) : super(rating: rating);

  final int rating;
}

class ArticleRatingStateError extends ArticleRatingState {
  ArticleRatingStateError(this.error);

  String error = '';
}

abstract class ArticleRatingEvent {}

class ArticleRatingEventSetRating extends ArticleRatingEvent {
  ArticleRatingEventSetRating({this.rating = 0});

  final int rating;
}

class ArticleRatingEventPostRating extends ArticleRatingEvent {
  ArticleRatingEventPostRating({this.rating = 0});

  final int rating;
}
