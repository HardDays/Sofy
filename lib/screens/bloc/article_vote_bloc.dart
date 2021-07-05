import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sofy_new/rest_api.dart';

class ArticleVoteBloc extends Bloc<ArticleVoteEvent, ArticleVoteState> {
  ArticleVoteBloc({this.restApi}) : super(ArticleVoteStateInit());
  final RestApi restApi;

  @override
  Stream<ArticleVoteState> mapEventToState(ArticleVoteEvent event) async* {
    if (event is ArticleVoteEventSetLike) {
      try {
        yield ArticleVoteStateSettedLike();
      } catch(e) {
        yield ArticleVoteStateError('Ошибка загрузки');
      }
    }
    return;
  }
}

abstract class ArticleVoteState {}

class ArticleVoteStateInit extends ArticleVoteState {}

class ArticleVoteStateSettedLike extends ArticleVoteState {
  // ArticleVoteStateSettedLike({
  // });
}

class ArticleVoteStateError extends ArticleVoteState {
  ArticleVoteStateError(this.error);

  String error = '';
}

abstract class ArticleVoteEvent {}

class ArticleVoteEventSetLike extends ArticleVoteEvent {}
