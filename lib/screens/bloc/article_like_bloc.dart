import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sofy_new/rest_api.dart';

class ArticleLikeBloc extends Bloc<ArticleLikeEvent, ArticleLikeState> {
  ArticleLikeBloc({this.restApi}) : super(ArticleLikeStateInit());
  final RestApi restApi;

  @override
  Stream<ArticleLikeState> mapEventToState(ArticleLikeEvent event) async* {
    if (event is ArticleLikeEventSetLike) {
      try {
        yield ArticleLikeStateSettedLike();
      } catch(e) {
        yield ArticleLikeStateError('Ошибка загрузки');
      }
    }
    return;
  }
}

abstract class ArticleLikeState {}

class ArticleLikeStateInit extends ArticleLikeState {}

class ArticleLikeStateSettedLike extends ArticleLikeState {
  // ArticleLikeStateSettedLike({
  // });
}

class ArticleLikeStateError extends ArticleLikeState {
  ArticleLikeStateError(this.error);

  String error = '';
}

abstract class ArticleLikeEvent {}

class ArticleLikeEventSetLike extends ArticleLikeEvent {}
