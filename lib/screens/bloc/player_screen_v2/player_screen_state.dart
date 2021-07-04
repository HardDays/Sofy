part of 'player_screen_bloc.dart';

abstract class PlayerScreenState extends Equatable {
  const PlayerScreenState();

  @override
  List<Object> get props => [];
}

class VibrationLoading extends PlayerScreenState {}

class VibrationsLoaded extends PlayerScreenState {
  final List<ApiVibrationModel> playlist;
  final List<ApiPlayListModel> playlistNames;
  final List<String> path;
  final int selected;

  VibrationsLoaded(
      {this.playlistNames, this.playlist, this.path, this.selected});

  @override
  List<Object> get props => [playlist, playlistNames, path, selected];
}

class ErrorState extends PlayerScreenState {
  final String error;

  ErrorState({this.error});

  @override
  List<Object> get props => [error];
}
