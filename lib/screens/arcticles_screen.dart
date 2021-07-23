import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/size_config.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/screens/articles_categories_details_screen.dart';
import 'package:sofy_new/screens/articles_categories_screen.dart';
import 'package:sofy_new/screens/bloc/analytics.dart';
import 'package:sofy_new/screens/bloc/articles_screen_bloc.dart';
import 'package:sofy_new/widgets/articles/articles_cards_horizontal_list.dart';
import 'package:sofy_new/widgets/articles/articles_categories_with_header.dart';
import 'package:sofy_new/widgets/articles/articles_list_with_header.dart';
import 'package:sofy_new/widgets/articles/sofy_button.dart';
import 'package:sofy_new/widgets/fullscreen_preloader.dart';
import 'package:sofy_new/widgets/material_page_route.dart';

import '../rest_api.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({Key key}) : super(key: key);

  @override
  _ArticlesScreenState createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  ArticlesBloc _articlesBloc;
  double radius =
      22 / Layout.width * Layout.multiplier * SizeConfig.blockSizeHorizontal;

  @override
  void initState() {
    super.initState();
  }

  void _initializeLocale(BuildContext context) {
    final String systemLang = AppLocalizations.of(context).locale.languageCode;
    _articlesBloc = ArticlesBloc(
        restApi: RestApi(systemLang: systemLang), languageCode: systemLang);
    _articlesBloc.add(ArticlesEventLoad());
  }

  @override
  Widget build(BuildContext context) {
    double height = SizeConfig.screenHeight;
    double width = SizeConfig.screenWidth;
    _initializeLocale(context);
    return Container(
      color: Colors.white,
      child: BlocProvider.value(
        value: _articlesBloc,
        child: BlocBuilder<ArticlesBloc, ArticlesState>(
          builder: (context, state) {
            if (state is ArticlesStateResult) {
              return Container(
                decoration: BoxDecoration(
                  gradient: new LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        ArticlesColors.NewBgColor,
                        Colors.white,
                        Colors.white,
                        Colors.white
                      ],
                      stops: [
                        0.3,
                        0.01,
                        0.01,
                        1
                      ]),
                ),
                child: ListView(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(radius),
                          bottomRight: Radius.circular(radius)),
                      child: Stack(
                        children: [
                          Container(
                            height: 529 /
                                Layout.height *
                                Layout.multiplier *
                                SizeConfig.blockSizeVertical,
                            width: width,
                            color: kArticlesNewBgColor,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  height: 49 /
                                      Layout.height *
                                      Layout.multiplier *
                                      SizeConfig.blockSizeVertical),
                              Container(
                                width: width -
                                    20 /
                                        Layout.width *
                                        Layout.multiplier *
                                        SizeConfig.blockSizeHorizontal,
                                height: 96 /
                                    Layout.height *
                                    Layout.multiplier *
                                    SizeConfig.blockSizeVertical,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 20 /
                                          Layout.width *
                                          Layout.multiplier *
                                          SizeConfig.blockSizeHorizontal),
                                  child: AutoSizeText(
                                    AppLocalizations.of(context)
                                        .translate('learn_and_get_inspired'),
                                    wrapWords: true,
                                    style: TextStyle(
                                      fontFamily: Fonts.Roboto,
                                      letterSpacing: -0.02 *
                                          50 /
                                          Layout.height *
                                          Layout.multiplier *
                                          SizeConfig.blockSizeVertical,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 50 /
                                          Layout.height *
                                          Layout.multiplier *
                                          SizeConfig.blockSizeVertical,
                                      color: kArticlesTextColor,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: 23 /
                                      Layout.height *
                                      Layout.multiplier *
                                      SizeConfig.blockSizeVertical),
                              Container(
                                width: width -
                                    20 /
                                        Layout.width *
                                        Layout.multiplier *
                                        SizeConfig.blockSizeHorizontal,
                                height: 38 /
                                    Layout.height *
                                    Layout.multiplier *
                                    SizeConfig.blockSizeVertical,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 20 /
                                          Layout.width *
                                          Layout.multiplier *
                                          SizeConfig.blockSizeHorizontal),
                                  child: AutoSizeText(
                                    AppLocalizations.of(context)
                                        .translate('new_topics'),
                                    style: TextStyle(
                                      fontFamily: Fonts.AllertaRegular,
                                      letterSpacing: -0.065 *
                                          30 /
                                          Layout.height *
                                          Layout.multiplier *
                                          SizeConfig.blockSizeVertical,
                                      fontSize: 30 /
                                          Layout.height *
                                          Layout.multiplier *
                                          SizeConfig.blockSizeVertical,
                                      color: kArticlesTextColor,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: 9 /
                                      Layout.height *
                                      Layout.multiplier *
                                      SizeConfig.blockSizeVertical),
                              ArticlesCardsHorizontalList(
                                  listOfArticles: state.listOfArticles,
                                  cardHeight: 293 /
                                      Layout.height *
                                      Layout.multiplier *
                                      SizeConfig.blockSizeVertical,
                                  cardRadius: 27 /
                                      Layout.height *
                                      Layout.multiplier *
                                      SizeConfig.blockSizeVertical,
                                  cardWidth: 242 /
                                      Layout.width *
                                      Layout.multiplier *
                                      SizeConfig.blockSizeHorizontal,
                                  frozenCardFontSize: 17,
                                  frozenCardHeight: 81 /
                                      Layout.height *
                                      Layout.multiplier *
                                      SizeConfig.blockSizeVertical,
                                  titleFontSize: 24 /
                                      Layout.height *
                                      Layout.multiplier *
                                      SizeConfig.blockSizeVertical),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: ArticlesColors.BgColor,
                      child: Column(
                        children: [
                          state.femaleSexuality.length > 0
                              ? ArticlesCardsHorizontalList(
                                  listOfArticles: state.femaleSexuality,
                                  callback: () {
                                    Analytics().sendEventReports(
                                        event: EventsOfAnalytics
                                            .show_articles_categories,
                                        attr: {
                                          'name': AppLocalizations.of(context)
                                              .translate('female_sexuality')
                                        });
                                    Navigator.push(
                                      context,
                                      CustomMaterialPageRoute(
                                          builder: (context) =>
                                              ArticlesCategoriesDetailsScreen(
                                                categoryId:
                                                    AppLocalizations.of(context)
                                                                .locale
                                                                .languageCode ==
                                                            'ru'
                                                        ? 21
                                                        : 22,
                                                screenTitle:
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            'female_sexuality'),
                                              )),
                                    );
                                  },
                                  title: AppLocalizations.of(context)
                                      .translate('female_sexuality'),
                                  cardHeight: 220 /
                                      Layout.height *
                                      Layout.multiplier *
                                      SizeConfig.blockSizeVertical,
                                  cardRadius: 20 /
                                      Layout.height *
                                      Layout.multiplier *
                                      SizeConfig.blockSizeVertical,
                                  cardWidth: 170 /
                                      Layout.width *
                                      Layout.multiplier *
                                      SizeConfig.blockSizeHorizontal,
                                  frozenCardFontSize: 14 /
                                      Layout.height *
                                      Layout.multiplier *
                                      SizeConfig.blockSizeVertical,
                                  frozenCardHeight: 57 /
                                      Layout.height *
                                      Layout.multiplier *
                                      SizeConfig.blockSizeVertical,
                                  titleFontSize: 24 /
                                      Layout.height *
                                      Layout.multiplier *
                                      SizeConfig.blockSizeVertical)
                              : Container(),
                          state.interestingAboutSex.length > 0
                              ? ArticlesCardsHorizontalList(
                                  listOfArticles: state.interestingAboutSex,
                                  callback: () {
                                    Analytics().sendEventReports(
                                        event: EventsOfAnalytics
                                            .show_articles_categories,
                                        attr: {
                                          'name': AppLocalizations.of(context)
                                              .translate(
                                                  'interesting_about_sex')
                                        });
                                    Navigator.push(
                                      context,
                                      CustomMaterialPageRoute(
                                          builder: (context) =>
                                              ArticlesCategoriesDetailsScreen(
                                                categoryId:
                                                    AppLocalizations.of(context)
                                                                .locale
                                                                .languageCode ==
                                                            'ru'
                                                        ? 11
                                                        : 12,
                                                screenTitle: AppLocalizations
                                                        .of(context)
                                                    .translate(
                                                        'interesting_about_sex'),
                                              )),
                                    );
                                  },
                                  title: AppLocalizations.of(context)
                                      .translate('interesting_about_sex'),
                                  cardHeight: 220 /
                                      Layout.height *
                                      Layout.multiplier *
                                      SizeConfig.blockSizeVertical,
                                  cardRadius: 20 /
                                      Layout.height *
                                      Layout.multiplier *
                                      SizeConfig.blockSizeVertical,
                                  cardWidth: 170 /
                                      Layout.width *
                                      Layout.multiplier *
                                      SizeConfig.blockSizeHorizontal,
                                  frozenCardFontSize: 14 /
                                      Layout.height *
                                      Layout.multiplier *
                                      SizeConfig.blockSizeVertical,
                                  frozenCardHeight: 57 /
                                      Layout.height *
                                      Layout.multiplier *
                                      SizeConfig.blockSizeVertical,
                                  titleFontSize: 24 /
                                      Layout.height *
                                      Layout.multiplier *
                                      SizeConfig.blockSizeVertical)
                              : Container(),
                          state.listOfPopularArticles.length > 0
                              ? Padding(
                                  padding: EdgeInsets.all(22 /
                                      Layout.height *
                                      Layout.multiplier *
                                      SizeConfig.blockSizeVertical),
                                  child: ArticlesListWithHeader(
                                      title: AppLocalizations.of(context)
                                          .translate('popular'),
                                      listOfArticles:
                                          state.listOfPopularArticles),
                                )
                              : Container(),
                          state.orgasms.length > 0
                              ? ArticlesCardsHorizontalList(
                                  listOfArticles: state.orgasms,
                                  callback: () {
                                    Analytics().sendEventReports(
                                        event: EventsOfAnalytics
                                            .show_articles_categories,
                                        attr: {
                                          'name': AppLocalizations.of(context)
                                              .translate('orgasms')
                                        });
                                    Navigator.push(
                                      context,
                                      CustomMaterialPageRoute(
                                          builder: (context) =>
                                              ArticlesCategoriesDetailsScreen(
                                                categoryId:
                                                    AppLocalizations.of(context)
                                                                .locale
                                                                .languageCode ==
                                                            'ru'
                                                        ? 13
                                                        : 14,
                                                screenTitle:
                                                    AppLocalizations.of(context)
                                                        .translate('orgasms'),
                                              )),
                                    );
                                  },
                                  title: AppLocalizations.of(context)
                                      .translate('orgasms'),
                                  cardHeight: 220 /
                                      Layout.height *
                                      Layout.multiplier *
                                      SizeConfig.blockSizeVertical,
                                  cardRadius: 20 /
                                      Layout.height *
                                      Layout.multiplier *
                                      SizeConfig.blockSizeVertical,
                                  cardWidth: 170 /
                                      Layout.width *
                                      Layout.multiplier *
                                      SizeConfig.blockSizeHorizontal,
                                  frozenCardFontSize: 14 /
                                      Layout.height *
                                      Layout.multiplier *
                                      SizeConfig.blockSizeVertical,
                                  frozenCardHeight: 57 /
                                      Layout.height *
                                      Layout.multiplier *
                                      SizeConfig.blockSizeVertical,
                                  titleFontSize: 24 /
                                      Layout.height *
                                      Layout.multiplier *
                                      SizeConfig.blockSizeVertical)
                              : Container(),
                          Padding(
                            padding: EdgeInsets.all(22 /
                                Layout.height *
                                Layout.multiplier *
                                SizeConfig.blockSizeVertical),
                            child: ArticlesCategoriesWithHeader(
                              listOfTopics: state.listOfTopicsPopular,
                              title: AppLocalizations.of(context)
                                  .translate('popular_categories'),
                            ),
                          ),
                          Stack(children: [
                            Container(
                                height: height /
                                    4.6 /
                                    Layout.height *
                                    Layout.multiplier *
                                    SizeConfig.blockSizeVertical,
                                width: SizeConfig.screenWidth,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: ArticlesColors.BottomLg,
                                ))),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 22 /
                                      Layout.height *
                                      Layout.multiplier *
                                      SizeConfig.blockSizeVertical),
                              child: SofyButton(
                                label: AppLocalizations.of(context)
                                    .translate('view_all'),
                                callback: () {
                                  Analytics().sendEventReports(
                                      event: EventsOfAnalytics
                                          .show_all_articles_categories,
                                      attr: {});
                                  Navigator.push(
                                    context,
                                    CustomMaterialPageRoute(
                                        builder: (context) =>
                                            ArticlesCategoriesScreen()),
                                  );
                                },
                              ),
                            ),
                          ]),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
            if (state is ArticlesStateError) {
              return Padding(
                padding: const EdgeInsets.all(22),
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
