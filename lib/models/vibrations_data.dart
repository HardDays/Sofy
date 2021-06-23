import 'dart:collection';

import 'package:sofy_new/models/vibration_model.dart';

class VibrationsData {
  List<VibrationModel> _vibrationsData = [];

  UnmodifiableListView<VibrationModel> get vibrationsDataList {
    return UnmodifiableListView(_vibrationsData);
  }

  int get vibrationsCount {
    return _vibrationsData.length;
  }

  void addVibrationModel(VibrationModel vibrationModel) {
    _vibrationsData.add(vibrationModel);
  }

  void deleteVibrationModel(VibrationModel vibrationModel) {
    _vibrationsData.remove(vibrationModel);
  }

  void clearVibrationData() {
    _vibrationsData.clear();
  }
}