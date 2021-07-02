part of 'player_screen_bloc.dart';

abstract class PlayerScreenEvent extends Equatable {
  const PlayerScreenEvent();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadVibrations extends PlayerScreenEvent {
  final List<ApiVibrationModel> playlist;
  final int id;
  final List<ApiPlayListModel> playlistNames;
  LoadVibrations({this.playlistNames, this.id, this.playlist});
}

class SetMode extends PlayerScreenEvent {
  final int id;

  SetMode({this.id});
}
