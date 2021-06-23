import 'api_meta_model.dart';
import 'api_vibration_model.dart';

class ApiVibrationInfoModel {
  List<ApiVibrationModel> items;
  ApiMetaModel meta;
  String linksFirstHref;
  String linksLastHref;
  String linksSelfHref;

  ApiVibrationInfoModel(
      {this.items,
        this.meta,
        this.linksFirstHref,
        this.linksLastHref,
        this.linksSelfHref});

  factory ApiVibrationInfoModel.fromJson(Map<String, dynamic> jsonItem) {
    var arrayJson = jsonItem['items'] as List;
    String _linksFirstHref, _linksLastHref, _linksSelfHref;
    try {
      _linksFirstHref = jsonItem['_links']['first']['href'];
    } catch(e){
      print('=======> linksFirstHref e = $e');
    }
    try {
    _linksLastHref = jsonItem['_links']['last']['href'];
    } catch(e){
    print('=======> linksFirstHref e = $e');
    }
    try {
      _linksSelfHref = jsonItem['_links']['self']['href'];
    } catch(e){
      print('=======> linksFirstHref e = $e');
    }
    return ApiVibrationInfoModel(
        items: arrayJson.map((tagJson) => ApiVibrationModel.fromJson(tagJson)).toList(),
        meta: ApiMetaModel.fromJson(jsonItem['_meta']),
        linksFirstHref: _linksFirstHref,
        linksLastHref: _linksLastHref,
        linksSelfHref: _linksSelfHref
    );
  }

  @override
  String toString() {
    return '{"items":$items, "_meta":$meta, "linksFirstHref":"$linksFirstHref", "linksLastHref":"$linksLastHref", "linksSelfHref":"$linksSelfHref"}';
  }
}
