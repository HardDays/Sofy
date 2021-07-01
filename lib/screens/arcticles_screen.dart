import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/models/api_article_articles_model.dart';
import 'package:sofy_new/models/api_article_topic_model.dart';
import 'package:sofy_new/models/favortes/api_fav_topics_answer_model.dart';
import 'package:sofy_new/models/subscribe_data.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/providers/preferences_provider.dart';
import 'package:sofy_new/screens/articles_categories_screen.dart';
import 'package:sofy_new/screens/subscribe_screen.dart';
import 'package:sofy_new/widgets/articles_screen_button.dart';
import 'package:sofy_new/widgets/neumorph_button.dart';
import 'package:sofy_new/widgets/playlist_lead_widget.dart';

import '../rest_api.dart';
import 'arcticle_details_screen.dart';
import 'articles_categories_details_screen.dart';

class ArticlesScreen extends StatefulWidget {
  @override
  _ArticlesScreenState createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = true;
  double height, width;
  int currentIndex = 0;
  SwiperController swiperController = SwiperController();
  List<ApiArticleTopicModel> popularTopicsList = [];
  List<ApiArticlesModel> newArticlesList = [];
  List<ApiArticlesModel> popularArticle = [];
  List<ApiFavTopicsInfoModel> favoritesTopics = [];

