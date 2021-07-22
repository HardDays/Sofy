import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/config_const.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/size_config.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/rest_api.dart';
import 'package:sofy_new/screens/bloc/article_detales_screen_bloc.dart';
import 'package:sofy_new/screens/bloc/comments_bloc.dart';
import 'package:sofy_new/widgets/articles/article_author_desciption.dart';
import 'package:sofy_new/widgets/articles/article_details_skeletion.dart';
import 'package:sofy_new/widgets/articles/article_rating.dart';
import 'package:sofy_new/widgets/articles/article_question.dart';
import 'package:sofy_new/widgets/articles/article_vote.dart';
import 'package:sofy_new/widgets/articles/sofy_button.dart';

import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sofy_new/models/api_article_poll_model.dart';
import 'package:sofy_new/widgets/comments/comments.dart';
import 'package:sofy_new/widgets/fullscreen_preloader.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../rest_api.dart';
import 'bloc/analytics.dart';
import 'bloc/setting_bloc.dart';

class ArticleDetailsScreen extends StatelessWidget {
  ArticleDetailsScreen({Key key, this.articleId = 100}) : super(key: key);
  final int articleId;

  double radius = 25;

  final SettingBloc _bloc = SettingBloc();

  var linearGradientColors = const [
    Color(0xFFFDB0C1),
    Color(0xFFFF95AC),
  ];

  final scroll = ValueNotifier<double>(0);

  Color appBar = ArticleDetailsColors.TransparentColor;

  Color shareButton = ArticleDetailsColors.ShareButtonColor;

  Color backButton = ArticleDetailsColors.BackButtonColor;

  Color textColor = ArticleDetailsColors.TextColorTransparentColor;

  Color dividerColor = ArticleDetailsColors.DividerColorTransparentColor;

  ApiArticlePollModel apiArticlePollModel;

  bool scrollListener(ScrollNotification scrollNotification) {
    double height = SizeConfig.screenHeight;
    scroll.value = scrollNotification.metrics.pixels / height / SizeConfig.blockSizeHorizontal;
    if (scrollNotification.metrics.pixels > height / 8.21) {
      if (appBar == Colors.transparent) {
        appBar = kArticlesDetailsAppBarColor;
        shareButton = kArticlesPopularColor;
        backButton = kArticlesPopularColor;
        dividerColor = kArticlesDetailsNotifColor.withOpacity(0.15);
        Future.delayed(Duration(milliseconds: 100), () {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        });
      }
    } else {
      if (appBar == kArticlesDetailsAppBarColor) {
        Future.delayed(Duration(milliseconds: 100), () {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        });
        appBar = Colors.transparent;
        shareButton = kArticlesWhiteColor;
        backButton = kArticlesWhiteColor;
        textColor = Colors.transparent;
        dividerColor = Colors.transparent;
      }
    }
    if (scrollNotification.metrics.pixels > height / 2.61) {
      if (textColor == Colors.transparent) {
        textColor = kArticlesPopularColor;
      }
    } else {
      if (textColor == kArticlesPopularColor) {
        textColor = Colors.transparent;
      }
    }
    return true;
  }

  final _commentsKey = GlobalKey();

  final _questionsKey = GlobalKey();
  final _questionsKeyVD = GlobalKey();

  ScrollController _controller = ScrollController();

  bool _articleWasReaded = false;

