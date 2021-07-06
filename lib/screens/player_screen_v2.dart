import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
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
            _BackgroundLinearColor(),
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
                  _PowerAndFireButton(),
                  SizedBox(
                    height: 100,
                  )
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

class _EqualizeLines extends StatelessWidget {
  const _EqualizeLines({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.15,
      child: SvgPicture.asset('assets/svg/equalize_lines.svg'),
    );
  }
}

class _CustomSlider extends StatelessWidget {
  const _CustomSlider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height / 20 * 1.6,
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
                    //thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                    //overlayColor: Colors.red.withAlpha(32),
                    //overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
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
                      value: Provider.of<Player>(context).sliderSpeedValue.roundToDouble(),
                      // Provider.of<SubscribeData>(context)
                      //     .isAppPurchase
                      //     ? Provider.of<Player>(context)
                      //     .sliderSpeedValue
                      //     .roundToDouble()
                      //     : 39,
                      onChanged: (value) {
                        Provider.of<Player>(context,
                            listen: false)
                            .updateSliderSpeedValue(
                            value: value.round());
                        //value = value;
                      },
                    ),
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

class CustomThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(15);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {Animation<double> activationAnimation,
      Animation<double> enableAnimation,
      bool isDiscrete,
      TextPainter labelPainter,
      RenderBox parentBox,
      SliderThemeData sliderTheme,
      TextDirection textDirection,
      double value,
      double textScaleFactor,
      Size sizeWithOverflow}) {
    final Canvas canvas = context.canvas;
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: kPlayerScrV2SliderColor,
      ).createShader(Rect.fromCircle(
        center: center,
        radius: 15,
      ));
    canvas.drawCircle(center, 12, paint);
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
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
    return Container(
      height: height / 20 * 1.3,
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
              BlocProvider.of<PlayerScreenBloc>(context)
                  .add(SetMode(id: list[index].id));
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
          margin: EdgeInsets.all(4),
          child: Center(
            child: Text(
              //model.titleEn,
              AppLocalizations.of(context).translate(model.titleEn),
              style: TextStyle(
                  color: selected
                      ? kPlayerScrV2SelectedTextColor
                      : kPlayerScrV2UnselectedTextColor),
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

class CircleSelectableButton extends StatelessWidget {
  const CircleSelectableButton(
      {Key key,
      this.selected = false,
      @required this.iconPath,
      @required this.model,
      this.onTap})
      : super(key: key);

  final ApiVibrationModel model;
  final bool selected;
  final String iconPath;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: width / 6,
            width: width / 6,
            decoration: BoxDecoration(
              gradient: selected
                  ? RadialGradient(
                      center: Alignment(0.07, 0.12),
                      stops: [0.0, 0.7, 1],
                      colors: [
                        Color(0xFFffe1e8),
                        Color(0xFFffe1e8),
                        Color(0xFFffcfda)
                      ],
                    )
                  : null,
              color: selected ? Color(0xFFFFE1E8) : Color(0xFFFFFFFF),
              //borderRadius: BorderRadius.circular(width / 12),
              shape: BoxShape.circle,
              boxShadow: selected
                  ? null
                  : [
                      BoxShadow(
                        offset: Offset(1, 4),
                        color: Color(0xFFE2BED8),
                        blurRadius: 8,
                        //spreadRadius: 0.1,
                      ),
                    ],
            ),
            child: ShaderMask(
              shaderCallback: (Rect image) {
                if (selected) {
                  return LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFFD2DC), Color(0xFFF95C8F)],
                    stops: [0.45, 0.65],
                  ).createShader(image);
                }
                return LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFBBCA).withOpacity(0.5),
                    Color(0xFFFFBBCA).withOpacity(0.5)
                  ],
                ).createShader(image);
              },
              child: Image.asset(
                iconPath,
                scale: 1.5,
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            //model.titleEn,
            AppLocalizations.of(context).translate(model.titleEn),
            style: TextStyle(color: Color(0xFFFDAABC)),
          )
        ],
      ),
    );
  }
}

