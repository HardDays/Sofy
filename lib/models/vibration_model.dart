class VibrationModel {
  int _time;
  int _wait;
  int _duration;
  int _amplitude;
  int _noteNumber;


  VibrationModel({int time, int wait, int duration, int amplitude, int noteNumber}) {
    this._time = time;
    this._wait = wait;
    this._duration = duration;
    this._amplitude = amplitude;
    this._noteNumber = noteNumber;

  }


  @override
  String toString() {
    return 'Model{time: $_time, wait: $_wait, duration: $_duration, amplitude: $_amplitude, noteNumber: $_noteNumber}';
  }

  int get getAmplitude => _amplitude;

  void setAmplitude(int value) {
    _amplitude = value;
  }

  int get getDuration => _duration;

  void setDuration(int value) {
    _duration = value;
  }

  int get getWait => _wait;

  void setWait(int value) {
    _wait = value;
  }

  int get getTime => _time;

  void setTime(int value) {
    _time = value;
  }

  int get noteNumber => _noteNumber;

  void setNoteNumber(int value) {
    _noteNumber = value;
  }


  bool get isCustomVibration {
    return _noteNumber != 2;
  }



}