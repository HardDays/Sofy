import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:sofy_new/models/api_vibration_data_model.dart';
import 'package:sofy_new/models/api_vibration_model.dart';
import 'package:sofy_new/library/vibration/vibration.dart';


class Player extends ChangeNotifier {
  ApiVibrationModel _currentPlayListModel;

  bool isLoop = false;
  bool _isPlayign = false;
  bool _isPausing = false;


  int sliderSpeedValue = 62;
  int speedValuesPosition = 30;
  List<double> speedValues = [
    4,
    3.9, 3.8, 3.7, 3.6, 3.5, 3.4, 3.3, 3.2, 3.1, 3,
    2.9, 2.8, 2.7, 2.6, 2.5, 2.4, 2.3, 2.2, 2.1, 2,
    1.9, 1.8, 1.7, 1.6, 1.5, 1.4, 1.3, 1.2, 1.1, 1,
    0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1];

  int vibrationPosition = 0;
  int _pausePosition = 0;

  int currentPlayTime = 0;
  int durationAllVibration = 0;
  int speedDurationDefault = 30;
  int speedDurationInterval = 30;
  Timer vibrateTimer, timeTrackingTimer;

  int get pausePosition => _pausePosition;
  bool get isPlayign => _isPlayign;
  ApiVibrationModel get currentPlayListModel => _currentPlayListModel;

   static const int DEFAULT_VIBRATION_DURATION = 600;

  String getCurrentTimeString(/*{List<VibrationModel> vibrations}*/) {
    return DateFormat('m:ss').format(
        DateTime.fromMillisecondsSinceEpoch(
            currentPlayTime
        ));
  }

  void updateCurrentPlayTime({int time, bool notify = true}) {
    currentPlayTime = time;
    if (notify) notifyListeners();
  }

  void changeVibrationSpeed({int sliderSpeedValue}) {
    speedValuesPosition = sliderSpeedValue ~/ 2;
    speedDurationInterval = (speedDurationDefault*
        speedValues[speedValuesPosition]).round();
    modifyCurrentPlayTime();
  }

  void updateSliderSpeedValue({int value, bool notify = true}) {
    sliderSpeedValue = value;
    changeVibrationSpeed(sliderSpeedValue: sliderSpeedValue);
    if (notify) notifyListeners();
  }

  void updateIsPlaying({bool flag, bool notify = true}) {
    _isPlayign = flag;
    if (notify) notifyListeners();
  }

  void updateCurrentPlayListModel({ApiVibrationModel model}) {
    _currentPlayListModel = model;
    durationAllVibration = 0;
    model.data
        .forEach((element) => durationAllVibration += element.duration);
  }

  void cancelTimers() {
    if (timeTrackingTimer != null && timeTrackingTimer.isActive)
      timeTrackingTimer.cancel();
  }

  void stopVibrations() {
    zeroingAllVariables();
  }

  void pauseVibrations({List<ApiVibrationDataModel> vibrations}) {
    int time = 0;
    vibrations.sublist(0, vibrationPosition).forEach((element) => time += element.duration);
    updateCurrentPlayTime(time: time);
    updateIsPlaying(flag: false);
    _pausePosition = vibrationPosition;
    Vibration.cancel();
    _isPausing = true;
  }

  void startVibrate({
    List<ApiVibrationDataModel> vibrations,
    int startPosition = 0,
  }) async {
    print('startVibrate $startPosition');
    if (await canVibrate()) {
      _isPausing = false;
      modifyCurrentPlayTime();
      await vibrateMain(
        vibrations: vibrations,
        startPosition: startPosition,
      );
    }
  }

  ApiVibrationDataModel transformVibration({ApiVibrationDataModel vibration}) {
    return ApiVibrationDataModel(
      time: vibration.time,
      wait: (vibration.wait * speedValues[speedValuesPosition]).round(),
      duration:
          (vibration.duration * speedValues[speedValuesPosition]).round(),
      amplitude: vibration.amplitude,
    );
  }

  Future<void> vibrateMain(
      {List<ApiVibrationDataModel> vibrations, int startPosition}) async {
    for (var i = startPosition; i < vibrations.length; i++) {
      if (_isPlayign) {
        await vibrateOnePattern(
            pattern: transformVibration(vibration: vibrations[i]));
        vibrationPosition = i;
      } else {
        if (_pausePosition == 0) vibrationPosition = 0;
        break;
      }
    }
    if (vibrationPosition == vibrations.length - 1 && !_isPausing) {
        zeroingAllVariables(isPlay: true);
        if (_currentPlayListModel != null) {
          startVibrate(
            vibrations: _currentPlayListModel.data,
            startPosition: _pausePosition,
          );
        }
    }
  }

  void modifyCurrentPlayTime() {
    if (timeTrackingTimer != null && timeTrackingTimer.isActive)
      timeTrackingTimer.cancel();
    timeTrackingTimer =
        Timer.periodic(Duration(milliseconds: speedDurationInterval), (timer) {
      if (_isPlayign) {
        if (currentPlayTime < durationAllVibration) {
          int newTime = currentPlayTime + speedDurationDefault;
          updateCurrentPlayTime(time: newTime);
        }
        else
          timer.cancel();
      }
    });

  }
  void zeroingAllVariables({bool isPlay = false}) {
    updateIsPlaying(flag: isPlay);
    updateCurrentPlayTime(time: 0);
    cancelTimers();
    vibrationPosition = 0;
    _pausePosition = 0;
  }

  Future<void> vibrateOnePattern({ApiVibrationDataModel pattern}) async {
    if (pattern.wait > 0) {
      if (pattern.isCustomVibration) {
        await vibrateWait(milliseconds: pattern.wait);
      } else {
        await vibrateWait(milliseconds: DEFAULT_VIBRATION_DURATION);
      }
      if (pattern.amplitude > 0) {
        if (pattern.duration > 0) {
          if (pattern.isCustomVibration) {
            Vibration.vibrate(duration:pattern.duration, amplitude: pattern.amplitude);
          } else {
            Vibration.systemVibrate();
          }
        }
      }
    } else if (pattern.wait == 0) {
      if (pattern.amplitude > 0) {
        if (pattern.duration > 0) {
          if (pattern.isCustomVibration) {
            Vibration.vibrate(duration:pattern.duration, amplitude: pattern.amplitude);
            await vibrateWait(milliseconds: pattern.duration);
          } else {
            Vibration.systemVibrate();
            await vibrateWait(milliseconds:DEFAULT_VIBRATION_DURATION);
          }
        }
      }
    }
  }

  Future<void> vibrateWait({int milliseconds}) async {
    return Future.delayed(Duration(milliseconds: milliseconds), () {});
  }

  Future<bool> canVibrate() async {
    if (await Vibration.hasCustomVibrationsSupport())
      return true;
    else {
      print("Device can't vibrate");
      return false;
    }
  }
}
