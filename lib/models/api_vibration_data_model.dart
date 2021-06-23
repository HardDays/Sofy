class ApiVibrationDataModel {
  int amplitude;
  int duration;
  int noteNumber;
  int time;
  int wait;

  ApiVibrationDataModel(
      {this.amplitude,
        this.duration,
        this.noteNumber,
        this.time,
        this.wait});

  factory ApiVibrationDataModel.fromJson(Map<String, dynamic> jsonItem) {
    return ApiVibrationDataModel(
        amplitude: jsonItem['amplitude'],
        duration: jsonItem['duration'],
        noteNumber: jsonItem['noteNumber'],
        time: jsonItem['time'],
        wait: jsonItem['wait']
    );
  }

  @override
  String toString() {
    return '{"amplitude":$amplitude, "duration":$duration, "noteNumber":$noteNumber, "time":$time, "wait":"$wait"}';
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'wait': wait,
      'duration': duration,
      'amplitude': amplitude,
      'noteNumber':noteNumber
    };
  }

  bool get isCustomVibration {
    return noteNumber != 2;
  }
}

