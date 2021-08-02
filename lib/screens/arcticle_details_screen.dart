import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/size_config.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/screens/bloc/article_detales_screen_bloc.dart';
import 'package:sofy_new/screens/bloc/article_rating_bloc.dart';
import 'package:sofy_new/screens/bloc/article_vote_bloc.dart';
import 'package:sofy_new/screens/bloc/story_bloc.dart';
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
import 'package:sofy_new/widgets/fullscreen_preloader.dart';

import 'bloc/analytics.dart';
import 'bloc/setting_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ArticleDetailsScreen extends StatefulWidget {
  ArticleDetailsScreen({Key key, this.articleId = 100}) : super(key: key);
  final int articleId;

  @override
  _ArticleDetailsScreenState createState() => _ArticleDetailsScreenState();
}

class _ArticleDetailsScreenState extends State<ArticleDetailsScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final SettingBloc _bloc = SettingBloc();

  final List<Color> linearGradientColors = const [
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
        Future.delayed(Duration(milliseconds: 30), () {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        });
      }
    } else {
      if (appBar == kArticlesDetailsAppBarColor) {
        Future.delayed(Duration(milliseconds: 30), () {
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

  final _questionsKey = GlobalKey();

  ScrollController _controller = ScrollController();
  final ArticleDetailsBloc _articleDetailsBloc = ArticleDetailsBloc();

  @override
  void initState() {
    _articleDetailsBloc.add(
      ArticleDetailsEventLoad(context, articleId: widget.articleId),
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<ArticleDetailsBloc, ArticleDetailsState>(
        bloc: _articleDetailsBloc,
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
                        child: MultiBlocProvider(
                          providers: [
                            BlocProvider<ArticleVoteBloc>(
                              create: (BuildContext context) => ArticleVoteBloc(variants: state.articleDetails.article.apiArticlePollModel.variants)..add(ArticleVoteEventInit()),
                            ),
                            BlocProvider<ArticleRatingBloc>(
                              create: (BuildContext context) => ArticleRatingBloc(articleId: widget.articleId),
                            ),
                          ],
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 390.h,
                                    width: SizeConfig.screenWidth,
                                    child: Image(
                                      image: CachedNetworkImageProvider(state.articleDetails.article.coverImg),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 390.h - 25.h),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(25.r), topRight: Radius.circular(25.r)),
                                      child: Stack(
                                        alignment: Alignment.topCenter,
                                        children: [
                                          Container(
                                            height: 26.h,
                                            width: SizeConfig.screenWidth,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 386.h),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 21.w,
                                          ),
                                          child: Text(
                                            state.articleDetails.article.title,
                                            style: TextStyle(
                                              fontFamily: Fonts.RobotoBold,
                                              fontSize: 24.sp,
                                              color: ArticlesColors.HeaderTextColor,
                                              height: 1.35,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: 25.h,
                                            bottom: 8.h,
                                            left: 21.w,
                                            right: 21.w,
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SofyButton(
                                                width: SizeConfig.screenWidth - 42.w,
                                                label: AppLocalizations.of(context).translate('questions_btn'),
                                                callback: () {
                                                  Analytics().sendEventReports(
                                                    event: EventsOfAnalytics.questions_btn_click,
                                                    attr: {
                                                      'name': AppLocalizations.of(context).translate('questions_btn'),
                                                      'id': widget.articleId,
                                                    },
                                                  );
                                                  final RenderBox questions = _questionsKey.currentContext.findRenderObject();
                                                  final sizeQuestions = questions.localToGlobal(Offset.zero);
                                                  _controller.animateTo(sizeQuestions.dy - (SizeConfig.screenHeight / 8.21).h, duration: Duration(milliseconds: 350), curve: Curves.ease);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 17.w,
                                          ),
                                          child: Content(content: state.articleDetails.article.content),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              state.articleDetails.article.apiArticlePollModel.variants.length > 0 ? ArticleVote(poll: state.articleDetails.article.apiArticlePollModel) : Container(),
                              ArticleQuestion(key: _questionsKey, question: state.articleDetails.article.apiArticleQuestionModel, articleId: widget.articleId, article: state.articleDetails.article),
                              ArticleRating(article: state.articleDetails.article, articleId: widget.articleId),
                              BottomPadding()
                            ],
                          ),
                        ),
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: scroll,
                      builder: (_, value, __) => AnimatedContainer(
                        height: 104.h,
                        padding: EdgeInsets.only(top: (SizeConfig.screenHeight / 40.66).h),
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
                                          width: 75.0.w,
                                          child: SvgPicture.asset(
                                            'assets/svg/back_vector.svg',
                                            color: backButton,
                                            height: 17.h,
                                            width: 11.w,
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
                                                borderRadius: BorderRadius.circular(60.r),
                                                radius: 25.r,
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
                                            padding: EdgeInsets.only(top: 8.r),
                                            child: AutoSizeText(
                                              state.articleDetails.article.title != null ? state.articleDetails.article.title : '',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontFamily: Fonts.HindGuntur,
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 15.sp,
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
                                            width: 75.0.w,
                                            child: SvgPicture.asset(
                                              'assets/svg/article_share.svg',
                                              color: shareButton,
                                              height: 24.h,
                                              width: 24.w,
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
                                                borderRadius: BorderRadius.circular(60.r),
                                                radius: 25.r,
                                                onTap: () {
                                                  Analytics().sendEventReports(
                                                    event: EventsOfAnalytics.share_article_click,
                                                    attr: {
                                                      'name': state.articleDetails.article.title,
                                                      'id': widget.articleId,
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
                                height: (SizeConfig.screenHeight / 298.6).h,
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
              padding: EdgeInsets.all(22.w),
              child: Center(
                child: Container(child: Text(state.error)),
              ),
            );
          }
          return FullscreenPreloader();
        },
      ),
    );
  }
}

class BottomPadding extends StatelessWidget {
  const BottomPadding({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25.r), topRight: Radius.circular(25.r)),
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
        height: SizeConfig.screenWidth / 8);
  }
}

class Content extends StatelessWidget {
  const Content({Key key, this.content = ''}) : super(key: key);
  final String content;

  @override
  Widget build(BuildContext context) {
    return Html(
      style: {
        "p": Style(
            lineHeight: LineHeight.number(1.7),
            fontFamily: SizeConfig.lang == 'en' ? Fonts.HindGuntur : Fonts.RalewayRegular,
            fontStyle: FontStyle.normal,
            fontSize: FontSize(17.sp),
            color: kArticlesDetailsScreenColor),
        "strong": Style(
            lineHeight: LineHeight.number(1.7),
            fontFamily: SizeConfig.lang == 'en' ? Fonts.HindGunturBold : Fonts.RalewayBold,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
            fontSize: FontSize(17.sp),
            color: kArticlesDetailsScreenColor),
        "h1": Style(
            lineHeight: LineHeight.number(1.7), fontFamily: Fonts.Roboto, fontWeight: FontWeight.w700, fontStyle: FontStyle.normal, fontSize: FontSize(22.sp), color: kArticlesDetailsScreenColor),
        "li": Style(
            lineHeight: LineHeight.number(1.5),
            fontFamily: SizeConfig.lang == 'en' ? Fonts.HindGuntur : Fonts.RalewayRegular,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
            fontSize: FontSize(17.sp),
            color: kArticlesDetailsScreenColor),
        "ol": Style(
            lineHeight: LineHeight.number(1.5),
            fontFamily: SizeConfig.lang == 'en' ? Fonts.HindGuntur : Fonts.RalewayRegular,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
            fontSize: FontSize(17.sp),
            color: kArticlesDetailsScreenColor),
        "u": Style(
            lineHeight: LineHeight.number(1.7),
            fontFamily: SizeConfig.lang == 'en' ? Fonts.HindGuntur : Fonts.RalewayRegular,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
            fontSize: FontSize(17.sp),
            color: kArticlesDetailsScreenColor),
      },
      data: content,
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
