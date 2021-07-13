import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/providers/player.dart';
import 'package:sofy_new/screens/bloc/player_screen_v2/player_bloc.dart';

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
                : 15,
            //Random().nextInt(55).toDouble(),
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
