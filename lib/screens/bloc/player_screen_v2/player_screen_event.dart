part of 'player_screen_bloc.dart';

abstract class PlayerScreenEvent extends Equatable {
  const PlayerScreenEvent();

  @override
  List<Object> get props => [];
}

class LoadVibrations extends PlayerScreenEvent {
  final List<ApiVibrationModel> playlist;
  final int id;
  final List<ApiPlayListModel> playlistNames;

  LoadVibrations(
      {@required this.playlistNames,
      @required this.id,
      @required this.playlist});

  @override
  List<Object> get props => [playlist, id, playlistNames];
}

class SetMode extends PlayerScreenEvent {
  final int id;

  SetMode({@required this.id});
  @override
  List<Object> get props => [id];
}

