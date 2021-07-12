import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sofy_new/models/api_answers_details_model.dart';
import 'package:sofy_new/models/api_answers_info_model.dart';
import 'package:sofy_new/providers/preferences_provider.dart';
import 'package:sofy_new/rest_api.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  StoryBloc({this.restApi, this.articleId}) : super(StoryStateLoading());
  final RestApi restApi;
final int articleId;
  @override
  Stream<StoryState> mapEventToState(StoryEvent event) async* {
    String userToken = await PreferencesProvider().getAnonToken();
    if (event is StoryEventChangePage) {
      yield StoryStateLoading();
      try {
        ApiAnswersDetailsModel answersDetails = await restApi.getAnswersWithoutCtx(articleId: articleId, page: event.page, token: userToken);
        yield StoryStateResult(answersInfoModel: answersDetails.info, page: event.page);
      } catch (e) {
        yield StoryStateError(error: 'Ошибка загрузки');
      }
    }
    return;
  }
}

abstract class StoryState {}

class StoryStateLoading extends StoryState {}

class StoryStateResult extends StoryState {
  StoryStateResult({this.answersInfoModel, this.page = 0});

  final ApiAnswersInfoModel answersInfoModel;
  final int page;
}

class StoryStateError extends StoryState {
  StoryStateError({this.error = ''});

  final String error;
}

abstract class StoryEvent {}

class StoryEventChangePage extends StoryEvent {
  StoryEventChangePage(
      {this.page = 0});

  final int page;
}
