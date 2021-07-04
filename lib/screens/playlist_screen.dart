import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/models/PlaylistNameData.dart';
import 'package:sofy_new/models/playlist_data.dart';
import 'package:sofy_new/providers/PageProvider.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/providers/player.dart';
import 'package:sofy_new/screens/bloc/analytics.dart';
import 'package:sofy_new/widgets/app_list_view.dart';
import 'package:sofy_new/widgets/neumorphic/neumorphic_button.dart';

class PlayListScreen extends StatefulWidget {
  @override
  _PlayListScreenState createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
  double height, width;
  double playPauseDepth = 3;

  @override
  void initState() {
    super.initState();
    Analytics().sendEventReports(
      event: 'playlist_' +
          Provider.of<PlaylistNameData>(context, listen: false)
              .getCurrentPlaylistNameApi()
              .titleEn +
          '_screen_show',
    );
  }

  @override
  Widget build(BuildContext context) {
    //print('playlist_screen');
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    PCProvider pcProvider = Provider.of<PCProvider>(context, listen: false);
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          width: width,
          height: height / 2.31, //357,
          child: CachedNetworkImage(
            placeholder: (context, url) => Image.asset(
              'assets/player_placeholder.png',
              fit: BoxFit.cover,
            ),
            imageUrl: Provider.of<PlaylistNameData>(context, listen: false)
                .getCurrentPlaylistNameApi()
                .coverImg,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          width: width,
          height: height / 2.51,
          //357
          padding: EdgeInsets.only(left: 0.0, top: 45),
          alignment: Alignment.topLeft,
          child: Stack(
            children: <Widget>[
              Container(
                width: 75.0,
                height: height / 40.33,
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/svg/back_vector.svg',
                  height: height / 40.33,
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      customBorder: CircleBorder(side: BorderSide.none),
                      onTap: () {
                        Analytics().sendEventReports(
                          event: 'playlist_' +
                              Provider.of<PlaylistNameData>(context,
                                      listen: false)
                                  .getCurrentNameApi(
                                      AppLocalizations.of(context)
                                          .languageCode())
                                  .replaceAll(' ', '_') +
                              '_screen_close',
                        );
                        Navigator.pop(context);
                      }),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: height / 3.37),
          padding: EdgeInsets.only(top: 25),
          decoration: BoxDecoration(
            color: kMainScreenScaffoldBackColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(31.0),
              topRight: Radius.circular(31.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                Provider.of<PlaylistNameData>(context, listen: false)
                    .getCurrentPlaylistNameApi()
                    .titleEn,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: kFontFamilyGilroyBold,
                  color: kListviewTitleColor,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  fontSize: height / 33.19,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                    width: height / 13,
                    height: height / 13,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: kPlaylistScrLinearGradColor,
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: kPlaylistScrShadow2Color.withOpacity(0.86),
                            blurRadius: 10.0,
                            offset: Offset(-2, -2)),
                        BoxShadow(
                            color: kPlaylistScrShadowColor.withOpacity(0.41),
                            blurRadius: 10.0,
                            offset: Offset(3, 3)),
                      ],
                    ),
                    child: NeumorphicCustomButton(
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.convex,
                            depth:
                                Provider.of<Player>(context).isPlaying ? -6 : 3,
                            intensity: 0.5,
                            shadowLightColorEmboss: kADNeumorphicShadowLightColorEmboss,
                            shadowDarkColor: kADNeumorphicShadowDarkColor,
                            shadowDarkColorEmboss: kADNeumorphicShadowDarkColorEmboss,
                            shadowLightColor: kADNeumorphicShadowLightColor,
                            color: kADNeumorphic3Color),
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(50)),
                        onClick: () {
                          var player =
                              Provider.of<Player>(context, listen: false);
                          var playlistData =
                              Provider.of<PlaylistData>(context, listen: false)
                                  .vibrosByPlayListIdApi
                                  .first;
                          player.updateCurrentPlayListModel(
                            model: playlistData,
                          );
                          player.updateIsPlaying(flag: !player.isPlaying);
                          if (player.isPlaying) {
                            player.startVibrate(
                              vibrations: playlistData.data,
                              startPosition: player.pausePosition,
                            );
                          } else {
                            player.stopVibrations();
                          }
                        },
                        padding: EdgeInsets.all(0.0),
                        child: Center(
                            child: Container(
                          height: height / 35,
                          width: height / 35,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage(
                                Provider.of<Player>(context).isPlaying
                                    ? 'assets/pause.png'
                                    : 'assets/play.png'),
                            fit: BoxFit.fitHeight,
                          )),
                        )))),
              ),
              SizedBox(height: 20),
              Expanded(
                child: AppListView(
                  isDivider: false,
                  isLiked: Provider.of<PlaylistNameData>(context, listen: false)
                              .getCurrentPlaylistNameApi()
                              .titleEn ==
                          'Liked'
                      ? true
                      : false,
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
