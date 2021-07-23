import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/models/PlaylistNameData.dart';
import 'package:sofy_new/models/api_playlist_model.dart';
import 'package:sofy_new/models/api_vibration_model.dart';
import 'package:sofy_new/models/subscribe_data.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/providers/player.dart';
import 'package:sofy_new/screens/bloc/player_screen_v2/player_screen_bloc.dart';
import 'package:sofy_new/screens/subscribe_screen.dart';
import 'package:sofy_new/widgets/articles/background.dart';
import 'package:sofy_new/widgets/player/player_widgets.dart';

import 'bloc/analytics.dart';
import 'bloc/player_screen_v2/player_bloc.dart';

class PlayerScreenV2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return BlocBuilder<PlayerScreenBloc, PlayerScreenState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state is VibrationLoading)
          return Container(
            child: Text('Loading'),
          );
        if (state is ErrorState)
          return Container(
            child: Text(state.error),
          );
        final data = (state as VibrationsLoaded);
        return Stack(
          children: [
            Background(),
            _BackgroundImages(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 55,
                  ),
                  _SelectableButtons(
                    list: data.playlistNames,
                    id: data.selected,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  _CustomSlider(),
                  _VibrationList2(
                    path: data.path,
                    list: data.playlist,
                  ),
                  //_EqualizeLines(),
                  Equalizer(),
                  _PowerAndFireButton(
                    baseModel: data.playlist[0],
                    fireModel: data.playlist[4],
                  ),
                  // SizedBox(
                  //   height: 100,
                  // )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BackgroundImages extends StatelessWidget {
  const _BackgroundImages({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Positioned(
          left: 0,
          bottom: 120,
          child: SvgPicture.asset(
            'assets/svg/background1.svg',
          ),
        ),
        Positioned(
          right: 0,
          top: height / 4 * 2.6,
          child: SvgPicture.asset(
            'assets/svg/background2.svg',
          ),
        ),
        Positioned(
          right: 0,
          child: SvgPicture.asset('assets/svg/background3.svg'),
        ),
        Positioned(
          left: 0,
          top: height / 3.3,
          child: SvgPicture.asset('assets/svg/background4.svg'),
        ),
      ],
    );
  }
}

class _CustomSlider extends StatelessWidget {
  const _CustomSlider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height / 20 * 1.4,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: kPlayerScrV2ButtonThemeColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 14.0,
                  width: 4.0,
                  child: SvgPicture.asset(
                    'assets/svg/vibration_vector.svg',
                    color: kPlayerScrV2MeleePinkColor,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                SizedBox(
                  width: 6,
                  height: 22,
                  child: SvgPicture.asset('assets/svg/vibration_vector.svg'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      8,
                      (index) => Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          height: 8.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: kPlayerScrV2SliderBoxColor[index]),
                        ),
                      ),
                    ),
                  ),
                ),
                SliderTheme(
                  data: SliderThemeData(
                    trackShape: CustomTrackShape(),
                    thumbColor: Colors.redAccent,
                    thumbShape: CustomThumbShape(),
                    activeTrackColor: Colors.white.withOpacity(0),
                    inactiveTrackColor: Colors.white.withOpacity(0),
                    activeTickMarkColor: Colors.white.withOpacity(0),
                    inactiveTickMarkColor: Colors.white.withOpacity(0),
                  ),
                  child: MediaQuery.removePadding(
                    context: context,
                    removeLeft: true,
                    removeRight: true,
                    child: Slider(
                      divisions: 40,
                      min: 0,
                      max: 78,
                      value: Provider.of<SubscribeData>(context).isAppPurchase
                          ? Provider.of<Player>(context)
                              .sliderSpeedValue
                              .roundToDouble()
                          : 39,
                      onChanged: (value) {
                        if (Provider.of<SubscribeData>(context, listen: false)
                            .isAppPurchase) {
                          Provider.of<Player>(context, listen: false)
                              .updateSliderSpeedValue(value: value.round());
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SubscribeScreen(isFromSplash: false),
                            ),
                          );
                        }
                      },
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
                                  SubscribeScreen(isFromSplash: false),
                            ),
                          );
                        },
                        child: Container(
                          height: 32.0,
                          width: 32.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/lock_vibra.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    visible: Provider.of<SubscribeData>(context).isAppPurchase
                        ? false
                        : true,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 6,
                  height: 22,
                  child: SvgPicture.asset('assets/svg/vibration_vector.svg'),
                ),
                SizedBox(
                  width: 5,
                ),
                SizedBox(
                  height: 30.0,
                  width: 10,
                  child: SvgPicture.asset(
                    'assets/svg/vibration_vector.svg',
                    color: kPlayerScrV2PinkColor,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _BackgroundLinearColor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: kPlayerScrV2LinearGradientColor,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 1.0],
        ),
      ),
    );
  }
}

class _SelectableButtons extends StatelessWidget {
  const _SelectableButtons({Key key, @required this.list, @required this.id})
      : super(key: key);
  final List<ApiPlayListModel> list;
  final id;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final isAppPurchase = Provider.of<SubscribeData>(context).isAppPurchase;
    return Container(
      height: height / 20 * 1.1,
      width: double.infinity,
      decoration: BoxDecoration(
        color: kPlayerScrV2ButtonThemeColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List<Widget>.generate(list.length, (index) {
          return _SelectableButtonsItem(
            selected: id == list[index].id ? true : false,
            model: list[index],
            onTap: () {
              if (isAppPurchase) {
                BlocProvider.of<PlayerScreenBloc>(context)
                    .add(SetMode(id: list[index].id));
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubscribeScreen(isFromSplash: false),
                  ),
                );
              }
            },
          );
        }),
      ),
    );
  }
}

