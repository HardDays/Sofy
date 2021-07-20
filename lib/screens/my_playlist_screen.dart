import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import 'package:sofy_new/screens/player_screen.dart';
import 'package:sofy_new/screens/subscribe_screen.dart';
import 'package:sofy_new/widgets/playlist_lead_widget.dart';

class MyPlaylistScreen extends StatefulWidget {
  @override
  _MyPlaylistScreenState createState() => _MyPlaylistScreenState();
}

class _MyPlaylistScreenState extends State<MyPlaylistScreen> {
  double height, width;

  @override
  void initState() {
    Provider.of<PlaylistData>(context, listen: false)
        .updateVibrosByPlaylistIdApi(
      playlistId: Provider.of<PlaylistNameData>(context, listen: false)
          .getCurrentPlaylistNameApi()
          .id,
      notify: false,
    );
    super.initState();
    Analytics().sendEventReports(
      event: playlist_current_screen_show,
      attr: {
        'playlist_id': Provider.of<PlaylistNameData>(context, listen: false).getCurrentPlaylistNameApi(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    print('list lenght = ' +
        Provider.of<PlaylistData>(context)
            .vibrosByPlayListIdApi
            .length
            .toString());
    PCProvider pcProvider = Provider.of<PCProvider>(context, listen: false);
    var playlistData = Provider.of<PlaylistData>(context);

    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(left: 25, top: 38, right: 10, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      Provider.of<PlaylistNameData>(context).getCurrentNameApi(
                          AppLocalizations.of(context).languageCode()),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontFamily: Fonts.Exo2,
                        color: kListviewTitleColor,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        fontSize: height / 37.33, //24
                      ),
                    ),
                  ),
                  IconButton(
                    splashColor: kAppPinkDarkColor.withOpacity(0.1),
                    highlightColor: kAppPinkDarkColor.withOpacity(0.1),
                    padding: EdgeInsets.all(10),
                    onPressed: () {
                      /*Analytics().sendEventReports(
                        event: playlist_current_screen_close,
                      );*/
                      pcProvider.animateToPage(
                        index: PlayerScreen_PAGE_INDEX,
                      );
                    },
                    icon: Icon(
                      Icons.close,
                      color: kListviewSubTitleColor,
                      size: 23,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeLeft: true,
                removeRight: true,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 125.0),
                    physics: BouncingScrollPhysics(),
                    itemCount: playlistData.vibrosByPlayListIdApi.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.only(
                          left: width / 19.71,
                          top: 10,
                          bottom: 10,
                          right: 10.0,
                        ),
                        onTap: () {
                          var player =
                              Provider.of<Player>(context, listen: false);
                          if (!isFullAccess(playlistData, index)) {
                            Navigator.of(context).push(FadeRoute(
                                builder: (BuildContext context) =>
                                    SubscribeScreen(isFromSplash: false)));
                            return;
                          }
                          playlistData.updateCurrentPlayListModelApi(
                            model: playlistData.vibrosByPlayListIdApi[index],
                            notify: false,
                          );
                          if (player.currentPlayListModel != null &&
                              player.currentPlayListModel ==
                                  playlistData.vibrosByPlayListIdApi[index]) {
                            if (player.isPlaying) {
                              player.stopVibrations();
                              return;
                            }
                          }
                          player.stopVibrations();
                          Future.delayed(Duration(milliseconds: 200), () {
                            player.updateCurrentPlayListModel(
                              model: playlistData.vibrosByPlayListIdApi[index],
                            );
                            player.updateIsPlaying(flag: true);
                            player.startVibrate(
                              vibrations: playlistData
                                  .vibrosByPlayListIdApi[index].data,
                              startPosition: player.pausePosition,
                            );

                            Analytics().sendEventReports(
                              event: vibration_play,
                              attr: {
                                'vibration_id': playlistData
                                    .getCurrentPlaylistModelApi(context)
                                    .dateCreated,
                                'playlist_id': Provider.of<PlaylistNameData>(
                                        context,
                                        listen: false)
                                    .getCurrentPlaylistNameApi()
                                    .titleEn
                                    .replaceAll(' ', '_'),
                                'source': 'playlist_current_screen',
                              },
                            );
                          });
                        },
                        leading: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            PlayListLeadWidget(
                              url: playlistData
                                  .vibrosByPlayListIdApi[index].coverImg,
                              created: playlistData
                                  .vibrosByPlayListIdApi[index].dateCreated,
                              width: 56.0,
                              height: 56.0,
                            ),
                            (isFullAccess(playlistData, index))
                                ? Container(width: 0.0, height: 0.0)
                                : Container(
                                    width: 56.0,
                                    height: 56.0,
                                    decoration: BoxDecoration(
                                      color: kMyPlScrPlayListLeadWidgetColor,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ))
                          ],
                        ),
                        title: Text(
                          AppLocalizations.of(context).languageCode() == 'ru'
                              ? AppLocalizations.of(context).translate(
                                  '${Provider.of<PlaylistData>(context).vibrosByPlayListIdApi[index].titleRu}')
                              : AppLocalizations.of(context).translate(
                                  '${Provider.of<PlaylistData>(context).vibrosByPlayListIdApi[index].titleEn}'),
                          style: TextStyle(
                            fontFamily: Fonts.GilroyBold,
                            fontSize: height / 52.71,
                            //17
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            color: (isFullAccess(playlistData, index))
                                ? kListviewTitleColor
                                : kMyPlScrPlayListLeadWidgetTitColor,
                          ),
                        ),
                        subtitle: null,
                        trailing: Stack(
                          children: <Widget>[
                            IconButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              icon: (isFullAccess(playlistData, index))
                                  ? SvgPicture.asset(
                                      'assets/svg/heart_vector.svg',
                                      color: playlistData
                                              .vibrosByPlayListIdApi[index]
                                              .favorite
                                          ? kNavigBarInactiveColor
                                          : kListviewSubTitleColor,
                                      width: 17,
                                      height: 16.0,
                                    )
                                  : SvgPicture.asset('assets/svg/empty.svg'),
                              onPressed: () async {
                                if (!isFullAccess(playlistData, index)) {
                                  return;
                                }
                                print('list heart iconbutton');
                                await clickHeart(context,
                                    created: playlistData
                                        .vibrosByPlayListIdApi[index]
                                        .dateCreated);
                                playlistData.checkForFavoritesApi(context);

                                Analytics().sendEventReports(
                                  event: like_vibration,
                                  attr: {
                                    'vibration_id': playlistData
                                        .getCurrentPlaylistModelApi(context)
                                        .id,
                                  },
                                );
                              },
                              enableFeedback: false,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future clickHeart(BuildContext context, {int created}) async {
    return await PreferencesProvider().saveOrRemoveFavorite(created.toString());
  }

  bool isFullAccess(PlaylistData playlistData, int index) {
    bool isAppPurchase =
        Provider.of<SubscribeData>(context, listen: false).isAppPurchase;
    return (isAppPurchase ||
        (!isAppPurchase && playlistData.vibrosByPlayListIdApi[index].isTrial));
  }
}
