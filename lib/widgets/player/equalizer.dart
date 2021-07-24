import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
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
        return _ActiveEqualizeLines(dWidth: dWidth, dHeight: dHeight,);
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

class _ActiveEqualizeLines extends StatefulWidget {
  const _ActiveEqualizeLines({Key key, this.dWidth, this.dHeight}) : super(key: key);

  final dWidth;
  final dHeight;
  @override
  __ActiveEqualizeLinesState createState() => __ActiveEqualizeLinesState();
}

class __ActiveEqualizeLinesState extends State<_ActiveEqualizeLines> {

  @override
  void initState() {
    loopState();
    super.initState();
  }

  Future<void> loopState() async {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
      });
      loopState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: widget.dHeight ?? height * 0.15,
      width: widget.dWidth ?? width,
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
                height: index % 2 == 0 ? Random().nextInt(108).toDouble() : Random().nextInt(60).toDouble(),
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
