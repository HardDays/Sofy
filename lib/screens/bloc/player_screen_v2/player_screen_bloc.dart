import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofy_new/constants/vibration_path.dart';
import 'package:sofy_new/models/api_playlist_model.dart';
import 'package:sofy_new/models/api_vibration_model.dart';

part 'player_screen_event.dart';

part 'player_screen_state.dart';

class PlayerScreenBloc extends Bloc<PlayerScreenEvent, PlayerScreenState> {
  PlayerScreenBloc() : super(VibrationLoading());
  List<ApiPlayListModel> playlistNames;
  List<ApiVibrationModel> playlist;

  @override
  Stream<PlayerScreenState> mapEventToState(PlayerScreenEvent event,) async* {
    if (event is LoadVibrations) {
      yield VibrationLoading();
      try {
        playlistNames = event.playlistNames;
        final id = event.id;
        playlist = event.playlist;
        playlistNames.forEach((e) => print(e.titleEn));
        yield VibrationsLoaded(
            playlist: playlist.where((element) =>
            element.parentPlaylistId == id).take(6).toList(),
            playlistNames: playlistNames.take(3).toList(),
            path: vibrationPath[id],
            selected: event.id);
      } catch (e) {
        yield ErrorState(error: e.toString());
      }
    } else if (event is SetMode) {
      yield VibrationLoading();
      try {
        final id = event.id;
        yield VibrationsLoaded(
            playlist: playlist.where((element) =>
            element.parentPlaylistId == id).take(6).toList(),
            playlistNames: playlistNames.take(3).toList(),
            path: vibrationPath[id],
            selected: event.id);
      } catch (e) {
        yield ErrorState(error: e.toString());
      }
    }
  }
}
