import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:sofy_new/models/api_vibration_data_model.dart';
import 'package:sofy_new/models/api_vibration_model.dart';
import 'package:sofy_new/library/vibration/vibration.dart';
import 'package:sofy_new/constants/constants.dart';


class Player extends ChangeNotifier {
  ApiVibrationModel _currentPlayListModel;

  bool isLoop = kIsLoop;
  bool _isPlayign = false;
  bool _isPausing = false;


  int sliderSpeedValue = kSliderSpeedValue;
  int speedValuesPosition = kSpeedValuesPosition;
  List<double> speedValues = kInitSpeedValues;

  int vibrationPosition = kVibrationPosition;
  int _pausePosition = 0;

  int currentPlayTime = kCurrentPlayTime;
  int durationAllVibration = kDurationAllVibration;
  int speedDurationDefault = kSpeedDurationDefault;
  int speedDurationInterval = kSpeedDurationInterval;
  Timer vibrateTimer, timeTrackingTimer;

  int get pausePosition => _pausePosition;
  bool get isPlayign => _isPlayign;
  ApiVibrationModel get currentPlayListModel => _currentPlayListModel;

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
