import 'api_article_articles_model.dart';
import 'api_meta_model.dart';

class ApiArticlesInfoModel {
  List<ApiArticlesModel> items;
  ApiMetaModel meta;
  String linksFirstHref;
  String linksLastHref;
  String linksSelfHref;

  ApiArticlesInfoModel(
      {this.items,
      this.meta,
      this.linksFirstHref,
      this.linksLastHref,
      this.linksSelfHref});

  factory ApiArticlesInfoModel.fromJson(
      Map<String, dynamic> jsonItem, bool isNew) {
    var arrayJson = jsonItem['items'] as List;
    return isNew
        ? ApiArticlesInfoModel(
            items: arrayJson
                .map((tagJson) => ApiArticlesModel.fromJson(tagJson))
                .toList(),
          )
        : ApiArticlesInfoModel(
            items: arrayJson
                .map((tagJson) => ApiArticlesModel.fromJson(tagJson))
                .toList(),
            meta: ApiMetaModel.fromJson(jsonItem['_meta']),
            /*linksFirstHref: jsonItem['_links']['first']['href'],
            linksLastHref: jsonItem['_links']['last']['href'],
            linksSelfHref: jsonItem['_links']['self']['href']*/);
  }

  @override
  String toString() {
    return '{"items":$items, "_meta":$meta, "linksFirstHref":"$linksFirstHref", "linksLastHref":"$linksLastHref", "linksSelfHref":"$linksSelfHref"}';
  }
}
