import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/models/PlaylistNameData.dart';
import 'package:sofy_new/models/playlist_data.dart';
import 'package:sofy_new/models/subscribe_data.dart';
import 'package:sofy_new/providers/PageProvider.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/providers/player.dart';
import 'package:sofy_new/screens/bloc/analytics.dart';
import 'package:sofy_new/screens/playlist_screen.dart';
import 'package:sofy_new/screens/subscribe_screen.dart';
import 'package:sofy_new/widgets/material_page_route.dart';
import 'package:sofy_new/widgets/playlist_lead_widget.dart';


class RecommendationScreen extends StatefulWidget {
  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen>
    with AutomaticKeepAliveClientMixin {
  double height, width;
  int currentIndex = 0;
  SwiperController swiperController = SwiperController();
  SwiperController swiperListController = SwiperController();
  bool isFromList = true;

  @override
  void initState() {
    Analytics().sendEventReports(
      event: modes_screen_show,
    );
    var playlists = Provider.of<PlaylistNameData>(context, listen: false);
    /*if (playlists.apiPlaylistNamesList != null &&
        playlists.apiPlaylistNamesList.isNotEmpty) {
      Provider.of<PlaylistData>(context, listen: false)
          .updateVibrosByPlaylistIdApi(
        playlistId: standardPlaylistId,
        notify: false,
      );
    } else
      Provider.of<PlaylistData>(context, listen: false)
          .updateVibrosByPlaylistIdApi(
        playlistId: 0,
        notify: false,
      );*/

    playlists.updateCurrentPlaylistApi(
        playlists.getPlaylistsForRecomendScreenApi()[0]);

    setState(() {
      playlists.updateCurrentPlaylistApi(
        playlists.getPlaylistsForRecomendScreenApi()[0],
        notify: false,
      );
      currentIndex = 0;
    });

    Future.delayed(Duration(milliseconds: 250), () {
      setState(() {
        playlists.getCurrentPlaylistNameApi().titleEn.toLowerCase() == 'liked'
            ? Provider.of<PlaylistData>(context, listen: false)
                .updateVibrosByFavoritesApi(notify: false)
            : Provider.of<PlaylistData>(context, listen: false)
                .updateVibrosByPlaylistIdApi(
                playlistId: playlists.getCurrentPlaylistNameApi().id,
                notify: false,
              );
      });
    });

    checkCurrentPlaylistModel();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  void checkCurrentPlaylistModel() {
    Provider.of<PlaylistData>(context, listen: false)
        .updateSwiperAnimationDuration(duration: 0, notify: false);
    Future.delayed(Duration(milliseconds: 5), () async {
      if (mounted) {
        var vibrations = Provider.of<PlaylistData>(context, listen: false);
        if (vibrations.currentPlayListModelApi != null) {
          for (int i = 0; i < vibrations.getPlayListApi(context).length; i++)
            if (vibrations.getPlayListApi(context)[i] ==
                vibrations.currentPlayListModelApi) {
              await moveSwiperToCurrentIndex(indexToMove: i-2);
              break;
            }
        } else
          await moveSwiperToCurrentIndex(indexToMove: 0);
      }
    });
  }

  // ignore: missing_return
  Future moveSwiperToCurrentIndex({int indexToMove}) {
    Timer.periodic(Duration(milliseconds: 1), (timer) {
      if (mounted && indexToMove > 0) {
        indexToMove--;
        swiperController.next(animation: true);
      } else {
        Provider.of<PlaylistData>(context, listen: false)
            .updateSwiperAnimationDuration(duration: 300);
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    double itemWidth = width / 1.26;
    double itemHeight = height / 3.96;
    PCProvider pcProvider = Provider.of<PCProvider>(context, listen: false);

    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.topLeft,
          height: height / 3.22,
          padding: EdgeInsets.only(left: 0.0, bottom: 0.0),
          decoration: BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  const Color(0xFFFDB0C1),
                  const Color(0xFFFF95AC),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(29.0)),
          ),
          child: Padding(
              padding:
                  EdgeInsets.only(left: 20.0, right: 0.0, top: height / 16.00),
              child: Container(
                height: 45.0,
                padding: EdgeInsets.only(bottom: 5.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context).translate('recommendations'),
                  style: TextStyle(
                      fontFamily: kFontFamilyExo2,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      fontSize: height / 37.33,
                      //24
                      color: kArticlesWhiteColor),
                ),
              )),
        ),
        Container(
          width: 50.0,
          padding: EdgeInsets.only(top: height / 7.50), //115
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(
                'assets/svg/modes_rotate.svg',
              ),
              SizedBox(height: height / 52.70),
              RotatedBox(
                quarterTurns: 3,
                child: Text(
                  AppLocalizations.of(context).translate('recommended'),
//                  'Рекомендованные',
                  style: TextStyle(
                    fontFamily: kFontFamilyGilroyBold,
                    fontWeight: FontWeight.bold,
                    fontSize: height / 68.92,
                    color: kArticlesWhiteColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: height / 7.50, left: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Consumer<PlaylistNameData>(
                  builder: (context, playlistsData, child) {
                if (playlistsData.isPlayListNullApi()) {
                  return Container(
                    width: width,
                    height: (height / 3.54) + 15,
                    child: Center(
                      child: Theme(
                        data: ThemeData(
                          accentColor: kAppPinkDarkColor,
                        ),
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                  );
                }
                return Swiper(
                  onIndexChanged: (index) {
                    playlistsData.updateCurrentPlaylistApi(playlistsData
                        .getPlaylistsForRecomendScreenApi()[index]);

                    setState(() {
                      playlistsData.updateCurrentPlaylistApi(
                        playlistsData.getPlaylistsForRecomendScreenApi()[index],
                        notify: false,
                      );
                      currentIndex = index;
                    });

                    Future.delayed(Duration(milliseconds: 250), () {
                      setState(() {
                        playlistsData
                                    .getCurrentPlaylistNameApi()
                                    .titleEn
                                    .toLowerCase() ==
                                'liked'
                            ? Provider.of<PlaylistData>(context, listen: false)
                                .updateVibrosByFavoritesApi(notify: false)
                            : Provider.of<PlaylistData>(context, listen: false)
                                .updateVibrosByPlaylistIdApi(
                                playlistId: playlistsData
                                    .getCurrentPlaylistNameApi()
                                    .id,
                                notify: false,
                              );
                      });
                    });
                  },
                  onTap: (index) {
                    Analytics().sendEventReports(
                      event: 'playlist_' +
                          playlistsData.getCurrentPlaylistNameApi().titleEn +
                          '_click'.replaceAll(' ', '_'),
                    );
                    if (!Provider.of<PlaylistData>(context, listen: false)
                        .isPlayListNullApi(context)) {
                      Analytics()
                          .sendEventReports(event: playlist_current_click);

                      Navigator.push(
                        context,
                        CustomMaterialPageRoute(
                          builder: (context) => PlayListScreen()
                        ),
                      );
                    }
                  },
                  physics: BouncingScrollPhysics(),
                  itemCount: playlistsData.apiPlaylistsForRecomendScreen.length,
                  layout: SwiperLayout.CUSTOM,
                  loop: true,
                  outer: true,
                  controller: swiperController,
                  duration: Provider.of<PlaylistData>(context)
                      .swiperAnimationDuration,
                  customLayoutOption: CustomLayoutOption(
                    startIndex: -3,
                    stateCount: 7,
                  ).addTranslate([
                    new Offset(-width / 1.25, -height / 200.6),
                    new Offset(-width / 1.25, -height / 200.6),
                    new Offset(-width / 1.25, -height / 200.6),
                    new Offset(-height / 80.77, 0.0),
                    new Offset(width / 1.34, -height / 200.6),
                    new Offset(width / 1.34, -height / 200.6),
                    new Offset(width / 1.34, -height / 200.6),
                  ]).addScale(
                      [0.0, 0.0, 0.88, 1, 0.88, 0.0, 0.0], Alignment.center),
                  itemWidth: itemWidth,
                  itemHeight: itemHeight,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 5, right: 5),
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              width: itemWidth - 60,
                              height: itemHeight,
                            ),
                          ),
                          Stack(
                            children: <Widget>[
                              Container(
                                width: itemWidth,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(29)),
                                  child: CachedNetworkImage(
                                    fadeInDuration: Duration(milliseconds: 0),
                                    fadeOutDuration: Duration(milliseconds: 0),
                                    /*placeholder: (context, url) => Image.asset(
                                      'assets/player_placeholder.png',
                                      fit: BoxFit.cover,
                                    ),*/
                                    imageUrl: playlistsData
                                        .apiPlaylistsForRecomendScreen[index]
                                        ?.coverImg,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: height / 14.0,
                                  //67
                                  //margin: EdgeInsets.only(bottom: height / 46.33),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(29),
                                      bottomRight: Radius.circular(29),
                                    ),
                                    child: Container(
                                      child: BackdropFilter(
                                        child: Container(
                                          color: Color(0xff9E9E9E)
                                              .withOpacity(0.25),
                                        ),
                                        filter: ImageFilter.blur(
                                            sigmaX: 4.0, sigmaY: 4.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.bottomCenter,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(29)),
                                ),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: height / 14.0, //67
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: width / 17.35),
                                    child: Text(
                                      AppLocalizations.of(context).translate(
                                          '${playlistsData.apiPlaylistsForRecomendScreen[index].titleEn}'),
                                      style: TextStyle(
                                        fontFamily: kFontFamilyGilroyBold,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        fontSize: height / 49.77,
                                        //16
                                        color: kArticlesWhiteColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
              SizedBox(height: height / 35.86),
              Row(
                children: getIndicatorsWidgets(),
              ),
              SizedBox(height: height / 32.00),
              Expanded(
                child: Consumer<PlaylistNameData>(
                    builder: (context, playlistsData, child) {
                  return GridView.count(
                    childAspectRatio: 0.85,
                    physics: BouncingScrollPhysics(),
                    crossAxisCount: 3,
                    padding: EdgeInsets.only(
                        left: 5, right: 20, top: 5, bottom: height / 7.47),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10.5,
                    children: List<Widget>.generate(
                        Provider.of<PlaylistData>(context)
                            .vibrosByPlayListIdApi
                            .length, (index) {
                      return Stack(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                height: height / 5.2,
                                width: width / 2.9,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  child: PlayListLeadWidget(
                                    url: Provider.of<PlaylistData>(context)
                                        .vibrosByPlayListIdApi[index]
                                        .coverImg,
                                    created: Provider.of<PlaylistData>(context)
                                        .vibrosByPlayListIdApi[index]
                                        .dateCreated,
                                    height: height / 5.2,
                                    width: width / 2.9,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: height / 18.67,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                    child: Container(
                                      child: BackdropFilter(
                                        child: Container(
                                          color: Color(0xff9E9E9E)
                                              .withOpacity(0.3),
                                        ),
                                        filter: ImageFilter.blur(
                                            sigmaX: 2.0, sigmaY: 2.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: height / 5.2,
                                width: width / 2.9,
                                alignment: Alignment.bottomCenter,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: height / 18.67,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Text(
                                      AppLocalizations.of(context)
                                                  .languageCode() ==
                                              'ru'
                                          ? Provider.of<PlaylistData>(context)
                                              .vibrosByPlayListIdApi[index]
                                              ?.titleRu
                                          : Provider.of<PlaylistData>(context)
                                              .vibrosByPlayListIdApi[index]
                                              ?.titleEn,
//                                            'Полет бабочки',
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontFamily: kFontFamilyGilroyBold,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        fontSize: height / 68.92,
                                        //13
                                        color: kArticlesWhiteColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Positioned(child: Visibility(
                            // ignore: null_aware_in_logical_operator
                              visible: !Provider.of<PlaylistData>(
                                  context)
                                  .vibrosByPlayListIdApi[index]
                                  ?.isTrial ??
                                  true,
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
                                  margin: EdgeInsets.only(left: height / 15),
                                    height: height / 15.6,
                                    width: height / 15.6,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image:
                                        AssetImage('assets/new_lock.png'),
                                        fit: BoxFit.fitWidth,
                                      ),
                                    )),
                              ))),
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                  radius: 12,
                                  onTap: () {
                                    var player = Provider.of<Player>(context,
                                        listen: false);
                                    var playlistData =
                                        Provider.of<PlaylistData>(context,
                                            listen: false);
                                    bool isAppPurchase =
                                        Provider.of<SubscribeData>(context,
                                                listen: false)
                                            .isAppPurchase;
                                    if (isAppPurchase ||
                                        (!isAppPurchase &&
                                            playlistData
                                                .vibrosByPlayListIdApi[index]
                                                .isTrial)) {
                                      playlistData
                                          .updateCurrentPlayListModelApi(
                                        model: playlistData
                                            .vibrosByPlayListIdApi[index],
                                        notify: false,
                                      );
                                      if (player.currentPlayListModel != null &&
                                          player.currentPlayListModel ==
                                              playlistData
                                                      .vibrosByPlayListIdApi[
                                                  index]) {
                                        if (player.isPlayign) {
                                          player.stopVibrations();
                                          return;
                                        }
                                      }
                                      player.stopVibrations();
                                      Future.delayed(
                                          Duration(milliseconds: 250), () {
                                        player.updateCurrentPlayListModel(
                                          model: playlistData
                                              .vibrosByPlayListIdApi[index],
                                        );
                                        player.updateIsPlaying(flag: true);
                                        player.startVibrate(
                                          vibrations: playlistData
                                              .vibrosByPlayListIdApi[index]
                                              .data,
                                          startPosition: player.pausePosition,
                                        );

                                        Analytics().sendEventReports(
                                          event: vibration_play,
                                          attr: {
                                            'vibration_id': playlistData
                                                .getCurrentPlaylistModelApi(
                                                    context)
                                                .dateCreated,
                                            'playlist_id':
                                                Provider.of<PlaylistNameData>(
                                                        context,
                                                        listen: false)
                                                    .getCurrentPlaylistNameApi()
                                                    .titleEn,
                                            'source': 'playlist_' +
                                                Provider.of<PlaylistNameData>(
                                                        context,
                                                        listen: false)
                                                    .getCurrentNameApi(
                                                        AppLocalizations.of(
                                                                context)
                                                            .languageCode()) +
                                                '_screen',
                                          },
                                        );
                                      });
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SubscribeScreen(
                                              isFromSplash: false),
                                        ),
                                      );
                                    }
                                  }),
                            ),
                          ),
                        ],
                      );
                    }),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> getIndicatorsWidgets() {
    var playlists = Provider.of<PlaylistNameData>(context);
    List<Widget> result = [];
    bool isActive = false;
    double height = 0;
//    for (int i = 0; i < playlists.playlistNamesCount; i++) {
    for (int i = 0; i < playlists.apiPlaylistsForRecomendScreen.length; i++) {
      if (currentIndex == i)
        height = 14;
      else if (i > 0 && i < playlists.apiPlaylistsForRecomendScreen.length - 1)
        height = 9;
      else
        height = 6.0;
      isActive = currentIndex == i ? true : false;
      result.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: Container(
          height: height,
          width: height,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? kMainScreenScaffoldBackColor
                : Color.fromRGBO(253, 176, 193, 0.49),
            border: Border.all(
              width: isActive ? 3.0 : 0.0,
              color: isActive ? Color(0xffFDB0C1) : Colors.transparent,
            ),
          ),
        ),
      ));
    }
    return result;
  }
}
