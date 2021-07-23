import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/size_config.dart';
import 'package:sofy_new/providers/player.dart';
import 'package:sofy_new/screens/bloc/player_screen_v2/player_bloc.dart';

class Equalizer extends StatelessWidget {
  const Equalizer({Key key, this.dWidth, this.dHeight}) : super(key: key);
  final dWidth;
  final dHeight;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        if (state.status == PlayerStatus.pause) {
          return _EqualizeLines(
            dHeight: dHeight,
            dWidth: dWidth,
          );
        }
        return Container(
          height: dHeight ?? height * 0.15,
          width: dWidth ?? width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(20, (index) {
              return Row(
                children: [
                  SizedBox(
                    width: 6 /
                        Layout.width *
                        Layout.multiplier *
                        SizeConfig.blockSizeHorizontal,
                  ),
                  Container(
                    height: Provider.of<Player>(context).isPlaying
                        ? Random().nextInt(108).toDouble()
                        : 15,
                    width: 6 /
                        Layout.width *
                        Layout.multiplier *
                        SizeConfig.blockSizeHorizontal,
                    decoration: BoxDecoration(
                        color: Color(0xFFEE145C).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(3)),
                  ),
                  SizedBox(
                    width: 6 /
                        Layout.width *
                        Layout.multiplier *
                        SizeConfig.blockSizeHorizontal,
                  )
                ],
              );
            }),
          ),
        );
      },
    );
  }
}

class _EqualizeLines extends StatelessWidget {
  const _EqualizeLines({Key key, this.dHeight, this.dWidth}) : super(key: key);
  final dHeight;
  final dWidth;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: dHeight ?? height * 0.15,
      width: dWidth ?? width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(20, (index) {
          return Row(
            children: [
              SizedBox(
                width: 6 /
                    Layout.width *
                    Layout.multiplier *
                    SizeConfig.blockSizeHorizontal,
              ),
              Container(
                height: equalizerValues[index].toDouble(),
                width: 6 /
                    Layout.width *
                    Layout.multiplier *
                    SizeConfig.blockSizeHorizontal,
                decoration: BoxDecoration(
                    color: Color(0xFFEE145C).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(3)),
              ),
              SizedBox(
                width: 6 /
                    Layout.width *
                    Layout.multiplier *
                    SizeConfig.blockSizeHorizontal,
              )
            ],
          );
        }),
      ),
    );
  }
}