class _SelectableButtonsItem extends StatelessWidget {
  final Function onTap;
  final bool selected;
  final ApiPlayListModel model;

  const _SelectableButtonsItem(
      {Key key,
      @required this.onTap,
      this.selected = false,
      @required this.model})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.2, vertical: 5.2),
          child: Center(
            child: Text(
              //model.titleEn,
              AppLocalizations.of(context).translate(model.titleEn),
              style: TextStyle(
                  color: selected
                      ? kPlayerScrV2SelectedTextColor
                      : kPlayerScrV2UnselectedTextColor,
                  fontWeight: selected
                      ? FontWeight.bold
                      : FontWeight.normal,),
            ),
          ),
          decoration: selected
              ? BoxDecoration(
                  gradient: LinearGradient(
                    colors: kPlayerScrV2ButtonGradientColor,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      offset: Offset(0, 1.5),
                      color: kPlayerScrV2ShadowColor.withOpacity(0.5),
                      blurRadius: 3,
                    ),
                  ],
                )
              : BoxDecoration(),
        ),
      ),
    );
  }
}

class _VibrationList2 extends StatelessWidget {
  const _VibrationList2({Key key, @required this.list, @required this.path})
      : super(key: key);
  final List<ApiVibrationModel> list;
  final List<String> path;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final isAppPurchase = Provider.of<SubscribeData>(context).isAppPurchase;
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        return Consumer<Player>(
          builder: (context, provider, child) {
            return Container(
              height: height / 3,
              child: GridView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return CircleSelectableButton(
                    selected:
                        list[index].id == state?.model?.id ?? -1 ? true : false,
                    onTap: () async {
                      if (isAppPurchase ||
                          !isAppPurchase && list[index].isTrial) {
                        if (state?.model?.id == list[index].id) {
                          BlocProvider.of<PlayerBloc>(context)
                              .add(StopVibration());
                          pause(context: context);
                        } else {
                          provider.stopVibrations();
                          await Future.delayed(
                              Duration(milliseconds: 200), () {});
                          BlocProvider.of<PlayerBloc>(context).add(
                              SelectVibration(vibrationModel: list[index]));
                          provider.updateCurrentPlayListModel(
                              model: list[index]);
                          play(context: context, model: list[index]);
                        }
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SubscribeScreen(isFromSplash: false),
                          ),
                        );
                      }
                    },
                    model: list[index],
                    iconPath: path[index],
                  );
                },
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

void play({@required context, ApiVibrationModel model}) {
  var player = Provider.of<Player>(context, listen: false);
  player.updateIsPlaying(flag: true);
  player.startVibrate(
    vibrations: model.data,
    startPosition: player.pausePosition,
  );
  Analytics().sendEventReports(
    event: vibration_play,
    attr: {
      'vibration_id': model.id,
      'playlist_id': 'playlist_' +
          Provider.of<PlaylistNameData>(context, listen: false)
              .getCurrentPlaylistNameApi()
              .titleEn
              .replaceAll(' ', '_'),
    },
  );
}

void pause({@required context}) {
  var player = Provider.of<Player>(context, listen: false);
  player.updateIsPlaying(flag: false);
  player.pauseVibrations();
  Analytics().sendEventReports(
    event: vibration_pause,
    attr: {
      'vibration_id': player.currentPlayListModel.id,
      'playlist_id': 'playlist_' +
          Provider.of<PlaylistNameData>(context, listen: false)
              .getCurrentPlaylistNameApi()
              .titleEn
              .replaceAll(' ', '_'),
    },
  );
}

class _PowerAndFireButton extends StatelessWidget {
  const _PowerAndFireButton({Key key, this.baseModel, @required this.fireModel}) : super(key: key);

  final ApiVibrationModel baseModel;
  final ApiVibrationModel fireModel;

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<Player>(context, listen: false);
    final isAppPurchase = Provider.of<SubscribeData>(context).isAppPurchase;
    return Container(
      height: 150,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(),
          ),
          Expanded(
            flex: 3,
            child: PowerButton(
              onTap: () async {
                BlocProvider.of<PlayerBloc>(context).add(StopVibration());
                if (player.isPlaying) {
                  pause(context: context);
                  player.stopVibrations();
                } else {
                  if (player.currentPlayListModel != null) {
                    player.stopVibrations();
                    await Future.delayed(Duration(milliseconds: 200), () {});
                    BlocProvider.of<PlayerBloc>(context).add(SelectVibration(
                        vibrationModel: player.currentPlayListModel));
                    player.updateCurrentPlayListModel(
                        model: player.currentPlayListModel);
                    play(
                        context: context, model: player.currentPlayListModel);
                  } else {
                    player.stopVibrations();
                    await Future.delayed(Duration(milliseconds: 200), () {});
                    BlocProvider.of<PlayerBloc>(context).add(SelectVibration(
                        vibrationModel: baseModel));
                    player.updateCurrentPlayListModel(
                        model: baseModel);
                    play(
                        context: context, model: baseModel);
                  }
                }
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment(-1, 0),
              child: FireButton(
                onTap: () async {
                  if (isAppPurchase) {
                    if (player.currentPlayListModel != null) {
                      player.stopVibrations();
                      await Future.delayed(Duration(milliseconds: 200), () {});
                      BlocProvider.of<PlayerBloc>(context).add(SelectVibration(
                          vibrationModel: fireModel));
                      player.updateCurrentPlayListModel(
                          model: fireModel);
                      play(
                          context: context, model: fireModel);
                    }
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SubscribeScreen(isFromSplash: false),
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
}
