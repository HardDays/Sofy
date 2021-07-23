import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/providers/player.dart';
import 'package:sofy_new/screens/bloc/player_screen_v2/player_bloc.dart';

class Equalizer extends StatelessWidget {
  const Equalizer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        if(state.status == PlayerStatus.pause){
          return _EqualizeLines();
        }
        return Container(
          height: height * 0.15,
          padding: EdgeInsets.only(top: 10.0, bottom: 3.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(20, (index) {
              return Container(
                height: Provider.of<Player>(context).isPlaying
                    ? Random().nextInt(90).toDouble()
                    : 15,
                width: 7,
                decoration: BoxDecoration(
                    color: kWelcomButtonDarkColor,
                    borderRadius: BorderRadius.circular(3)),
              );
            }),
          ),
        );
      },
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