  @override
  void initState() {
    /*Analytics().sendEventReports(
      event: modes_screen_show,
    );*/
    getPopularTopics();
    getNewArticles();
    getPopularArticle();
    getFavoritesTopics();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 250),
          child: isLoading ? _buildSkeleton(context) : _buildResult(context),
        ),
      ],
    );
  }

  Widget _buildSkeleton(BuildContext context) => SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Stack(
          children: [
            Container(
              padding:
                  EdgeInsets.only(left: 20.0, right: 20.0, top: height / 15.0),
              child: _shimmerLine(context),
            ),
            Container(
              padding: EdgeInsets.only(top: height / 7.72),
              child: Container(
                padding: EdgeInsets.only(left: 20.0),
                height: height / 3.65,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: EdgeInsets.only(bottom: 10, right: 16),
                        child: SizedBox(
                            width: height / 4.42,
                            height: height / 3.82,
                            child: Shimmer.fromColors(
                              baseColor: kShimmerBaseColor,
                              highlightColor: kAppPinkDarkColor,
                              direction: ShimmerDirection.ltr,
                              period: Duration(seconds: 2),
                              child: Container(
                                width: height / 4.1,
                                height: height / 3.65,
                                decoration: BoxDecoration(
                                  color: kArticlesWhiteColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25.0)),
                                ),
                              ),
                            )),
                      );
                    }),
              ),
            ),
            Container(
              padding:
                  EdgeInsets.only(left: 20.0, right: 20.0, top: height / 2.28),
              child: _shimmerLine(context),
            ),
            Container(
              padding: EdgeInsets.only(top: height / 2.05),
              child: _shimmerBox(context),
            ),
            Container(
              padding:
                  EdgeInsets.only(left: 20.0, right: 20.0, top: height / 1.305),
              child: _shimmerLine(context),
            ),
            Container(
              padding: EdgeInsets.only(top: height / 1.22),
              child: _shimmerBox(context),
            ),
          ],
        ),
      );

  Widget _shimmerBox(BuildContext context) => Container(
        padding: EdgeInsets.only(left: 20.0),
        height: height / 4.13,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: EdgeInsets.only(bottom: 10, right: 16),
              child: SizedBox(
                width: height / 5.3,
                height: height / 3.82,
                child: Shimmer.fromColors(
                  baseColor: kShimmerBaseColor,
                  highlightColor: kAppPinkDarkColor,
                  direction: ShimmerDirection.ltr,
                  period: Duration(seconds: 2),
                  child: Container(
                    width: height / 4.1,
                    height: height / 3.65,
                    decoration: BoxDecoration(
                      color: kArticlesWhiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );

  Widget _shimmerLine(BuildContext context) => SizedBox(
        child: Shimmer.fromColors(
          baseColor: kShimmerBaseColor,
          highlightColor: kAppPinkDarkColor,
          direction: ShimmerDirection.ltr,
          period: Duration(seconds: 2),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 10,
                      color: kArticlesWhiteColor,
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 12,
                      color: kArticlesWhiteColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildResult(BuildContext context) => SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.topLeft,
              height: height / 3.18,
              padding: EdgeInsets.only(left: 0.0, bottom: 0.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: kLinearGradColor,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(25.0)),
              ),
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 20.0, right: 0.0, top: height / 15.0),
                  child: Container(
                    height: height / 19.91,
                    padding: EdgeInsets.only(bottom: 5.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context).translate('new_topics'),
                      style: TextStyle(
                          fontFamily: kFontFamilyExo2,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          fontSize: height / 34.46,
                          //24
                          color: kArticlesWhiteColor),
                    ),
                  )),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: height / 7.72),
                  child: Container(
                    height: height / 3.67,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(left: 20.0),
                      itemCount: newArticlesList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _customContainer(newArticlesList[index]);
                      },
                    ),
                  ),
                ),
                showFavTopic(0),
                showFavTopic(1),
                SizedBox(height: height / 35.73),
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  height: height / 20.69,
                  alignment: Alignment.center,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: height / 19.91,
                          padding: EdgeInsets.only(bottom: 5.0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppLocalizations.of(context).translate('popular'),
                            style: TextStyle(
                                fontFamily: kFontFamilyExo2,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                                fontSize: height / 37.33,
                                //24
                                color: kArticlesPopularColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(0.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(0.0),
                    itemCount: popularArticle.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          bool isAppPurchase =
                              Provider.of<SubscribeData>(context, listen: false)
                                  .isAppPurchase;
                          if (popularArticle[index].isPaid == 1) {
                            if (isAppPurchase) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ArticlesDetailsScreen(
                                    articleId:
                                        popularArticle[index].id.toString(),
                                  ),
                                ),
                              );
                              /*Analytics().sendEventReports(
                                              event: vibration_play,
                                              attr: {'vibration_id': playlistData.getCurrentPlaylistModel(context).created,
                                                'playlist_id': Provider.of<PlaylistNameData>(context, listen: false).getCurrentPlaylistName().name,
                                                'source': 'playlist_' + Provider.of<PlaylistNameData>(context, listen: false).getCurrentName() + '_screen',
                                              },
                                            );*/
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SubscribeScreen(isFromSplash: false),
                                ),
                              );
                            }
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ArticlesDetailsScreen(
                                        articleId: popularArticle[index]
                                            .id
                                            .toString())));
                          }
                        },
                        child: Container(
                          height: height / 9.05,
                          padding: EdgeInsets.only(
                              left: 20.0, right: 20.0, bottom: 7.5, top: 7.5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  SizedBox(
                                    height: height / 14.93,
                                    width: height / 14.93,
                                    child: Container(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              Image.asset(
                                            'assets/player_placeholder.png',
                                            fit: BoxFit.cover,
                                          ),
                                          imageUrl:
                                              popularArticle[index].coverImg,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                      // ignore: null_aware_in_logical_operator
                                      visible: popularArticle[index].isPaid == 1
                                          ? true
                                          : false,
                                      child: Container(
                                        height:
                                            Provider.of<SubscribeData>(context)
                                                    .isAppPurchase
                                                ? 0.0
                                                : height / 14.93,
                                        width:
                                            Provider.of<SubscribeData>(context)
                                                    .isAppPurchase
                                                ? 0.0
                                                : height / 14.93,
                                        decoration: BoxDecoration(
                                          color: kPlayerPlaceholderColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                        ),
                                        alignment: Alignment.topCenter,
                                        child: Container(
                                            margin: EdgeInsets.only(
                                                top: height / 45.95),
                                            height: height / 45.95,
                                            width: 15.0,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/lock.png',),
                                                fit: BoxFit.fill,
                                              ),
                                            )),
                                      ))
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 16.0),
                                    width: width / 1.4,
                                    //height: height / 21.9,
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      popularArticle[index].title,
                                      maxLines: 2,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontFamily: kFontFamilyGilroyBold,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                          fontSize: height / 59.73,
                                          height: height / 600.14,
                                          color: kArticlesPopularColor),
                                    ),
                                  ),
                                  /*SizedBox(height: height / 89.6),
                                        Container(
                                          padding: EdgeInsets.only(left: 16.0),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            popularArticle[index]
                                                    .repliesCount
                                                    .toString() +
                                                " " +
                                                AppLocalizations.of(context)
                                                    .translate('comments')
                                                    .toLowerCase(),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontFamily: kFontFamilyGilroy,
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.normal,
                                                fontSize: height / 74.66,
                                                color: kPopularColor
                                                    .withOpacity(0.5)),
                                          ),
                                        ),*/
                                  SizedBox(height: height / 49.77),
                                  Container(
                                    padding: EdgeInsets.only(left: 16.0),
                                    child: Container(
                                      height: 1.0,
                                      width: width / 1.4,
                                      color: kPlayerColor,
                                    ),
                                  ),
                                  //SizedBox(height: height / 99.54),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                //SizedBox(height: height / 33.18),
                showFavTopic(2),
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  height: height / 13.69,
                  alignment: Alignment.center,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: height / 19.91,
                          padding: EdgeInsets.only(bottom: 5.0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('popular_categories'),
                            style: TextStyle(
                                fontFamily: kFontFamilyExo2,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                                fontSize: height / 37.33,
                                color: kArticlesPopularColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: ListView.builder(
                    itemCount: popularTopicsList.length > 4
                        ? 4
                        : popularTopicsList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(0.0),
                    itemBuilder: (context, index) =>
                        ArticlesCategoryScreenButton(
                      iconUrl: popularTopicsList[index].coverImg,
                      height: 1,
                      borderRadius: BorderRadius.only(
                          topLeft: popularTopicsList.first.id ==
                                  popularTopicsList[index].id
                              ? Radius.circular(10.0)
                              : Radius.circular(0.0),
                          topRight: popularTopicsList.first.id ==
                                  popularTopicsList[index].id
                              ? Radius.circular(10.0)
                              : Radius.circular(0.0),
                          bottomLeft: popularTopicsList.last.id ==
                                  popularTopicsList[index].id
                              ? Radius.circular(10.0)
                              : Radius.circular(0.0),
                          bottomRight: popularTopicsList.last.id ==
                                  popularTopicsList[index].id
                              ? Radius.circular(10.0)
                              : Radius.circular(0.0)),
                      text: popularTopicsList[index].name,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ArticlesCategoriesDetailsScreen(
                                    screenTitle: popularTopicsList[index].name,
                                    categoryId: popularTopicsList[index].id),
                          ),
                        );
                        /*Analytics().sendEventReports(
                            event: not_vibrating_click,
                          );*/
                      },
                    ),
                  ),
                ),
                SizedBox(height: height / 42.66),
                Container(
                    margin: EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: height / 28),
                    child: NeumorphButton(
                        width: width,
                        height: height,
                        text:
                            AppLocalizations.of(context).translate('view_all'),
                        onTap: () {
                          /*Analytics().sendEventReports(
                            event: banner_click,
                          );*/
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArticlesCategoriesScreen(),
                            ),
                          );
                        })),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(0.0),
                  itemCount: 12,
                  itemBuilder: (BuildContext context, int index) {
                    return showFavTopic(index + 3);
                  },
                ),
                SizedBox(height: height / 8.54),
              ],
            ),
          ],
        ),
      );

  Widget _customContainer(apiArticlesModel) {
    final ApiArticlesModel _apiArticlesModel = apiArticlesModel;
    return Container(
      padding: EdgeInsets.only(bottom: 10, right: 16),
      width: height / 4.1,
      height: height / 3.82,
      child: Stack(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: height,
                width: width,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  child: PlayListLeadWidget(
                    url: _apiArticlesModel.coverImg,
                    created: _apiArticlesModel.dateCreated,
                    height: height,
                    width: width,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: height / 10.67 + 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    child: Container(
                      child: BackdropFilter(
                        child: Container(
                          color: kArticlesWhiteColor.withOpacity(0.0),
                        ),
                        filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: height,
                width: width,
                margin: EdgeInsets.only(bottom: 9),
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: height / 10.67,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13.0),
                    child: Text(
                      _apiArticlesModel.title,
                      textAlign: TextAlign.left,
                      maxLines: 5,
                      style: TextStyle(
                          fontFamily: kFontFamilyGilroyBold,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          fontSize: height / 56.0,
                          color: kArticlesWhiteColor,
                          height: 1.37),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Visibility(
              // ignore: null_aware_in_logical_operator
              visible: _apiArticlesModel.isPaid == 1 ? true : false,
              child: Container(
                height: Provider.of<SubscribeData>(context).isAppPurchase
                    ? 0.0
                    : height,
                width: Provider.of<SubscribeData>(context).isAppPurchase
                    ? 0.0
                    : width,
                alignment: Alignment.topRight,
                child: Container(
                    height: height / 12.6,
                    width: height / 12.6,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/new_lock.png'),
                        fit: BoxFit.fill,
                      ),
                    )),
              )),
          Positioned.fill(
            child: Material(
              color: kArticlesTransparentColor,
              child: InkWell(
                splashColor: kArticlesTransparentColor,
                highlightColor: kArticlesTransparentColor,
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                radius: 12,
                onTap: () {
                  bool isAppPurchase =
                      Provider.of<SubscribeData>(context, listen: false)
                          .isAppPurchase;
                  if (_apiArticlesModel.isPaid == 1) {
                    if (isAppPurchase) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ArticlesDetailsScreen(
                            articleId: _apiArticlesModel.id.toString(),
                          ),
                        ),
                      );
                      /*Analytics().sendEventReports(
                                              event: vibration_play,
                                              attr: {'vibration_id': playlistData.getCurrentPlaylistModel(context).created,
                                                'playlist_id': Provider.of<PlaylistNameData>(context, listen: false).getCurrentPlaylistName().name,
                                                'source': 'playlist_' + Provider.of<PlaylistNameData>(context, listen: false).getCurrentName() + '_screen',
                                              },
                                            );*/
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SubscribeScreen(isFromSplash: false),
                        ),
                      );
                    }
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ArticlesDetailsScreen(
                          articleId: _apiArticlesModel.id.toString(),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget showFavTopic(int pos) {
    return favoritesTopics.length > pos
        ? Column(
            children: [
              SizedBox(height: height / 59.73),
              Container(
                height: height / 13.69,
                child: InkWell(
                  highlightColor: kSettingActiveButtonColor.withOpacity(0.2),
                  splashColor: kSettingActiveButtonColor.withOpacity(0.2),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ArticlesCategoriesDetailsScreen(
                          screenTitle: favoritesTopics[pos].name,
                          categoryId: favoritesTopics[pos].id,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    height: height / 14.69,
                    alignment: Alignment.center,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            //height: height / 19.91,
                            padding: EdgeInsets.only(bottom: 5.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              favoritesTopics[pos].name,
                              maxLines: 2,
                              style: TextStyle(
                                fontFamily: kFontFamilyExo2,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                                fontSize: height / 37.33,
                                color: kArticlesPopularColor,
                              ),
                            ),
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/svg/arrow_next_vector.svg',
                          color: kWelcomDarkTextColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: height / 4.2,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 20.0),
                  itemCount: favoritesTopics[pos].items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: height / 5.27,
                      height: height / 4.2,
                      margin: EdgeInsets.only(bottom: 10, right: 16),
                      child: Stack(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                width: height / 5.27,
                                height: height / 4.2,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => SizedBox(
                                      width: height / 4.42,
                                      height: height / 3.82,
                                      child: Shimmer.fromColors(
                                        baseColor: kShimmerBaseColor,
                                        highlightColor: kAppPinkDarkColor,
                                        direction: ShimmerDirection.ltr,
                                        period: Duration(seconds: 2),
                                        child: Container(
                                          width: height / 4.1,
                                          height: height / 3.65,
                                          decoration: BoxDecoration(
                                            color: kArticlesWhiteColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(25.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    imageUrl: favoritesTopics[pos]
                                        .items[index]
                                        ?.coverImg,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: height / 5.27,
                                  height: height / 9.2 + 5,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(25),
                                      bottomRight: Radius.circular(25),
                                    ),
                                    child: Container(
                                      child: BackdropFilter(
                                        child: Container(
                                          color: Colors.black.withOpacity(0.1),
                                        ),
                                        filter: ImageFilter.blur(
                                            sigmaX: 2.0, sigmaY: 2.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: height / 5.27,
                                height: height / 4.76,
                                margin: EdgeInsets.only(bottom: 5),
                                alignment: Alignment.bottomCenter,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: height / 10.2,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        right: 10.0, left: 10.0),
                                    child: Text(
                                      favoritesTopics[pos].items[index]?.title,
                                      textAlign: TextAlign.left,
                                      maxLines: 5,
                                      style: TextStyle(
                                        fontFamily: kFontFamilyGilroyBold,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        fontSize: height / 56,
                                        color: kArticlesWhiteColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                            // ignore: null_aware_in_logical_operator
                            visible:
                                favoritesTopics[pos].items[index].isPaid == '1'
                                    ? true
                                    : false,
                            child: Container(
                              height: Provider.of<SubscribeData>(context)
                                      .isAppPurchase
                                  ? 0.0
                                  : height,
                              width: Provider.of<SubscribeData>(context)
                                      .isAppPurchase
                                  ? 0.0
                                  : width,
                              alignment: Alignment.topRight,
                              child: Container(
                                height: height / 12.6,
                                width: height / 12.6,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/new_lock.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Material(
                              color: kArticlesTransparentColor,
                              child: InkWell(
                                splashColor: kArticlesTransparentColor,
                                highlightColor: kArticlesTransparentColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                radius: 12,
                                onTap: () {
                                  bool isAppPurchase =
                                      Provider.of<SubscribeData>(context,
                                              listen: false)
                                          .isAppPurchase;
                                  if (favoritesTopics[pos]
                                          .items[index]
                                          .isPaid ==
                                      '1') {
                                    if (isAppPurchase) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ArticlesDetailsScreen(
                                            articleId: favoritesTopics[pos]
                                                .items[index]
                                                .id
                                                .toString(),
                                          ),
                                        ),
                                      );
                                      /*Analytics().sendEventReports(
                                              event: vibration_play,
                                              attr: {'vibration_id': playlistData.getCurrentPlaylistModel(context).created,
                                                'playlist_id': Provider.of<PlaylistNameData>(context, listen: false).getCurrentPlaylistName().name,
                                                'source': 'playlist_' + Provider.of<PlaylistNameData>(context, listen: false).getCurrentName() + '_screen',
                                              },
                                            );*/
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SubscribeScreen(
                                              isFromSplash: false),
                                        ),
                                      );
                                    }
                                  } else {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ArticlesDetailsScreen(
                                          articleId: favoritesTopics[pos]
                                              .items[index]
                                              .id
                                              .toString(),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          )
        : Container();
  }

  Future<void> getPopularTopics() async {
    String userToken = await PreferencesProvider().getAnonToken();
    RestApi().getArticleTopicsPopular(context, token: userToken).then((values) {
      setState(() {
        popularTopicsList = values;
      });
    });
  }

  Future<void> getNewArticles() async {
    String userToken = await PreferencesProvider().getAnonToken();
    RestApi().getNewArticles(context, token: userToken).then((values) {
      setState(() {
        newArticlesList = values;
      });
    });
  }

  Future<void> getPopularArticle() async {
    String userToken = await PreferencesProvider().getAnonToken();
    RestApi().getPopularArticles(context, token: userToken).then((values) {
      setState(() {
        popularArticle = values;
      });
    });
  }

  Future<void> getFavoritesTopics() async {
    String userToken = await PreferencesProvider().getAnonToken();
    RestApi().getFavoritesTopics(context, token: userToken).then((values) {
      values.sort((a, b) {
        return b.isFavorite.toString().compareTo(a.isFavorite.toString());
      });
      setState(() {
        favoritesTopics = values;
        isLoading = false;
      });
    });
  }
}
