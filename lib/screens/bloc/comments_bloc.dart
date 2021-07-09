import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sofy_new/models/api_article_replies.dart';
import 'package:sofy_new/models/api_profile_model.dart';
import 'package:sofy_new/providers/preferences_provider.dart';
import 'package:sofy_new/rest_api.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  CommentsBloc({this.restApi}) : super(CommentsStateLoading());
  final RestApi restApi;
  int _sortBy;
  List<Reply> _replies = [];
  List<ApiProfileModel> _profiles = [];
  // double _scrollPosition = 0;
  // double get scrollPosition => _scrollPosition;
  // set scrollPosition(double val) => _scrollPosition = scrollPosition;

  @override
  Stream<CommentsState> mapEventToState(CommentsEvent event) async* {
    String userToken = await PreferencesProvider().getAnonToken();
    if (event is CommentsEventLoad) {
      _sortBy = event.sortBy;
      yield CommentsStateLoading();
      try {
        _replies = (await restApi.getArticleRepliesWithoutCtx(
                event.articleId.toString(), event.sortBy,
                parentId: event.parentId > 0 ? event.parentId.toString() : '',
                token: userToken))
            .replies;
        for (int i = 0; i < _replies.length; i++) {
          if (!(_profiles
                  .where((element) =>
                      element.id.toString() == _replies[i].userId.toString())
                  .length >
              0))
            _profiles.add(await restApi.getUserProfile(
                token: userToken, id: _replies[i].userId));
        }

        yield CommentsStateResult(replies: _replies, profiles: _profiles);
      } catch (e) {
        yield CommentsStateError(error: 'Ошибка загрузки');
      }
    }
    if (event is CommentsEventSend) {
      if (event.text != '' && event.articleId > 0) {
        yield CommentsStateLoading();
        bool wasSended = await restApi.postReplyWithoutCtx(
            articleId: event.articleId,
            content: event.text,
            parentId: event.parentId >= 0 ? event.parentId : 0,
            token: userToken);
        if (wasSended)
          this.add(CommentsEventLoad(
              articleId: event.articleId,
              parentId: event.parentId,
              sortBy: event.sortBy));
        else
          yield CommentsStateResult(replies: _replies, profiles: _profiles);
      }
    }
    if (event is CommentsEventLike) {
      bool wasSended = await restApi.likeReplyWithoutCtx(
          commentId: event.id, token: userToken);
      if (wasSended)
        for (int i = 0; i < _replies.length; i++) {
          if (_replies[i].id == event.id.toString()) {
            _replies[i].isLiked = "1";
            _replies[i].likesCount =
                (int.parse(_replies[i].likesCount) + 1).toString();
          }
        }
      yield CommentsStateResult(replies: _replies, profiles: _profiles, afterLikeDislike: true);
    }
    if (event is CommentsEventDislike) {
      bool wasSended = await restApi.deleteLikeReplyWithoutCtx(
          commentId: event.id, token: userToken);
      if (wasSended)
        for (int i = 0; i < _replies.length; i++) {
          if (_replies[i].id == event.id.toString()) {
            _replies[i].isLiked = "0";
            _replies[i].likesCount =
                (int.parse(_replies[i].likesCount) - 1).toString();
          }
        }
      yield CommentsStateResult(replies: _replies, profiles: _profiles, afterLikeDislike: true);
    }
    return;
  }
}

abstract class CommentsState {}

class CommentsStateLoading extends CommentsState {}

class CommentsStateResult extends CommentsState {
  CommentsStateResult({this.replies = const [], this.profiles = const [], this.afterLikeDislike = false});

  final List<Reply> replies;
  final List<ApiProfileModel> profiles;
  final bool afterLikeDislike;
}

class CommentsStateError extends CommentsState {
  CommentsStateError({this.error = ''});

  final String error;
}

abstract class CommentsEvent {}

class CommentsEventLoad extends CommentsEvent {
  CommentsEventLoad({this.articleId = 1, this.sortBy = 0, this.parentId = -1});

  final int articleId;
  final int sortBy;
  final int parentId;
}

class CommentsEventSend extends CommentsEvent {
  CommentsEventSend(
      {this.articleId = 1, this.text = '', this.parentId = 0, this.sortBy = 0});

  final int articleId;
  final String text;
  final int parentId;
  final int sortBy;
}

class CommentsEventLike extends CommentsEvent {
  CommentsEventLike({this.articleId = 1, this.parentId = 0, this.id = 0});

  final int id;
  final int articleId;
  final int parentId;
}

class CommentsEventDislike extends CommentsEvent {
  CommentsEventDislike({this.articleId = 1, this.parentId = 0, this.id = 0});

  final int id;
  final int articleId;
  final int parentId;
}
