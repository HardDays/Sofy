part of 'player_bloc.dart';

abstract class PlayerEvent extends Equatable {
  const PlayerEvent();
  @override
  List<Object> get props => [];
}

class SelectVibration extends PlayerEvent {
  final ApiVibrationModel vibrationModel;

  const SelectVibration({@required this.vibrationModel});
  @override
  List<Object> get props => [vibrationModel];
}

class StopVibration extends PlayerEvent {}
