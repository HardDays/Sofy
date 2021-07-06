import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sofy_new/providers/preferences_provider.dart';
import 'package:sofy_new/rest_api.dart';

class ArticleRatingBloc extends Bloc<ArticleRatingEvent, ArticleRatingState> {
  ArticleRatingBloc({this.restApi, this.articleId})
      : super(ArticleRatingStateInit());
  final RestApi restApi;
  final int articleId;

  @override
  Stream<ArticleRatingState> mapEventToState(ArticleRatingEvent event) async* {
    if (event is ArticleRatingEventSetRating) {
      try {
        yield ArticleRatingStateSettedRating(rating: event.rating);
      } catch (e) {
        yield ArticleRatingStateError('Ошибка загрузки');
      }
    }
    if (event is ArticleRatingEventPostRating) {
      try {
        String userToken = await PreferencesProvider().getAnonToken();
        await restApi.sendArticleRating(articleId.toString(), event.rating, token:userToken);
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
