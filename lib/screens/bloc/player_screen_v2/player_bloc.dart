import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofy_new/models/api_vibration_model.dart';

part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  PlayerBloc() : super(PlayerState.pause());
  @override
  Stream<PlayerState> mapEventToState(
    PlayerEvent event,
  ) async* {
    if (event is SelectVibration) {
      yield PlayerState.play(event.vibrationModel);
    } else if(event is StopVibration) {
      yield PlayerState.pause();
    }
  }
}
