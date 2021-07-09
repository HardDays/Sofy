import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sofy_new/constants/app_colors.dart';
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
    scroll.value = scrollNotification.metrics.pixels /
        height /
        SizeConfig.blockSizeHorizontal;
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
  final _commentsKeyVisibilityDetector = GlobalKey();
  final _questionsKey = GlobalKey();
  final _controller = ScrollController();
  WidgetSysInfo _widgetSysInfo =
      WidgetSysInfo(sizeWidth: 0, sizeHeight: 0, visiblePercentage: 0);

  @override
  Widget build(BuildContext context) {
    double height = SizeConfig.screenHeight;
    double width = SizeConfig.screenWidth;
    return Scaffold(
      backgroundColor: ArticleDetailsColors.TransparentColor,
      body: BlocProvider.value(
        value: ArticleDetailsBloc(
            restApi: RestApi(
                systemLang: AppLocalizations.of(context).locale.languageCode))
          ..add(ArticleDetailsEventLoad(articleId: articleId)),
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
                            color: ArticleDetailsColors.BgColor,
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: 390,
                                      width: width,
                                      child: ExtendedImage.network(
                                        state.articleDetails.article.coverImg,
                                        fit: BoxFit.cover,
                                        cache: true,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 366),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(radius),
                                            topRight: Radius.circular(radius)),
                                        child: Stack(
                                          alignment: Alignment.topCenter,
                                          children: [
                                            Container(
                                              height: 60,
                                              width: width,
                                              color:
                                                  ArticleDetailsColors.BgColor,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      21, 21, 21, 0),
                                              child: ArticleAuthorDescription(
                                                  author: state.author),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 426),
                                      child: Stack(
                                        alignment: Alignment.topCenter,
                                        children: [
                                          Container(
                                            color: ArticleDetailsColors.BgColor,
                                            padding: const EdgeInsets.fromLTRB(
                                                21, 26, 21, 0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  state.articleDetails.article
                                                      .title,
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 24,
                                                      color: ArticlesColors
                                                          .HeaderTextColor),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 25, bottom: 8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      SofyButton(
                                                        width: width / 2 - 30,
                                                        label: AppLocalizations
                                                                .of(context)
                                                            .translate(
                                                                'questions_btn'),
                                                        callback: () {
                                                          final RenderBox
                                                              questions =
                                                              _questionsKey
                                                                  .currentContext
                                                                  .findRenderObject();
                                                          final sizeQuestions =
                                                              questions
                                                                  .localToGlobal(
                                                                      Offset
                                                                          .zero);
                                                          _controller.animateTo(
                                                              sizeQuestions.dy -
                                                                  height / 8.21,
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      350),
                                                              curve:
                                                                  Curves.ease);
                                                        },
                                                      ),
                                                      SofyButton(
                                                          width: width / 2 - 30,
                                                          label: AppLocalizations
                                                                  .of(context)
                                                              .translate(
                                                                  'comments_btn'),
                                                          callback: () {
                                                            final RenderBox
                                                                comments =
                                                                _commentsKey
                                                                    .currentContext
                                                                    .findRenderObject();
                                                            final sizeComments =
                                                                comments
                                                                    .localToGlobal(
                                                                        Offset
                                                                            .zero);
                                                            _controller.animateTo(
                                                                sizeComments
                                                                        .dy -
                                                                    height /
                                                                        8.21,
                                                                duration: Duration(
                                                                    milliseconds:
                                                                        350),
                                                                curve: Curves
                                                                    .ease);
                                                          })
                                                    ],
                                                  ),
                                                ),
                                                Html(
                                                  style: {
                                                    "p": Style(
                                                        wordSpacing: 5,
                                                        lineHeight:
                                                            LineHeight.number(
                                                                1.5),
                                                        fontFamily:
                                                            kFontFamilyMontserrat,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: FontSize(
                                                            height / 57.73),
                                                        color:
                                                            kArticlesDetailsScreenColor),
                                                    "strong": Style(
                                                        wordSpacing: 5,
                                                        lineHeight:
                                                            LineHeight.number(
                                                                1.6),
                                                        fontFamily:
                                                            kFontFamilyMontserratBold,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: FontSize(
                                                            height / 50.7),
                                                        color:
                                                            kArticlesDetailsScreenColor),
                                                    "h1": Style(
                                                        wordSpacing: 5,
                                                        lineHeight:
                                                            LineHeight.number(
                                                                1.6),
                                                        fontFamily:
                                                            kFontFamilyMontserrat,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: FontSize(
                                                            height / 50.7),
                                                        color:
                                                            kArticlesDetailsScreenColor),
                                                    "li": Style(
                                                        wordSpacing: 5,
                                                        lineHeight:
                                                            LineHeight.number(
                                                                1.5),
                                                        fontFamily:
                                                            kFontFamilyMontserrat,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: FontSize(
                                                            height / 57.73),
                                                        color:
                                                            kArticlesDetailsScreenColor),
                                                    "u": Style(
                                                        wordSpacing: 5,
                                                        lineHeight:
                                                            LineHeight.number(
                                                                1.5),
                                                        fontFamily:
                                                            kFontFamilyMontserrat,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: FontSize(
                                                            height / 57.73),
                                                        color:
                                                            kArticlesDetailsScreenColor),
                                                  },
                                                  data: state
                                                              .articleDetails
                                                              .article
                                                              .content !=
                                                          null
                                                      ? state.articleDetails
                                                          .article.content
                                                      : '',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                ArticleVote(
                                    poll: state.articleDetails.article
                                        .apiArticlePollModel),
                                ArticleQuestion(
                                    key: _questionsKey,
                                    question: state.articleDetails.article
                                        .apiArticleQuestionModel,
                                    articleId: articleId),
                                ArticleRating(
                                    article: state.articleDetails.article,
                                    articleId: articleId),
                                VisibilityDetector(
                                  key: _commentsKeyVisibilityDetector,
                                  onVisibilityChanged: (visibilityInfo) {
                                    _widgetSysInfo.visiblePercentage =
                                        visibilityInfo.visibleFraction * 100;
                                    _widgetSysInfo.sizeWidth =
                                        visibilityInfo.size.width;
                                    sizeHeight:
                                    _widgetSysInfo.sizeHeight =
                                        visibilityInfo.size.height;
                                    // debugPrint(
                                    //     'Widget ${visibilityInfo.key} is ${_commentsVisiblePercentage}% visible');
                                  },
                                  child: BlocProvider(
                                    create: (_) => CommentsBloc(
                                        restApi: RestApi(
                                            systemLang:
                                                AppLocalizations.of(context)
                                                    .locale
                                                    .languageCode)),
                                    child: BlocListener<CommentsBloc,
                                        CommentsState>(
                                      listener: (context, state) {
                                        if (state
                                            is CommentsStateLoading) if (_widgetSysInfo
                                                .visiblePercentage >
                                            0)
                                          BlocProvider.of<ArticleDetailsBloc>(
                                                  context)
                                              .widgetSysInfo = _widgetSysInfo;
                                        if (state is CommentsStateResult)
                                          print(BlocProvider.of<
                                                  ArticleDetailsBloc>(context)
                                              .widgetSysInfo);
                                        print(
                                            '${state.toString()} ${BlocProvider.of<ArticleDetailsBloc>(context).widgetSysInfo.visiblePercentage}');
                                      },
                                      child: Comments(
                                        articleId: articleId,
                                        key: _commentsKey,
                                      ),
                                    ),
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
                          height: height / 9.61,
                          padding: EdgeInsets.only(top: height / 40.66),
                          color: appBar,
                          duration: Duration(milliseconds: 350),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Align(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          child: Stack(
                                        children: <Widget>[
                                          Container(
                                            width: 75.0,
                                            child: SvgPicture.asset(
                                              'assets/svg/back_vector.svg',
                                              color: backButton,
                                              height: height / 40.33,
                                            ),
                                          ),
                                          Positioned.fill(
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                  focusColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  splashColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(60),
                                                  radius: 25,
                                                  onTap: () {
                                                    //Analytics().sendEventReports(event: subscription_splash_close_click);
                                                    Navigator.pop(context);
                                                  }),
                                            ),
                                          ),
                                        ],
                                      )),
                                      Expanded(
                                        child: AnimatedOpacity(
                                          duration: Duration(milliseconds: 350),
                                          opacity:
                                              textColor == Colors.transparent
                                                  ? 0.0
                                                  : 1.0,
                                          curve: Curves.fastOutSlowIn,
                                          child: Container(
                                            child: Text(
                                              state.articleDetails.article
                                                          .title !=
                                                      null
                                                  ? state.articleDetails.article
                                                      .title
                                                  : '',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontFamily:
                                                    kFontFamilyMontserratSemi,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.normal,
                                                fontSize: height / 59.73,
                                                color: kArticlesPopularColor,
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
                                                  focusColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  splashColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(60),
                                                  radius: 25,
                                                  onTap: () {
                                                    Analytics()
                                                        .sendEventReports(
                                                      event:
                                                          share_article_click,
                                                      attr: {
                                                        'article_name': state
                                                            .articleDetails
                                                            .article
                                                            .title,
                                                      },
                                                    );
                                                    _bloc.shareArticle(
                                                        state.articleDetails
                                                            .article.title,
                                                        context: context);
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
                                  height: height / 298.6,
                                  color: dividerColor,
                                  child: LinearProgressIndicator(
                                    backgroundColor: dividerColor,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        kAlwaysStoppedAnimation),
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
                padding: const EdgeInsets.all(22),
                child: Center(
                  child: Container(child: Text(state.error)),
                ),
              );
            }
            return ArticleDetailsSkeletion();
          },
        ),
      ),
    );
  }
}

class WidgetSysInfo {
  WidgetSysInfo({this.sizeWidth =0, this.sizeHeight=0, this.visiblePercentage=0});

  double visiblePercentage;
  double sizeWidth;
  double sizeHeight;
}
