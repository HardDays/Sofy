import 'api_article_topic_model.dart';
import 'api_meta_model.dart';

class ApiArticleTopicInfoModel {
  List<ApiArticleTopicModel> items;
  ApiMetaModel meta;
  String linksFirstHref;
  String linksLastHref;
  String linksSelfHref;

  ApiArticleTopicInfoModel(
      {this.items,
        this.meta,
        this.linksFirstHref,
        this.linksLastHref,
        this.linksSelfHref});

  factory ApiArticleTopicInfoModel.fromJson(Map<String, dynamic> jsonItem) {
    var arrayJson = jsonItem['items'] as List;
    return ApiArticleTopicInfoModel(
        items: arrayJson.map((tagJson) => ApiArticleTopicModel.fromJson(tagJson)).toList(),
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
