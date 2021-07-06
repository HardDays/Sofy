import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sofy_new/models/api_article_variants_model.dart';
import 'package:sofy_new/providers/preferences_provider.dart';
import 'package:sofy_new/rest_api.dart';

class ArticleVoteBloc extends Bloc<ArticleVoteEvent, ArticleVoteState> {
  ArticleVoteBloc({this.restApi, this.variants})
      : super(ArticleVoteStateInit(variants: variants));
  final RestApi restApi;
  final List<ApiArticleVariantsModel> variants;

  @override
  Stream<ArticleVoteState> mapEventToState(ArticleVoteEvent event) async* {
    if (event is ArticleVoteEventInit) ArticleVoteStateInit(variants: variants);
    if (event is ArticleVoteEventSetVote) {
      try {
        for (int i = 0; i < variants.length; i++) {
          if (variants[i].id == event.variantId)
            variants[i].selected = true;
          else
            variants[i].selected = false;
        }
        yield ArticleVoteStateSettedVote(variants: variants);
      } catch (e) {
        yield ArticleVoteStateError('Ошибка загрузки');
      }
    }
    if (event is ArticleVoteEventVote) {
      try {
        String userToken = await PreferencesProvider().getAnonToken();
        for (int i = 0; i < variants.length; i++) {
          if (variants[i].selected) {
            await restApi.sendPollId(variants[i].id, token: userToken);
            yield ArticleVoteStatePostedVote(variants: variants);
          }
        }
      } catch (e) {
        yield ArticleVoteStateError('Ошибка загрузки');
      }
    }
    return;
  }
}

abstract class ArticleVoteState {
  ArticleVoteState({this.variants});

  final List<ApiArticleVariantsModel> variants;
}

class ArticleVoteStateInit extends ArticleVoteState {
  ArticleVoteStateInit({List<ApiArticleVariantsModel> variants})
      : super(variants: variants);
}

class ArticleVoteStateSettedVote extends ArticleVoteState {
  ArticleVoteStateSettedVote({List<ApiArticleVariantsModel> variants})
      : super(variants: variants);
}

class ArticleVoteStatePostedVote extends ArticleVoteState {
  ArticleVoteStatePostedVote({List<ApiArticleVariantsModel> variants})
      : super(variants: variants);
}

class ArticleVoteStateError extends ArticleVoteState {
  ArticleVoteStateError(this.error);

  String error = '';
}

abstract class ArticleVoteEvent {}

class ArticleVoteEventSetVote extends ArticleVoteEvent {
  ArticleVoteEventSetVote({this.variantId = 0});

  final int variantId;
}

class ArticleVoteEventInit extends ArticleVoteEvent {}

class ArticleVoteEventVote extends ArticleVoteEvent {}
