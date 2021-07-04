import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/models/PlaylistNameData.dart';
import 'package:sofy_new/models/api_vibration_data_model.dart';
import 'package:sofy_new/models/playlist_data.dart';
import 'package:sofy_new/models/subscribe_data.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/providers/player.dart';
import 'package:sofy_new/providers/preferences_provider.dart';
import 'package:sofy_new/screens/bloc/analytics.dart';
import 'package:sofy_new/screens/subscribe_screen.dart';
import 'package:sofy_new/widgets/playlist_lead_widget.dart';

// ignore: must_be_immutable
class AppListView extends StatelessWidget {
//  final PlaylistData playlistData;
  final bool isDivider;
  final Color dividerColor;
  final double paddingTopBottom;
  final double dividerHeight;
  bool isLiked;

  AppListView(
      {
      this.isLiked = false,
      this.isDivider = false,
      this.dividerColor = Colors.grey,
      this.paddingTopBottom = 10,
      this.dividerHeight = 0.0});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    var player = Provider.of<Player>(context, listen: false);
    var playlistData = Provider.of<PlaylistData>(context);

    print('list lenght = ' + playlistData.vibrosByPlayListIdApi.length.toString());

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeLeft: true,
      removeRight: true,
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 125.0),
        physics: BouncingScrollPhysics(),
        itemCount: playlistData.vibrosByPlayListIdApi.length,
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: EdgeInsets.only(
              left: 21.0,
              top: paddingTopBottom,
              bottom: paddingTopBottom,
              right: 10.0,
            ),
            onTap: () {

              if (isFullAccess(context, playlistData, index)) {
                playlistData.updateCurrentPlayListModelApi(
                  model: playlistData.vibrosByPlayListIdApi[index],
                  notify: false,
                );
                if (player.currentPlayListModel != null &&
                    player.currentPlayListModel == playlistData.vibrosByPlayListIdApi[index]) {
                  if (player.isPlaying) {
                    player.stopVibrations();
                    return;
                  }
                }
                player.stopVibrations();
                Future.delayed(Duration(milliseconds: 250), () {
                  player.updateCurrentPlayListModel(model: playlistData.vibrosByPlayListIdApi[index]);
                  player.updateIsPlaying(flag: true);
                  player.startVibrate(
                    vibrations: playlistData.vibrosByPlayListIdApi[index].data,
                    startPosition: player.pausePosition,
                  );

                  Analytics().sendEventReports(
                    event: vibration_play,
                    attr: {
                      'vibration_id': playlistData.getCurrentPlaylistModelApi(context).id,
                      'playlist_id': Provider.of<PlaylistNameData>(context, listen: false).getCurrentPlaylistNameApi().titleEn,
                      'source': 'playlist_' + Provider.of<PlaylistNameData>(context, listen: false).getCurrentNameApi(AppLocalizations.of(context).languageCode()) + '_screen',
                    },
                  );
                });
              } else {
                Navigator.of(context).push(FadeRoute(builder: (BuildContext context) => SubscribeScreen(isFromSplash: false)));
              }
            },
            leading: Stack (
              alignment: Alignment.center,
              children: <Widget>[
                PlayListLeadWidget(
                  url: playlistData.vibrosByPlayListIdApi[index].coverImg,
                  created: playlistData.vibrosByPlayListIdApi[index].dateCreated,
                  width: 56.0,
                  height: 56.0,
                ),
                (isFullAccess(context, playlistData, index)) ?
                Container(width: 0.0, height: 0.0) : Container (
                    width: 56.0,
                    height: 56.0,
                    decoration: BoxDecoration(
                      color: kAppListViewGreyColor,
                      borderRadius:
                      BorderRadius.all(Radius.circular(15)),
                    ))
              ],
            ),
            title: Text(
              AppLocalizations.of(context).languageCode() == 'ru' ? playlistData.vibrosByPlayListIdApi[index].titleRu : playlistData.vibrosByPlayListIdApi[index].titleEn,
              style: TextStyle(
                fontFamily: kFontFamilyGilroyBold,
                fontSize: height / 52.71,
                //17
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                color: (isFullAccess(context, playlistData, index)) ? kListviewTitleColor : kAppListViewNotColor,
              ),
            ),
            /*subtitle: Padding(
              padding: EdgeInsets.only(top: 6.0),
              child: Text(
                getTimeString(vibrations: playlistData.vibrosByPlayListIdApi[index].data),
                style: TextStyle(
                  fontFamily: kFontFamilyGilroy,
                  fontSize: height / 64,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                  color: (isFullAccess(context, playlistData, index)) ? kListviewSubTitleColor : Color(0x25242424),
                ),
              ),
            ),*/
            trailing: Stack(
              children: <Widget>[
                IconButton(
                  splashColor: kAppPinkDarkColor.withOpacity(0.7),
                  highlightColor: kAppPinkDarkColor.withOpacity(0.7),
                  icon: (isFullAccess(context, playlistData, index)) ?
                  SvgPicture.asset('assets/svg/heart_vector.svg',
                    color: playlistData.vibrosByPlayListIdApi[index].favorite ? kNavigBarInactiveColor : kListviewSubTitleColor,
                    width: 17,
                    height: 16.0,
                  )
                      : SvgPicture.asset('assets/svg/empty.svg'),
                  onPressed: () {},
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        enableFeedback: true,
                        customBorder: CircleBorder(side: BorderSide.none),
                        onTap: () async {
                          if (!isFullAccess(context, playlistData, index)) {
                            return;
                          }
                          print('list heart inkwell');
                          await clickHeart(context, created: playlistData.vibrosByPlayListIdApi[index].dateCreated,);
                          playlistData.checkForFavoritesApi(context);

                          Analytics().sendEventReports(
                            event: like_vibration,
                            attr: {
                              'vibration_id': playlistData.vibrosByPlayListIdApi[index].dateCreated,
                            },
                          );
                        }),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future clickHeart(BuildContext context, {int created}) async {
    return await PreferencesProvider().saveOrRemoveFavorite(created.toString());
  }

  String getTimeString({List<ApiVibrationDataModel> vibrations}) {
    int currentPlayTime = 0;
    vibrations.forEach((element) => currentPlayTime += element.duration);
    return DateFormat('mm:ss')
        .format(DateTime.fromMillisecondsSinceEpoch(currentPlayTime));
  }

  bool isFullAccess(BuildContext context,PlaylistData playlistData, int index) {
    bool isAppPurchase = Provider.of<SubscribeData>(context, listen: false).isAppPurchase;
    return (isAppPurchase || (!isAppPurchase && playlistData.vibrosByPlayListIdApi[index].isTrial) || isLiked);
  }
}

class FadeRoute<T> extends MaterialPageRoute<T> {
  FadeRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return new FadeTransition(opacity: animation, child: child);
  }
}
