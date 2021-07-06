import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sofy_new/rest_api.dart';

class ArticleRatingBloc extends Bloc<ArticleRatingEvent, ArticleRatingState> {
  ArticleRatingBloc({this.restApi}) : super(ArticleRatingStateInit());
  final RestApi restApi;

  @override
  Stream<ArticleRatingState> mapEventToState(ArticleRatingEvent event) async* {
    if (event is ArticleRatingEventSetLike) {
      try {
        yield ArticleRatingStateSettedLike();
      } catch(e) {
        yield ArticleRatingStateError('Ошибка загрузки');
      }
    }
    return;
  }
}

abstract class ArticleRatingState {}

class ArticleRatingStateInit extends ArticleRatingState {}

class ArticleRatingStateSettedLike extends ArticleRatingState {
  // ArticleRatingStateSettedLike({
  // });
}

class ArticleRatingStateError extends ArticleRatingState {
  ArticleRatingStateError(this.error);

  String error = '';
}

abstract class ArticleRatingEvent {}

class ArticleRatingEventSetLike extends ArticleRatingEvent {}