class _VibrationList extends StatelessWidget {
  const _VibrationList({Key key, @required this.list, @required this.path})
      : super(key: key);
  final List<ApiVibrationModel> list;
  final List<String> path;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height / 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List<Widget>.generate(3, (index) {
              return CircleSelectableButton(
                model: list[index],
                iconPath: path[index],
              );
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List<Widget>.generate(3, (index) {
              return CircleSelectableButton(
                model: list[index + 3],
                iconPath: path[index + 3],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class Equalizer extends StatelessWidget {
  const Equalizer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        return Expanded(
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
                barGroups: getBarChartGroupData(26, context),
              ),
            ),
          ),
        );
      },
    );
  }

  List<BarChartGroupData> getBarChartGroupData(int count, context) {
    List<BarChartGroupData> list = [];
    for (int i = 0; i < count; i++) {
      list.add(BarChartGroupData(
        barsSpace: 1,
        x: 0,
        barRods: [
          BarChartRodData(
            y: Provider.of<Player>(context).isPlaying
                ? Random().nextInt(255).toDouble()
                : Random().nextInt(55).toDouble(),
            colors: [kWelcomButtonDarkColor],
            width: 5,
          ),
        ],
        showingTooltipIndicators: [],
      ));
    }
    return list;
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
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        return Consumer<Player>(
          builder: (context, provider, child) {
            //print('ras');
            return Container(
              height: height / 3,
              child: GridView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return CircleSelectableButton(
                    selected:
                        list[index].id == state?.model?.id ?? -1 ? true : false,
                    onTap: () async {
                      if (state?.model?.id == list[index].id) {
                        BlocProvider.of<PlayerBloc>(context)
                            .add(StopVibration());
                        pause(context: context, model: list[index]);
                      } else {
                        provider.stopVibrations();
                        await Future.delayed(
                            Duration(milliseconds: 200), () {});
                        BlocProvider.of<PlayerBloc>(context)
                            .add(SelectVibration(vibrationModel: list[index]));
                        provider.updateCurrentPlayListModel(model: list[index]);
                        // provider.updateIsPlaying(flag: true);
                        // provider.startVibrate(
                        //   vibrations: list[index].data,
                        //   startPosition: provider.pausePosition,
                        // );
                        play(context: context, model: list[index]);
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

void pause({@required context, ApiVibrationModel model}) {
  var player = Provider.of<Player>(context, listen: false);
  player.updateIsPlaying(flag: false);
  player.pauseVibrations();
  Analytics().sendEventReports(
    event: vibration_pause,
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

class _PowerAndFireButton extends StatelessWidget {
  const _PowerAndFireButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<Player>(context, listen: false);
    return Expanded(
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Container(),
          ),
          Expanded(
            flex: 3,
            child: PowerButton(
              onTap: () {
                BlocProvider.of<PlayerBloc>(context).add(StopVibration());
                if(player.isPlaying) {
                  player.updateIsPlaying(flag: false);
                  player.pauseVibrations();
                  player.stopVibrations();
                }
                //pause(context: context);
                //stop(context: context);
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment(-1, 0),
              child: FireButton(),
            ),
          ),
        ],
      ),
    );
  }
}

class PowerButton extends StatelessWidget {
  const PowerButton({Key key, this.onTap}) : super(key: key);
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 125,
        height: 125,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(3, 4),
                color: Color(0xFFdbbfd5),
                blurRadius: 8,
                //spreadRadius: 0.1,
              )
            ],
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFD8E1),
                Color(0xFFFDB0C1),
                Color(0xFFE5356F),
              ],
              stops: [0.0, 0.3, 0.8],
            )),
        padding: const EdgeInsets.all(40),
        child: SvgPicture.asset(
          'assets/svg/power.svg',
          width: 40,
          height: 40,
          color: Colors.white,
        ),
      ),
    );
  }
}

class FireButton extends StatelessWidget {
  const FireButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xffFCEFFC),
            boxShadow: [
              BoxShadow(
                offset: Offset(3, 3),
                color: Color(0xFFdbbfd5),
                blurRadius: 4,
                //spreadRadius: 0.1,
              )
            ]),
        width: 40,
        height: 40,
        child: Image.asset(
          'assets/fire.png',
          scale: 3,
        ),
      ),
    );
  }
}
