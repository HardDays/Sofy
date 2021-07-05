import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/screens/bloc/articles_screen_bloc.dart';
import 'package:sofy_new/widgets/articles/article_skeletion.dart';
import 'package:sofy_new/widgets/articles/articles_cards_horizontal_list.dart';
import 'package:sofy_new/widgets/articles/articles_categories_with_header.dart';
import 'package:sofy_new/widgets/articles/articles_list_with_header.dart';
import 'package:sofy_new/widgets/articles/sofy_button.dart';

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
  double radius = 22;

  @override
  void initState() {
    super.initState();
  }

  void _initializeLocale(BuildContext context) {
    final String systemLang = AppLocalizations.of(context).locale.languageCode;
    _articlesBloc = ArticlesBloc(restApi: RestApi(systemLang: systemLang));
    _articlesBloc.add(ArticlesEventLoad());
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    _initializeLocale(context);
    return BlocProvider.value(
      value: _articlesBloc,
      child: BlocBuilder<ArticlesBloc, ArticlesState>(
        builder: (context, state) {
          if (state is ArticlesStateResult) {
            double fontSize = 38 / height * 926;
            double bottom = 522 - 161 - fontSize;
            double fontSize2 = 46 / height * 926;
            double bottom2 = 522 - 42 - fontSize2 * 2;
            return Container(
              color: ArticlesColors.NewBgColor,
              child: SafeArea(
                top: false,
                child: ListView(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(radius),
                          bottomRight: Radius.circular(radius)),
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Container(
                            height: 508,
                            width: width,
                            color: kArticlesNewBgColor,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, bottom: bottom2),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('learn_and_get_inspired'),
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                letterSpacing: -0.02 * fontSize2,
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize2,
                                color: kArticlesTextColor,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, bottom: bottom),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('new_topics'),
                              style: TextStyle(
                                fontFamily: 'Allerta Regular',
                                letterSpacing: -0.065 * fontSize,
                                fontSize: fontSize,
                                color: kArticlesTextColor,
                              ),
                            ),
                          ),
                          ArticlesCardsHorizontalList(
                              listOfArticles: state.listOfArticles,
                              cardHeight: 293,
                              cardRadius: 27,
                              cardWidth: 242,
                              frozenCardFontSize: 14,
                              frozenCardHeight: 57,
                              titleFontSize: 24),
                        ],
                      ),
                    ),
                    Container(
                      color: ArticlesColors.BgColor,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(radius),
                            bottomRight: Radius.circular(radius)),
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            Container(
                              height: 22,
                              width: width,
                              color: ArticlesColors.NewBgColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: ArticlesColors.BgColor,
                      child: Column(
                        children: [
                          ArticlesCardsHorizontalList(
                              listOfArticles: state.femaleSexuality,
                              callback: () {
                                print('header femaleSexuality clicker');
                              },
                              title: AppLocalizations.of(context)
                                  .translate('female_sexuality'),
                              cardHeight: 220,
                              cardRadius: 20,
                              cardWidth: 170,
                              frozenCardFontSize: 14,
                              frozenCardHeight: 57,
                              titleFontSize: 24),
                          ArticlesCardsHorizontalList(
                              listOfArticles: state.interestingAboutSex,
                              callback: () {
                                print('header interesting_about_sex clicker');
                              },
                              title: AppLocalizations.of(context)
                                  .translate('interesting_about_sex'),
                              cardHeight: 220,
                              cardRadius: 20,
                              cardWidth: 170,
                              frozenCardFontSize: 14,
                              frozenCardHeight: 57,
                              titleFontSize: 24),
                          Padding(
                            padding: const EdgeInsets.all(22),
                            child: ArticlesListWithHeader(
                                title: AppLocalizations.of(context)
                                    .translate('popular'),
                                listOfArticles: state.listOfPopularArticles),
                          ),
                          ArticlesCardsHorizontalList(
                              listOfArticles: state.orgasms,
                              callback: () {
                                print('header orgasms clicker');
                              },
                              title: AppLocalizations.of(context)
                                  .translate('orgasms'),
                              cardHeight: 220,
                              cardRadius: 20,
                              cardWidth: 170,
                              frozenCardFontSize: 14,
                              frozenCardHeight: 57,
                              titleFontSize: 24),
                          Padding(
                            padding: const EdgeInsets.all(22),
                            child: ArticlesCategoriesWithHeader(
                              listOfTopics: state.listOfTopicsPopular,
                              title: 'Популярные категории',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 22),
                            child: SofyButton(
                              label: AppLocalizations.of(context)
                                  .translate('view_all'),
                              callback: () {},
                            ),
                          ),
                          SizedBox(height: height / 8.54),
                        ],
                      ),
                    )
                  ],
                ),
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
          return ArticleSkeletion();
        },
      ),
    );
  }
}
