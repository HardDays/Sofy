import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sofy_new/models/api_article_replies.dart';
import 'package:sofy_new/models/api_profile_model.dart';
import 'package:sofy_new/providers/preferences_provider.dart';
import 'package:sofy_new/rest_api.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  CommentsBloc({this.restApi}) : super(CommentsStateLoading());
  final RestApi restApi;

  @override
  Stream<CommentsState> mapEventToState(CommentsEvent event) async* {
    if (event is CommentsEventLoad) {
      yield CommentsStateLoading();
      try {
        String userToken = await PreferencesProvider().getAnonToken();
        List<Reply> replies = (await restApi.getArticleRepliesWithoutCtx(
                event.articleId.toString(), event.sortBy,
                parentId: event.parentId > 0 ? event.parentId.toString() : '',
                token: userToken))
            .replies;
        List<ApiProfileModel> profiles = [];
        for (int i = 0; i < replies.length; i++) {
          if (!(profiles
                  .where((element) => element.id.toString() == replies[i].userId.toString())
                  .length >
              0))
            profiles.add(await restApi.getUserProfile(
                token: userToken, id: replies[0].userId));
        }

        yield CommentsStateResult(replies: replies, profiles: profiles);
      } catch (e) {
        yield CommentsStateError(error: 'Ошибка загрузки');
      }
    }
    return;
  }
}

abstract class CommentsState {}

class CommentsStateLoading extends CommentsState {}

class CommentsStateResult extends CommentsState {
  CommentsStateResult({this.replies = const [], this.profiles = const []});

  final List<Reply> replies;
  final List<ApiProfileModel> profiles;
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
