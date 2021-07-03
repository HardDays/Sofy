import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_fade/image_fade.dart';
import 'package:infinity_page_view/infinity_page_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/models/PlaylistNameData.dart';
import 'package:sofy_new/models/playlist_data.dart';
import 'package:sofy_new/models/subscribe_data.dart';
import 'package:sofy_new/providers/PageProvider.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/providers/player.dart';
import 'package:sofy_new/providers/preferences_provider.dart';
import 'package:sofy_new/screens/bloc/analytics.dart';
import 'package:sofy_new/screens/subscribe_screen.dart';
import 'package:sofy_new/widgets/neumorphic/neumorphic_button.dart';

class PlayerScreen extends StatefulWidget {
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  double height, width;

  //SwiperController swiperController = SwiperController();
  InfinityPageController swiperController =
      InfinityPageController(viewportFraction: 0.63);
  var currentPage = 0.0;

  double opacityWave2 = 1;
  double opacityWave3 = 0.5;

  bool isPlayFisrt = true;
  bool isShowSwiper = false;

  @override
  void initState() {
    checkCurrentPlaylistModel();
    Analytics().sendEventReports(event: main_screen_show);
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        isShowSwiper = true;
      });
    });
    super.initState();
  }

  void checkCurrentPlaylistModel() {
    /*Provider.of<PlaylistData>(context, listen: false)
        .updateSwiperAnimationDuration(duration: 0, notify: false);*/
    Future.delayed(Duration(milliseconds: 5), () async {
      if (mounted) {
        var vibrations = Provider.of<PlaylistData>(context, listen: false);
        if (vibrations.currentPlayListModelApi != null) {
          for (int i = 0; i < vibrations.getPlayListApi(context).length; i++)
            if (vibrations.getPlayListApi(context)[i] ==
                vibrations.currentPlayListModelApi) {
              swiperController.jumpToPage(i);
              //await moveSwiperToCurrentIndex(indexToMove: i);
              break;
            }
        } else
          swiperController.jumpToPage(0);
        //await moveSwiperToCurrentIndex(indexToMove: 0);
      }
    });
  }

  // ignore: missing_return
  Future moveSwiperToCurrentIndex({int indexToMove}) {
    Timer.periodic(Duration(milliseconds: 1), (timer) {
      if (mounted && indexToMove > 0) {
        indexToMove--;
        //swiperController.nextPage(duration: Duration(milliseconds: 0), curve: Curves.easeInOut);
      } else {
        Provider.of<PlaylistData>(context, listen: false)
            .updateSwiperAnimationDuration(duration: 300);
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print('player_screen');
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    PCProvider pcProvider = Provider.of<PCProvider>(context, listen: false);
    return NeumorphicTheme(
      theme: NeumorphicThemeData(
          intensity: 0.6, lightSource: LightSource.topLeft, depth: 5),
      child: Stack(
        children: <Widget>[
          /**TOP IMAGE CONTAINER **/
          Column(
            children: <Widget>[
              SizedBox(height: height / 1.26),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Container(
                  color: kMainScreenScaffoldBackColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 15.0,
                              width: 5.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/wave1.png'),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            SizedBox(width: 7.0),
                            Container(
                              height: 25.0,
                              width: 6.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/wave2.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 15.0),
                      Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Container(
                            height: height / 23.57,
                            width: height / 4.05,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/slider_fon.png'),
                              ),
                            ),
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                overlayColor: kArticlesWhiteColor,
                                activeTrackColor: Colors.transparent,
                                inactiveTrackColor: kMainScreenScaffoldBackColor
                                    .withOpacity(0.6),
                                trackHeight: 75,
                                thumbColor: Colors.transparent,
                                overlayShape:
                                    RoundSliderOverlayShape(overlayRadius: 0),
                                thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 0),
                              ),
                              child: MediaQuery.removePadding(
                                context: context,
                                removeRight: true,
                                child: Slider(
                                  min: 0.0,
                                  max: 78.0,
                                  divisions: 40,
                                  value: Provider.of<SubscribeData>(context)
                                          .isAppPurchase
                                      ? Provider.of<Player>(context)
                                          .sliderSpeedValue
                                          .roundToDouble()
                                      : 39,
                                  onChanged: (value) {
                                    if (Provider.of<SubscribeData>(context,
                                            listen: false)
                                        .isAppPurchase) {
                                      print('slider = ' + value.toString());
                                      if (value <= 45) {
                                        setState(() {
                                          opacityWave2 = (value * 1.28) / 100;
                                          opacityWave3 = 0;
                                        });
                                      } else {
                                        setState(() {
                                          opacityWave3 = (value * 1.28) / 100;
                                        });
                                      }
                                      Provider.of<Player>(context,
                                              listen: false)
                                          .updateSliderSpeedValue(
                                              value: value.round());
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SubscribeScreen(
                                              isFromSplash: false),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Visibility(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      FadeRoute(
                                        builder: (BuildContext context) =>
                                            SubscribeScreen(
                                                isFromSplash: false),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 25.0,
                                    width: 25.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image:
                                            AssetImage('assets/lock_vibra.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              visible: Provider.of<SubscribeData>(context)
                                      .isAppPurchase
                                  ? false
                                  : true,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 15.0),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 15.0,
                              width: 5.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/wave1.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 7.0),
                            AnimatedOpacity(
                              child: Container(
                                height: 25.0,
                                width: 6.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/wave2.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              duration: const Duration(milliseconds: 500),
                              opacity: opacityWave2,
                            ),
                            SizedBox(width: 8.0),
                            AnimatedOpacity(
                              child: Container(
                                height: 35.0,
                                width: 8.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/wave3.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              duration: const Duration(milliseconds: 500),
                              opacity: opacityWave3,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: height / 1.35,
            decoration: BoxDecoration(
              color: kPlayerScrColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(49.0),
                bottomRight: Radius.circular(49.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10.0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
          ),
          Container(
              width: width,
              height: height / 3.54,
              child: CachedNetworkImage(
                fadeInDuration: Duration(milliseconds: 0),
                fadeOutDuration: Duration(milliseconds: 0),
                imageUrl: getFonImmageUrl(),
                imageBuilder: (context, imageProvider) => ImageFade(
                  image: imageProvider,
                  placeholder: Container(
                    color: kPlayerScrPlaceholderColor,
                    child: Center(
                        child: Icon(
                      Icons.photo,
                      color: kArticlesWhiteColor,
                      size: 128.0,
                    )),
                  ),
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent event) {
                    if (event == null) {
                      return child;
                    }
                    return Container();
                  },
                  errorBuilder:
                      (BuildContext context, Widget child, dynamic exception) {
                    return Container(
                      color: kPlayerScrErrorBgrColor,
                      child: Center(
                          child: Icon(Icons.warning,
                              color: Colors.black26, size: 128.0)),
                    );
                  },
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              )),
          Container(
            width: width,
            height: (height / 3.54) + 10, //+ 10
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  kPlayerScrAdditColor.withOpacity(0.53),
                  kPlayerScrColor.withOpacity(0.93),
                  kPlayerScrColor.withOpacity(1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Container(
            height: height / 1.35,
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(49.0),
                  bottomRight: Radius.circular(49.0),
                ),
//              gradient: LinearGradient(
//                colors: [
//                  kPlayerScrColor.withOpacity(0.05),
//                  kPlayerScrColor.withOpacity(0.34),
//                  kPlayerScrColor.withOpacity(0.8),
//                  kPlayerScrColor.withOpacity(0.3),
////                  kArticlesWhiteColor.withOpacity(0.22),
//                ],
//                begin: Alignment.topCenter,
//                end: Alignment.bottomCenter,
//              ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: height / 10.92),
                  Text(
                    Provider.of<PlaylistData>(context)
                            .isPlayListNullApi(context)
                        ? 'Vibration name'
                        : Provider.of<PlaylistData>(context)
                            .getCurrentVibrationNameApi(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: kFontFamilyExo2,
                      fontSize: height / 27.15,
                      color: kPlayerTextColor,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  SizedBox(height: 6.0),
                  Text(
                    getPlaylistName(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: kFontFamilyGilroy,
                      fontSize: height / 59.73,
                      color: kPlayerTextColor,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  SizedBox(height: height / 23.57),
                  Consumer<PlaylistData>(
                    builder: (context, playlistData, child) {
                      if (playlistData.isPlayListNullApi(context)) {
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
                      } else if (playlistData.getPlayListCountApi(context) ==
                          0) {
                        return Container(
                          width: width,
                          height: (height / 3.54) + 15,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.0),
                              child: Text(
                                'There are no vibrations in the database.',
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: kFontFamilyProximaNova,
                                  fontSize: 20.00,
                                  color: kListviewTitleColor,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return AnimatedOpacity(
                        child: Container(
                          child: setSwiper(playlistData),
                          height: height / 3.34,
                        ),
                        opacity: isShowSwiper ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 125),
                      );
                    },
                  ),
                  /** SLIDER SHKALA**/
                  Padding(
                    padding: EdgeInsets.only(
                        left: 25.0,
                        right: 25.0,
                        top: height / 26.8,
                        bottom: height / 26.35),
                    child: Container(
                      height: 40.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                /*Provider.of<Player>(context)
                                    .getCurrentTimeString(),*/
                                '',
                                style: TextStyle(
                                  color: kWelcomButtonDarkColor,
                                  fontFamily: kFontFamilyGilroy,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 25.0),
                          /** Equalizer **/
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(top: 10.0, bottom: 3.0),
                              child: BarChart(
                                BarChartData(
                                  backgroundColor: Colors.transparent,
                                  alignment: BarChartAlignment.spaceAround,
                                  maxY: 255,
                                  barTouchData: BarTouchData(enabled: false),
                                  titlesData: FlTitlesData(show: false),
                                  axisTitleData: FlAxisTitleData(show: false),
                                  borderData: FlBorderData(show: false),
                                  groupsSpace: 10,
                                  barGroups: getBarChartGroupData(46),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 25.0),
                          Container(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                //getTimeString(),
                                '',
                                style: TextStyle(
                                  fontFamily: kFontFamilyGilroy,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.normal,
                                  color: kPlayerScrTextColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            IconButton(
                              splashColor: kAppPinkDarkColor,
                              highlightColor: kAppPinkDarkColor,
                              icon: SvgPicture.asset(
                                  'assets/svg/list_vector.svg',
                                  height: height / 52.71,
                                  width: width / 18.82),
                              onPressed: () {},
                            ),
                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                    highlightColor:
                                        kAppPinkDarkColor.withOpacity(0.5),
                                    splashColor: Colors.transparent,
                                    borderRadius: BorderRadius.circular(70.0),
                                    radius: 50,
                                    onTap: () {
                                      if (!Provider.of<PlaylistData>(context,
                                              listen: false)
                                          .isPlayListNullApi(context)) {
                                        Analytics().sendEventReports(
                                            event: playlist_current_click);

                                        Provider.of<PlaylistNameData>(context,
                                                listen: false)
                                            .updateCurrentPlaylistApi(Provider
                                                    .of<PlaylistNameData>(
                                                        context,
                                                        listen: false)
                                                .getPlaylistNameByIDApi(
                                                    id: Provider.of<
                                                                PlaylistData>(
                                                            context,
                                                            listen: false)
                                                        .getCurrentPlaylistModelApi(
                                                            context)
                                                        .parentPlaylistId));
                                        pcProvider.animateToPage(
                                            index: MyPlaylistScreen_PAGE_INDEX);
                                      }
                                    }),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              height: height / 19.06,
                              width: height / 19.06,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      color: kPlayerScrShadow2Color
                                          .withOpacity(0.86),
                                      blurRadius: 10.0,
                                      offset: Offset(-2, -2)),
                                  BoxShadow(
                                      color: kPlayerScrShadowColor
                                          .withOpacity(0.41),
                                      blurRadius: 10.0,
                                      offset: Offset(2, 2)),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: SizedBox(
                                  height: height / 19.06,
                                  child: NeumorphicCustomButton(
                                      style: NeumorphicStyle(
                                          shape: NeumorphicShape.flat,
                                          intensity: 0.6,
                                          shadowLightColorEmboss:
                                              kADNeumorphicShadowLightColorEmboss,
                                          shadowDarkColor:
                                              kADNeumorphicShadowDarkColor,
                                          shadowDarkColorEmboss:
                                              kADNeumorphicShadowDarkColorEmboss,
                                          shadowLightColor: kArticlesWhiteColor,
                                          color: kADNeumorphicColor),
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(16)),
                                      provideHapticFeedback: false,
                                      onClick: () async {
                                        Analytics().sendEventReports(
                                          event: vibration_previous,
                                          attr: {
                                            'vibration_id':
                                                Provider.of<PlaylistData>(
                                                        context,
                                                        listen: false)
                                                    .getCurrentPlaylistModelApi(
                                                        context)
                                                    .id,
                                            'playlist_id': 'playlist_' +
                                                Provider.of<PlaylistNameData>(
                                                        context,
                                                        listen: false)
                                                    .getCurrentPlaylistNameApi()
                                                    .titleEn
                                                    .replaceAll(' ', '_'),
                                          },
                                        );
                                        //swiperController.previous();
                                        await swiperController.animateToPage(
                                            swiperController.page - 1,
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.easeInOut);
                                      },
                                      padding: EdgeInsets.all(0.0),
                                      child: Center(
                                          child: Container(
                                        height: height / 55,
                                        width: height / 55,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                          image:
                                              AssetImage('assets/previous.png'),
                                          fit: BoxFit.fitHeight,
                                        ),),
                                      ),),),),
                            ),
                            SizedBox(width: 25.0),
                            Container(
                              height: height / 14,
                              width: height / 14,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: kPlayerScrShadow3Color,
                                      blurRadius: 8.0,
                                      offset: Offset(3, 3)),
                                  BoxShadow(
                                      color: kPlayerScrShadow4Color
                                          .withOpacity(0.41),
                                      blurRadius: 10.0,
                                      offset: Offset(-3, -3),),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: SizedBox(
                                  height: height / 14,
                                  child: NeumorphicCustomButton(
                                      style: NeumorphicStyle(
                                          shape: NeumorphicShape.convex,
                                          depth: Provider.of<Player>(context)
                                                  .isPlayign
                                              ? -6
                                              : 3,
                                          intensity: 0.5,
                                          shadowLightColorEmboss:
                                              kADNeumorphicShadowLightColorEmboss,
                                          shadowDarkColor:
                                              kADNeumorphicShadowDarkColor,
                                          shadowDarkColorEmboss:
                                              kADNeumorphicShadowDarkColorEmboss,
                                          shadowLightColor:
                                              kADNeumorphicShadowLightColor,
                                          color: kADNeumorphic2Color),
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(50)),
                                      onClick: () {
                                        playOrPause();
                                      },
                                      padding: EdgeInsets.all(0.0),
                                      child: Center(
                                          child: Container(
                                        height: height / 30,
                                        width: height / 30,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                          image: AssetImage(
                                              Provider.of<Player>(context)
                                                      .isPlayign
                                                  ? 'assets/pause.png'
                                                  : 'assets/play.png'),
                                          fit: BoxFit.fitHeight,
                                        ),),
                                      ),),),),
                            ),
                            SizedBox(width: 25.0),
                            Container(
                              height: height / 19.06,
                              width: height / 19.06,
                              decoration: BoxDecoration(
//                                            color: Color(0xffFCEFFC),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      color: kPlayerScrShadow4Color
                                          .withOpacity(0.86),
                                      blurRadius: 10.0,
                                      offset: Offset(-2, -2)),
                                  BoxShadow(
                                      color: kPlayerScrShadowColor
                                          .withOpacity(0.41),
                                      blurRadius: 10.0,
                                      offset: Offset(2, 2)),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: SizedBox(
                                  height: height / 19.06,
                                  child: NeumorphicCustomButton(
                                      style: NeumorphicStyle(
                                          shape: NeumorphicShape.flat,
                                          intensity: 0.5,
                                          shadowLightColorEmboss:
                                              kADNeumorphicShadowLightColorEmboss,
                                          shadowDarkColor:
                                              kADNeumorphicShadowDarkColor,
                                          shadowDarkColorEmboss:
                                              kADNeumorphicShadowDarkColorEmboss,
                                          shadowLightColor: kArticlesWhiteColor,
                                          color: kADNeumorphicColor),
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(16),),
                                      provideHapticFeedback: false,
                                      onClick: () async {
                                        //swiperController.next();
                                        await swiperController.animateToPage(
                                            swiperController.page + 1,
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.easeInOut);
                                        Analytics().sendEventReports(
                                          event: vibration_previous,
                                          attr: {
                                            'vibration_id':
                                                Provider.of<PlaylistData>(
                                                        context,
                                                        listen: false)
                                                    .getCurrentPlaylistModelApi(
                                                        context)
                                                    .id,
                                            'playlist_id': 'playlist_' +
                                                Provider.of<PlaylistNameData>(
                                                        context,
                                                        listen: false)
                                                    .getCurrentPlaylistNameApi()
                                                    .titleEn
                                                    .replaceAll(' ', '_'),
                                          },
                                        );
                                      },
                                      padding: EdgeInsets.all(0.0),
                                      child: Center(
                                          child: Container(
                                        height: height / 55,
                                        width: height / 55,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                          image: AssetImage('assets/next.png'),
                                          fit: BoxFit.fitHeight,
                                        ),),
                                      ),),),),
                            ),
                          ],
                        ),
                        IconButton(
                          splashColor: kAppPinkDarkColor,
                          highlightColor: kAppPinkDarkColor,
                          icon: SvgPicture.asset(
                            'assets/svg/heart_vector.svg',
                            height: height / 44.80,
                            width: width / 19.26,
                            color: getHeartColor(),
                          ),
                          onPressed: () async {
                            await clickHeart();
                            Provider.of<PlaylistData>(context, listen: false)
                                .checkForFavoritesApi(context);
                            Analytics().sendEventReports(
                              event: like_vibration,
                              attr: {
                                'vibration_id': Provider.of<PlaylistData>(
                                        context,
                                        listen: false)
                                    .getCurrentPlaylistModelApi(context)
                                    .id,
                                'source': 'main_screen',
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void playOrPause({bool isNeedChangePlayerStatus = true}) {
    var playlists = Provider.of<PlaylistNameData>(context, listen: false);
    var vibrations = Provider.of<PlaylistData>(context, listen: false);
    var player = Provider.of<Player>(context, listen: false);
    if (vibrations.isPlayListNullApi(context)) return;
    if (isNeedChangePlayerStatus) {
      player.updateIsPlaying(flag: !player.isPlayign);
    }
    if (player.isPlayign) refreshState();
    if (player.isPlayign) {
      player.startVibrate(
        vibrations: vibrations.getCurrentPlaylistModelApi(context).data,
        startPosition: player.pausePosition,
      );
      Analytics().sendEventReports(
        event: vibration_play,
        attr: {
          'vibration_id': vibrations.getCurrentPlaylistModelApi(context).id,
          'playlist_id': 'playlist_' +
              Provider.of<PlaylistNameData>(context, listen: false)
                  .getCurrentPlaylistNameApi()
                  .titleEn
                  .replaceAll(' ', '_'),
        },
      );
    } else {
      player.pauseVibrations(
        vibrations: vibrations.getCurrentPlaylistModelApi(context).data,
      );
      Analytics().sendEventReports(
        event: vibration_pause,
        attr: {
          'vibration_id': vibrations.getCurrentPlaylistModelApi(context).id,
          'playlist_id': 'playlist_' +
              Provider.of<PlaylistNameData>(context, listen: false)
                  .getCurrentPlaylistNameApi()
                  .titleEn
                  .replaceAll(' ', '_'),
        },
      );
    }
  }

  String getTimeString() {
    int currentPlayTime = 0;
    try {
      var vibrations = Provider.of<PlaylistData>(context)
          .getCurrentPlaylistModelApi(context)
          .data;
      vibrations.forEach((element) => currentPlayTime += element.duration);
      return DateFormat('m:ss')
          .format(DateTime.fromMillisecondsSinceEpoch(currentPlayTime));
    } catch (e) {
      return '0:00';
    }
  }

  String getFonImmageUrl() {
    var playlistData = Provider.of<PlaylistData>(context);
    try {
      if (playlistData.getPlayListApi(context) != null)
        return playlistData
            .getPlayListApi(context)[playlistData.currentVibrationIndex]
            ?.coverImg;
      else
        return '';
    } catch (e) {
      return '';
    }
  }

  Future clickHeart() async {
    return await PreferencesProvider().saveOrRemoveFavorite(
        Provider.of<PlaylistData>(context, listen: false)
            .getCurrentPlaylistModelApi(context)
            .dateCreated
            .toString());
  }

  Color getHeartColor() {
    var playlistData = Provider.of<PlaylistData>(context);
    if (playlistData.isPlayListNullApi(context) ||
        playlistData.getPlayListApi(context).isEmpty)
      return kInactiveHeartColor.withOpacity(0.28);
    return playlistData.getCurrentPlaylistModelApi(context).favorite
        ? kAppPinkDarkColor
        : kInactiveHeartColor.withOpacity(0.28);
  }

  String getPlaylistName() {
    if (Provider.of<PlaylistNameData>(context).isPlayListNullApi())
      return 'Playlist Name';
    try {
      String name = AppLocalizations.of(context).languageCode() == 'ru'
          ? Provider.of<PlaylistNameData>(context, listen: false)
              .apiPlaylistNamesList
              .firstWhere(
                (element) =>
                    element.id ==
                    Provider.of<PlaylistData>(context, listen: false)
                        .getCurrentPlaylistModelApi(context)
                        .parentPlaylistId,
              )
              .titleRu
          : Provider.of<PlaylistNameData>(context, listen: false)
              .apiPlaylistNamesList
              .firstWhere(
                (element) =>
                    element.id ==
                    Provider.of<PlaylistData>(context, listen: false)
                        .getCurrentPlaylistModelApi(context)
                        .parentPlaylistId,
              )
              .titleEn;
      print('name = ' + name);
      return name;
    } catch (error) {
      return '';
    }
  }

  List<BarChartGroupData> getBarChartGroupData(int count) {
    List<BarChartGroupData> list = [];
    for (int i = 0; i < count; i++) {
      list.add(BarChartGroupData(
        barsSpace: 1,
        x: 0,
        barRods: [
          BarChartRodData(
            y: Provider.of<Player>(context).isPlayign
                ? Random().nextInt(255).toDouble()
                : Random().nextInt(55).toDouble(),
            colors: [kWelcomButtonDarkColor],
            width: 2,
          ),
        ],
        showingTooltipIndicators: [],
      ));
    }
    return list;
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(/*animDuration +*/
        Duration(milliseconds: 100));
    if (Provider.of<Player>(context, listen: false).isPlayign) {
      refreshState();
    }
  }

  Widget setSwiper(PlaylistData playlistData) {
    return InfinityPageView(
        onPageChanged: (index) async {
          playlistData.updateCurrentVibroIndexApi(index);

          var model = Provider.of<PlaylistData>(context, listen: false)
              .getCurrentPlaylistModelApi(context);

          playlistData.updateCurrentPlayListModelApi(
            model: model,
            notify: false,
          );

          Provider.of<Player>(context, listen: false)
              .updateCurrentPlayListModel(model: model);

          Provider.of<PlaylistNameData>(context, listen: false)
              .updateCurrentPlaylistApi(
                  Provider.of<PlaylistNameData>(context, listen: false)
                      .getPlaylistNameByIDApi(id: model.parentPlaylistId));

          if (Provider.of<Player>(context, listen: false).isPlayign) {
            Future.delayed(Duration(milliseconds: 500), () {
              playOrPause(isNeedChangePlayerStatus: false);
            });
          } else {
            Provider.of<Player>(context, listen: false).stopVibrations();
          }
        },
        controller: swiperController,
        physics: BouncingScrollPhysics(),
        itemCount: playlistData.getPlayListApi(context).length,
        itemBuilder: (context, index) {
          return Container(
            height: height / 3.34,
            width: height / 4.14,
            margin: EdgeInsets.only(
                bottom: 15, left: height / 40, right: height / 40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(31)),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.withOpacity(0.35),
                  spreadRadius: 0,
                  blurRadius: 8.0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(31)),
              child: CachedNetworkImage(
                fadeInDuration: Duration(milliseconds: 0),
                fadeOutDuration: Duration(milliseconds: 0),
                placeholder: (context, url) => Image.asset(
                  'assets/player_placeholder.png',
                  fit: BoxFit.cover,
                ),
                imageUrl: playlistData.getPlayListApi(context)[index]?.coverImg,
                fit: BoxFit.cover,
              ),
            ),
          );
        });
    /*return Swiper(
        onIndexChanged: (index) async {
          playlistData.updateCurrentVibroIndexApi(index);

          var model = Provider.of<PlaylistData>(context,
              listen: false)
              .getCurrentPlaylistModelApi(context);

          playlistData.updateCurrentPlayListModelApi(
            model: model,
            notify: false,
          );

          Provider.of<Player>(context, listen: false)
              .updateCurrentPlayListModel(model: model);

          Provider.of<PlaylistNameData>(context,
              listen: false)
              .updateCurrentPlaylistApi(
              Provider.of<PlaylistNameData>(context,
                  listen: false)
                  .getPlaylistNameByIDApi(
                  id: model.parentPlaylistId));

          if (Provider.of<Player>(context, listen: false)
              .isPlayign) {
            Future.delayed(Duration(milliseconds: 500),
                    () {
                  playOrPause(
                      isNeedChangePlayerStatus: false);
                });
          } else {
            Provider.of<Player>(context, listen: false)
                .stopVibrations();
          }
        },
        layout: SwiperLayout.CUSTOM,
        customLayoutOption: CustomLayoutOption(
          startIndex: -3,
          stateCount: 7,
        ).addRotate([
          -80.0 / 180,
          -80.0 / 180,
          -35.0 / 180,
          0.0,
          35.0 / 180,
          80.0 / 180,
          80.0 / 180
        ]).addTranslate([
          new Offset(-width / 1.78, -height / 25.6),
          new Offset(-width / 1.78, -height / 25.6),
          new Offset(-width / 1.78, -height / 25.6),
          new Offset(0.0, 0.0),
          new Offset(width / 1.78, -height / 25.6),
          new Offset(width / 1.78, -height / 25.6),
          new Offset(width / 1.78, -height / 25.6),
        ]).addScale([0.0, 0.0, 0.70, 1, 0.70, 0.0, 0.0],
            Alignment.bottomCenter),
        duration: playlistData.swiperAnimationDuration,
        controller: swiperController,
        physics: BouncingScrollPhysics(),
        itemCount:
        playlistData.getPlayListApi(context).length,
        index: playlistData.currentVibrationIndex,
        outer: false,
        fade: 0.8,
        viewportFraction: 1.0,
        scale: 1.0,
        loop: true,
        itemWidth: height / 4.14,
        itemHeight: height / 3.34,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.all(Radius.circular(31)),
              boxShadow: [
                BoxShadow(
                  color:
                  Colors.blueGrey.withOpacity(0.35),
                  spreadRadius: 0,
                  blurRadius: 8.0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius:
              BorderRadius.all(Radius.circular(31)),
              child: CachedNetworkImage(
                fadeInDuration: Duration(milliseconds: 0),
                fadeOutDuration:
                Duration(milliseconds: 0),
                placeholder: (context, url) =>
                    Image.asset(
                      'assets/player_placeholder.png',
                      fit: BoxFit.cover,
                    ),
                imageUrl: playlistData
                    .getPlayListApi(context)[index]
                    ?.coverImg,
                fit: BoxFit.cover,
              ),
            ),
          );
        });*/
  }
}
