import 'dart:io';
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
import 'package:sofy_new/widgets/articles/cards_horizontal_list.dart';
import 'package:sofy_new/widgets/articles/categories.dart';
import 'package:sofy_new/widgets/articles/popular.dart';
import 'package:sofy_new/widgets/articles/sofy_button.dart';
import 'package:sofy_new/widgets/fullscreen_preloader.dart';
import 'package:sofy_new/widgets/material_page_route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({Key key}) : super(key: key);

  @override
  _ArticlesScreenState createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  double radius = 22.r;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double width = SizeConfig.screenWidth;
    bool ios = Platform.isIOS;
    return BlocBuilder<ArticlesBloc, ArticlesState>(
      builder: (context, state) {
        if (state is ArticlesStateResult) {
          return Container(
            decoration: BoxDecoration(
              gradient: new LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [ArticlesColors.NewBgColor, Colors.white, Colors.white, Colors.white], stops: [0.15, 0.01, 0.01, 1]),
            ),
            child: ListView(
              physics: const ClampingScrollPhysics(),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(radius), bottomRight: Radius.circular(radius)),
                  child: Container(
                    color: kArticlesNewBgColor,
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ios ? Container() : SizedBox(height: 8.h),
                            Container(
                              width: width - 20.w,
                              height: 96.h,
                              child: Padding(
                                padding: EdgeInsets.only(left: 20.w),
                                child: AutoSizeText(
                                  AppLocalizations.of(context).translate('learn_and_get_inspired'),
                                  wrapWords: true,
                                  style: TextStyle(
                                    fontFamily: Fonts.RobotoBold,
                                    letterSpacing: -0.02 * (50.sp),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 50.sp,
                                    color: kArticlesTextColor,
                                    height: 0.964,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 23.h),
                            Container(
                              width: width - 20.w,
                              height: 38.h,
                              child: Padding(
                                padding: EdgeInsets.only(left: 20.w),
                                child: AutoSizeText(
                                  AppLocalizations.of(context).translate('new_topics'),
                                  style: TextStyle(
                                    fontFamily: SizeConfig.lang == 'en' ? Fonts.AllertaRegular : Fonts.SFProMedium,
                                    letterSpacing: -0.065 * (30.sp),
                                    fontSize: 30.sp,
                                    color: kArticlesTextColor,
                                    height: 38 / 30.sp,
                                  ),
                                ),
                              ),
                            ),
                            CardsHorizontalList(
                                l: 22.w,
                                t: 9.h,
                                r: 22.w,
                                b: 21.h,
                                frozenCardTextColor: Color.fromRGBO(114, 94, 92, 1),
                                listOfArticles: state.listOfArticles,
                                cardHeight: 293.h,
                                cardRadius: 27.r,
                                cardWidth: 242.w,
                                frozenCardFontSize: 17.sp,
                                lineHeight: 1.135,
                                frozenCardHeight: 81.h,
                                titleFontSize: 24.sp),
                            SizedBox(height: 21.h),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: ArticlesColors.BgColor,
                  child: Column(
                    children: [
                      state.femaleSexuality.length > 0
                          ? CardsHorizontalList(
                              l: 20.w,
                              t: 22.h,
                              r: 22.w,
                              b: 11.h,
                              listOfArticles: state.femaleSexuality,
                              callback: () {
                                Analytics().sendEventReports(event: EventsOfAnalytics.show_articles_categories, attr: {'name': AppLocalizations.of(context).translate('female_sexuality')});
                                Navigator.push(
                                  context,
                                  CustomMaterialPageRoute(
                                      builder: (context) => ArticlesCategoriesDetailsScreen(
                                            categoryId: AppLocalizations.of(context).locale.languageCode == 'ru' ? 21 : 22,
                                            screenTitle: AppLocalizations.of(context).translate('female_sexuality'),
                                          )),
                                );
                              },
                              lineHeight: 1.193,
                              frozenCardTextColor: Color.fromRGBO(114, 94, 92, 1),
                              title: AppLocalizations.of(context).translate('female_sexuality'),
                              cardHeight: 220.h,
                              cardRadius: 20.r,
                              cardWidth: 170.w,
                              frozenCardFontSize: 14.sp,
                              frozenCardHeight: 57.h,
                              titleFontSize: 24.sp)
                          : Container(),
                      state.interestingAboutSex.length > 0
                          ? CardsHorizontalList(
                              l: 20.w,
                              t: 22.h,
                              r: 22.w,
                              b: 11.h,
                              listOfArticles: state.interestingAboutSex,
                              callback: () {
                                Analytics().sendEventReports(event: EventsOfAnalytics.show_articles_categories, attr: {'name': AppLocalizations.of(context).translate('interesting_about_sex')});
                                Navigator.push(
                                  context,
                                  CustomMaterialPageRoute(
                                      builder: (context) => ArticlesCategoriesDetailsScreen(
                                            categoryId: AppLocalizations.of(context).locale.languageCode == 'ru' ? 11 : 12,
                                            screenTitle: AppLocalizations.of(context).translate('interesting_about_sex'),
                                          )),
                                );
                              },
                              frozenCardTextColor: Color.fromRGBO(56, 57, 79, 1),
                              lineHeight: 1.378,
                              title: AppLocalizations.of(context).translate('interesting_about_sex'),
                              cardHeight: 220.h,
                              cardRadius: 20.r,
                              cardWidth: 170.w,
                              frozenCardFontSize: 14.sp,
                              frozenCardHeight: 57.h,
                              titleFontSize: 24.sp)
                          : Container(),
                      state.listOfPopularArticles.length > 0
                          ? Padding(
                              padding: EdgeInsets.fromLTRB(20.w, 30.h, 20.w, 0
                                  // 14.h,
                                  ),
                              child: Popular(
                                title: AppLocalizations.of(context).translate('popular'),
                                listOfArticles: state.listOfPopularArticles,
                                fontSize: 24.sp,
                              ),
                            )
                          : Container(),
                      state.orgasms.length > 0
                          ? CardsHorizontalList(
                              l: 20.w,
                              t: 28.h,
                              r: 22.w,
                              b: 11.h,
                              listOfArticles: state.orgasms,
                              callback: () {
                                Analytics().sendEventReports(event: EventsOfAnalytics.show_articles_categories, attr: {'name': AppLocalizations.of(context).translate('orgasms')});
                                Navigator.push(
                                  context,
                                  CustomMaterialPageRoute(
                                      builder: (context) => ArticlesCategoriesDetailsScreen(
                                            categoryId: AppLocalizations.of(context).locale.languageCode == 'ru' ? 13 : 14,
                                            screenTitle: AppLocalizations.of(context).translate('orgasms'),
                                          )),
                                );
                              },
                              frozenCardTextColor: Color.fromRGBO(114, 94, 92, 1),
                              lineHeight: 1.378,
                              title: AppLocalizations.of(context).translate('orgasms'),
                              cardHeight: 220.h,
                              cardRadius: 20.r,
                              cardWidth: 170.w,
                              frozenCardFontSize: 13.sp,
                              frozenCardHeight: 57.h,
                              titleFontSize: 24.sp)
                          : Container(),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          20.w,
                          28.h,
                          20.w,
                          21.h,
                        ),
                        child: Categories(
                          titListPadd: 10.h,
                          listOfTopics: state.popularCategories,
                          title: AppLocalizations.of(context).translate('popular_categories'),
                          lineHeight: 1.343,
                          fontTitleSize: 24.sp,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 22.w),
                        child: SofyButton(
                          width: SizeConfig.screenWidth,
                          label: AppLocalizations.of(context).translate('view_all'),
                          callback: () {
                            Analytics().sendEventReports(event: EventsOfAnalytics.show_all_articles_categories, attr: {});
                            Navigator.push(
                              context,
                              CustomMaterialPageRoute(builder: (context) => ArticlesCategoriesScreen()),
                            );
                          },
                        ),
                      ),
                      state.usd.length > 0
                          ? CardsHorizontalList(
                              l: 20.w,
                              t: 22.h,
                              r: 22.w,
                              b: 11.h,
                              listOfArticles: state.usd,
                              callback: () {
                                Analytics().sendEventReports(event: EventsOfAnalytics.show_articles_categories, attr: {'name': AppLocalizations.of(context).translate('usd')});
                                Navigator.push(
                                  context,
                                  CustomMaterialPageRoute(
                                      builder: (context) => ArticlesCategoriesDetailsScreen(
                                            categoryId: AppLocalizations.of(context).locale.languageCode == 'ru' ? 17 : 18,
                                            screenTitle: AppLocalizations.of(context).translate('usd'),
                                          )),
                                );
                              },
                              frozenCardTextColor: Color.fromRGBO(56, 57, 79, 1),
                              lineHeight: 1.378,
                              title: AppLocalizations.of(context).translate('usd'),
                              cardHeight: 220.h,
                              cardRadius: 20.r,
                              cardWidth: 170.w,
                              frozenCardFontSize: 14.sp,
                              frozenCardHeight: 57.h,
                              titleFontSize: 24.sp)
                          : Container(),
                      state.tin.length > 0
                          ? CardsHorizontalList(
                              l: 20.w,
                              t: 22.h,
                              r: 22.w,
                              b: 11.h,
                              listOfArticles: state.tin,
                              callback: () {
                                Analytics().sendEventReports(event: EventsOfAnalytics.show_articles_categories, attr: {'name': AppLocalizations.of(context).translate('tin')});
                                Navigator.push(
                                  context,
                                  CustomMaterialPageRoute(
                                      builder: (context) => ArticlesCategoriesDetailsScreen(
                                            categoryId: AppLocalizations.of(context).locale.languageCode == 'ru' ? 29 : 30,
                                            screenTitle: AppLocalizations.of(context).translate('tin'),
                                          )),
                                );
                              },
                              frozenCardTextColor: Color.fromRGBO(56, 57, 79, 1),
                              lineHeight: 1.378,
                              title: AppLocalizations.of(context).translate('tin'),
                              cardHeight: 220.h,
                              cardRadius: 20.r,
                              cardWidth: 170.w,
                              frozenCardFontSize: 14.sp,
                              frozenCardHeight: 57.h,
                              titleFontSize: 24.sp)
                          : Container(),
                      state.sip.length > 0
                          ? CardsHorizontalList(
                              l: 20.w,
                              t: 22.h,
                              r: 22.w,
                              b: 11.h,
                              listOfArticles: state.sip,
                              callback: () {
                                Analytics().sendEventReports(event: EventsOfAnalytics.show_articles_categories, attr: {'name': AppLocalizations.of(context).translate('sip')});
                                Navigator.push(
                                  context,
                                  CustomMaterialPageRoute(
                                      builder: (context) => ArticlesCategoriesDetailsScreen(
                                            categoryId: AppLocalizations.of(context).locale.languageCode == 'ru' ? 27 : 28,
                                            screenTitle: AppLocalizations.of(context).translate('sip'),
                                          )),
                                );
                              },
                              frozenCardTextColor: Color.fromRGBO(56, 57, 79, 1),
                              lineHeight: 1.378,
                              title: AppLocalizations.of(context).translate('sip'),
                              cardHeight: 220.h,
                              cardRadius: 20.r,
                              cardWidth: 170.w,
                              frozenCardFontSize: 14.sp,
                              frozenCardHeight: 57.h,
                              titleFontSize: 24.sp)
                          : Container(),
                      state.wmdta.length > 0
                          ? CardsHorizontalList(
                              l: 20.w,
                              t: 22.h,
                              r: 22.w,
                              b: 11.h,
                              listOfArticles: state.wmdta,
                              callback: () {
                                Analytics().sendEventReports(event: EventsOfAnalytics.show_articles_categories, attr: {'name': AppLocalizations.of(context).translate('wmdta')});
                                Navigator.push(
                                  context,
                                  CustomMaterialPageRoute(
                                      builder: (context) => ArticlesCategoriesDetailsScreen(
                                            categoryId: AppLocalizations.of(context).locale.languageCode == 'ru' ? 19 : 20,
                                            screenTitle: AppLocalizations.of(context).translate('wmdta'),
                                          )),
                                );
                              },
                              frozenCardTextColor: Color.fromRGBO(56, 57, 79, 1),
                              lineHeight: 1.378,
                              title: AppLocalizations.of(context).translate('wmdta'),
                              cardHeight: 220.h,
                              cardRadius: 20.r,
                              cardWidth: 170.w,
                              frozenCardFontSize: 14.sp,
                              frozenCardHeight: 57.h,
                              titleFontSize: 24.sp)
                          : Container(),
                      SizedBox(height: 20),
                      Container(
                          height: 95.h,
                          width: SizeConfig.screenWidth,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: ArticlesColors.BottomLg,
                          ))),
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
    );
  }
}
