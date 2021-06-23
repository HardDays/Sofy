import 'api_meta_model.dart';
import 'api_playlist_model.dart';

class ApiPlayListInfoModel {
  List<ApiPlayListModel> items;
  ApiMetaModel meta;
  String linksFirstHref;
  String linksLastHref;
  String linksSelfHref;

  ApiPlayListInfoModel(
      {this.items,
        this.meta,
        this.linksFirstHref,
        this.linksLastHref,
        this.linksSelfHref});

  factory ApiPlayListInfoModel.fromJson(Map<String, dynamic> jsonItem) {
    var arrayJson = jsonItem['items'] as List;
    return ApiPlayListInfoModel(
        items: arrayJson.map((tagJson) => ApiPlayListModel.fromJson(tagJson)).toList(),
        meta: ApiMetaModel.fromJson(jsonItem['_meta']),
        linksFirstHref: jsonItem['_links']['first']['href'],
        linksLastHref: jsonItem['_links']['last']['href'],
        linksSelfHref: jsonItem['_links']['self']['href']
    );
  }

  @override
  String toString() {
    return '{"items":$items, "_meta":$meta, "linksFirstHref":"$linksFirstHref", "linksLastHref":"$linksLastHref", "linksSelfHref":"$linksSelfHref"}';
  }
}
