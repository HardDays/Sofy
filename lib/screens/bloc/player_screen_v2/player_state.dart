part of 'player_bloc.dart';

enum PlayerStatus { play, pause, playing }

class PlayerState extends Equatable {
  const PlayerState._({this.model, @required this.status});

  final ApiVibrationModel model;

  PlayerState.play(ApiVibrationModel model): this._(status: PlayerStatus.play, model: model);
  PlayerState.pause(): this._(status: PlayerStatus.pause);
  final PlayerStatus status;

  @override
  List<Object> get props => [status, model];
}
