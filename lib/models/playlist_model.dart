import 'package:sofy_new/models/vibration_model.dart';

class PlayListModel {
  String _name;
  int _subnameId;
  String _url;
  int _created;
  bool _favorite;
  List<VibrationModel> _vibrationsList;
  bool _isTrial;

  PlayListModel(
      {String name,
      int subnameId,
      String url,
      int created,
      bool favorite = false,
      List<VibrationModel> vibrationsList,
        bool isTrial = false}) {
    this._name = name;
    this._subnameId = subnameId;
    this._url = url;
    this._created = created;
    this._favorite = favorite;
    this._vibrationsList = vibrationsList;
    this._isTrial = isTrial;
  }

  List<VibrationModel> get vibrationsList => _vibrationsList;

  int get created => _created;

  String get name => _name;

  int get subnameId => _subnameId;

  String get url => _url;

  bool get favorite => _favorite;

  void setFavorite(bool flag) {
    _favorite = flag;
  }

  void setVibrationsList(List<VibrationModel> value) {
    _vibrationsList = value;
  }

  void setCreated(int value) {
    _created = value;
  }

  void setName(String value) {
    _name = value;
  }

  void setSubnameId(int value) {
    _subnameId = value;
  }

  void setUrl(String value) {
    _url = value;
  }

  bool get isTrial => _isTrial;

  void setIsTrial(bool value) {
    _isTrial = value;
  }

  @override
  String toString() {
    return 'PlayListModel{name: $_name, '
        'subnameId: $_subnameId, '
        'url: $_url, '
        'created: $_created, '
        'favorite: $_favorite, '
        'isTrial: $_isTrial '
        'vibrationsList: $_vibrationsList}';
  }
}