  @override
  Widget build(BuildContext context) {
    double height = SizeConfig.screenHeight;
    double width = SizeConfig.screenWidth;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider.value(
        value: ArticleDetailsBloc(restApi: RestApi(systemLang: AppLocalizations.of(context).locale.languageCode))..add(ArticleDetailsEventLoad(articleId: articleId)),
        child: BlocBuilder<ArticleDetailsBloc, ArticleDetailsState>(
          builder: (context, state) {
            if (state is ArticleDetailsStateResult) {
              return NotificationListener<ScrollNotification>(
                  onNotification: scrollListener,
                  child: Stack(
                    children: [
                      Scrollbar(
                        child: SingleChildScrollView(
                          controller: _controller,
                          physics: const ClampingScrollPhysics(),
                          child: Container(
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: 390 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                      width: width,
                                      child: ExtendedImage.network(
                                        state.articleDetails.article.coverImg,
                                        fit: BoxFit.cover,
                                        cache: true,
                                      ),
                                    ),
                                    Visibility(
                                      visible: isAuthorEnabled,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 366 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(radius), topRight: Radius.circular(radius)),
                                          child: Stack(
                                            alignment: Alignment.topCenter,
                                            children: [
                                              Container(
                                                height: 60,
                                                width: width,
                                                color: Colors.white,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(21 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                                    21 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical, 21 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical, 0),
                                                child: ArticleAuthorDescription(author: state.author),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: isAuthorEnabled
                                              ? 426 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical
                                              : 386 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical),
                                      child: Stack(
                                        alignment: Alignment.topCenter,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.fromLTRB(21 / Layout.width * Layout.multiplier * SizeConfig.blockSizeHorizontal,
                                                26 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical, 21 / Layout.width * Layout.multiplier * SizeConfig.blockSizeHorizontal, 0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  state.articleDetails.article.title,
                                                  style: TextStyle(
                                                      fontFamily: Fonts.Roboto,
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 24 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                                      color: ArticlesColors.HeaderTextColor),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 25 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                                      bottom: 8 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      SofyButton(
                                                        width: isCommentsEnabled
                                                            ? width / 2 - 30/Layout.width * Layout.multiplier * SizeConfig.blockSizeHorizontal
                                                            : width - 42/ Layout.width * Layout.multiplier * SizeConfig.blockSizeHorizontal,
                                                        label: AppLocalizations.of(context).translate('questions_btn'),
                                                        callback: () {
                                                          Analytics().sendEventReports(
                                                            event: EventsOfAnalytics.questions_btn_click,
                                                            attr: {
                                                              'name': AppLocalizations.of(context).translate('questions_btn'),
                                                              'id': articleId,
                                                            },
                                                          );
                                                          final RenderBox questions = _questionsKey.currentContext.findRenderObject();
                                                          final sizeQuestions = questions.localToGlobal(Offset.zero);
                                                          _controller.animateTo(sizeQuestions.dy - height / 8.21 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                                              duration: Duration(milliseconds: 350), curve: Curves.ease);
                                                        },
                                                      ),
                                                      Visibility(
                                                        visible: isCommentsEnabled,
                                                        child: SofyButton(
                                                            width: width / 2 - 30/Layout.width * Layout.multiplier * SizeConfig.blockSizeHorizontal,
                                                            label: AppLocalizations.of(context).translate('comments_btn'),
                                                            callback: () {
                                                              Analytics().sendEventReports(
                                                                event: EventsOfAnalytics.comments_btn_click,
                                                                attr: {
                                                                  'name': AppLocalizations.of(context).translate('comments_btn'),
                                                                  'id': articleId,
                                                                },
                                                              );
                                                              final RenderBox comments = _commentsKey.currentContext.findRenderObject();
                                                              final sizeComments = comments.localToGlobal(Offset.zero);
                                                              _controller.animateTo(sizeComments.dy - height / 8.21 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                                                  duration: Duration(milliseconds: 350), curve: Curves.ease);
                                                            }),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Html(
                                                  style: {
                                                    "p": Style(
                                                        wordSpacing: 5,
                                                        lineHeight: LineHeight.number(1.5),
                                                        fontFamily: Fonts.HindGuntur,
                                                        fontStyle: FontStyle.normal,
                                                        fontSize: FontSize(height / 57.73),
                                                        color: kArticlesDetailsScreenColor),
                                                    "strong": Style(
                                                        wordSpacing: 5,
                                                        lineHeight: LineHeight.number(1.6),
                                                        fontFamily: Fonts.HindGuntur,
                                                        fontWeight: FontWeight.bold,
                                                        fontStyle: FontStyle.normal,
                                                        fontSize: FontSize(height / 50.7),
                                                        color: kArticlesDetailsScreenColor),
                                                    "h1": Style(
                                                        wordSpacing: 5,
                                                        lineHeight: LineHeight.number(1.7),
                                                        fontFamily: Fonts.HindGuntur,
                                                        fontWeight: FontWeight.w600,
                                                        fontStyle: FontStyle.normal,
                                                        fontSize: FontSize(height / 50.7),
                                                        color: kArticlesDetailsScreenColor),
                                                    "li": Style(
                                                        wordSpacing: 5,
                                                        lineHeight: LineHeight.number(1.5),
                                                        fontFamily: Fonts.HindGuntur,
                                                        fontStyle: FontStyle.normal,
                                                        fontSize: FontSize(height / 57.73),
                                                        color: kArticlesDetailsScreenColor),
                                                    "u": Style(
                                                        wordSpacing: 5,
                                                        lineHeight: LineHeight.number(1.7),
                                                        fontFamily: Fonts.HindGuntur,
                                                        fontStyle: FontStyle.normal,
                                                        fontSize: FontSize(height / 57.73),
                                                        color: kArticlesDetailsScreenColor),
                                                  },
                                                  data: state.articleDetails.article.content != null ? state.articleDetails.article.content : '',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                VisibilityDetector(
                                  key: _questionsKeyVD,
                                  child: ArticleVote(poll: state.articleDetails.article.apiArticlePollModel),
                                  onVisibilityChanged: (VisibilityInfo info) {
                                    if (info.visibleFraction > 0 && !_articleWasReaded) {
                                      _articleWasReaded = true;
                                      Analytics().sendEventReports(
                                        event: EventsOfAnalytics.article_readed,
                                        attr: {'name': state.articleDetails.article.title, 'id': articleId},
                                      );
                                    }
                                  },
                                ),
                                ArticleQuestion(key: _questionsKey, question: state.articleDetails.article.apiArticleQuestionModel, articleId: articleId, article: state.articleDetails.article),
                                ArticleRating(article: state.articleDetails.article, articleId: articleId),
                                Visibility(
                                  visible: isCommentsEnabled,
                                  child: BlocProvider(
                                    create: (_) => CommentsBloc(restApi: RestApi(systemLang: AppLocalizations.of(context).locale.languageCode)),
                                    child: Comments(
                                      articleId: articleId,
                                      key: _commentsKey,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: !isCommentsEnabled,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(25 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical),
                                                topRight: Radius.circular(25 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: CommentsColors.InputCardShadow1Color,
                                                // color: Colors.red,
                                                offset: Offset(0, -4),
                                                blurRadius: 16,
                                              ),
                                              BoxShadow(
                                                color: CommentsColors.InputCardShadow2Color,
                                                // color: Colors.red,

                                                offset: Offset(0, -11),
                                                blurRadius: 14,
                                              ),
                                            ],
                                          ),
                                          height: SizeConfig.screenWidth / 8)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: scroll,
                        builder: (_, value, __) => AnimatedContainer(
                          height: height / 9.61/ Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                          padding: EdgeInsets.only(top: height / 40.66 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical),
                          color: appBar,
                          duration: Duration(milliseconds: 350),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Align(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          child: Stack(
                                        children: <Widget>[
                                          Container(
                                            width: 75.0,
                                            child: SvgPicture.asset(
                                              'assets/svg/back_vector.svg',
                                              color: backButton,
                                              height: height / 40.33 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                            ),
                                          ),
                                          Positioned.fill(
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                  focusColor: Colors.transparent,
                                                  highlightColor: Colors.transparent,
                                                  splashColor: Colors.transparent,
                                                  hoverColor: Colors.transparent,
                                                  borderRadius: BorderRadius.circular(60),
                                                  radius: 25 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  }),
                                            ),
                                          ),
                                        ],
                                      )),
                                      Expanded(
                                        child: AnimatedOpacity(
                                          duration: Duration(milliseconds: 350),
                                          opacity: textColor == Colors.transparent ? 0.0 : 1.0,
                                          curve: Curves.fastOutSlowIn,
                                          child: Container(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 8),
                                              child: Text(
                                                state.articleDetails.article.title != null ? state.articleDetails.article.title : '',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontFamily: Fonts.HindGuntur,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: height / 59.73 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                                  color: kArticlesPopularColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              width: 75.0,
                                              child: SvgPicture.asset(
                                                'assets/svg/article_share.svg',
                                                color: shareButton,
                                                height: height / 37.33,
                                              ),
                                            ),
                                            Positioned.fill(
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  focusColor: Colors.transparent,
                                                  highlightColor: Colors.transparent,
                                                  splashColor: Colors.transparent,
                                                  hoverColor: Colors.transparent,
                                                  borderRadius: BorderRadius.circular(60),
                                                  radius: 25 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                                  onTap: () {
                                                    Analytics().sendEventReports(
                                                      event: EventsOfAnalytics.share_article_click,
                                                      attr: {
                                                        'name': state.articleDetails.article.title,
                                                        'id': articleId,
                                                      },
                                                    );
                                                    _bloc.shareArticle(state.articleDetails.article.title, context: context);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: height / 298.6 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                  color: dividerColor,
                                  child: LinearProgressIndicator(
                                    backgroundColor: dividerColor,
                                    valueColor: AlwaysStoppedAnimation<Color>(kAlwaysStoppedAnimation),
                                    value: scroll.value,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ));
            }
            if (state is ArticleDetailsStateError) {
              return Padding(
                padding: EdgeInsets.all(22 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical),
                child: Center(
                  child: Container(child: Text(state.error)),
                ),
              );
            }
            return FullscreenPreloader();
          },
        ),
      ),
    );
  }
}

class WidgetSysInfo {
  WidgetSysInfo({this.sizeWidth = 0, this.sizeHeight = 0, this.visibleFraction = 0, this.positionPixels = 0});

  double visibleFraction;
  double sizeWidth;
  double sizeHeight;
  double positionPixels;
}

typedef void OnWidgetSizeChange(Size size);

class MeasureSizeRenderObject extends RenderProxyBox {
  Size oldSize;
  final OnWidgetSizeChange onChange;

  MeasureSizeRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();

    Size newSize = child.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}

class MeasureSize extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange onChange;

  const MeasureSize({
    Key key,
    @required this.onChange,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MeasureSizeRenderObject(onChange);
  }
}
