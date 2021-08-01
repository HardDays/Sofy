import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sofy_new/helper/size_config.dart';
import 'package:sofy_new/models/api_article_details_info_model.dart';
import 'package:sofy_new/providers/preferences_provider.dart';
import 'package:sofy_new/rest_api.dart';
import 'package:sofy_new/screens/arcticle_details_screen.dart';

class ArticleDetailsBloc extends Bloc<ArticleDetailsEvent, ArticleDetailsState> {
  ArticleDetailsBloc() : super(ArticleDetailsStateLoading());
  final RestApi restApi = RestApi(systemLang: SizeConfig.lang);
  WidgetSysInfo widgetSysInfo = WidgetSysInfo();

  @override
  Stream<ArticleDetailsState> mapEventToState(ArticleDetailsEvent event) async* {
    if (event is ArticleDetailsEventLoad) {
      yield ArticleDetailsStateLoading();
      try {
        String userToken = await PreferencesProvider().getAnonToken();
        ApiArticleDetailsInfoModel articleDetails = await restApi.getArticleDetailsWithoutCtx(event.articleId.toString(), token: userToken);
        await precacheImage(CachedNetworkImageProvider(articleDetails.article.coverImg), event.context);
        // ApiProfileModel author = await restApi.getUserProfile(id: articleDetails.article.authorUserId, token: userToken);
        yield ArticleDetailsStateResult(articleDetails: articleDetails);
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
  ArticleDetailsStateResult({this.articleDetails});

  final ApiArticleDetailsInfoModel articleDetails;
}

class ArticleDetailsStateError extends ArticleDetailsState {
  ArticleDetailsStateError(this.error);

  String error = '';
}

abstract class ArticleDetailsEvent {
  const ArticleDetailsEvent();
}

class ArticleDetailsEventLoad extends ArticleDetailsEvent {
  ArticleDetailsEventLoad(this.context, {this.articleId});

  final BuildContext context;
  final int articleId;
}
