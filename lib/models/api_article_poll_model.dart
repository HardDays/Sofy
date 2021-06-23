import 'api_article_variants_model.dart';

class ApiArticlePollModel {
  String blockName;
  String buttonName;
  int dateCreated;
  List<ApiArticleVariantsModel> variants;

  ApiArticlePollModel(
      {this.blockName,
        this.buttonName,
        this.dateCreated,
        this.variants});

  factory ApiArticlePollModel.fromJson(Map<String, dynamic> jsonItem) {
    var arrayJson = jsonItem['variants'] as List;
    return ApiArticlePollModel(
      blockName: jsonItem['block_name'],
      buttonName: jsonItem['button_name'],
      dateCreated: jsonItem['date_created'],
        variants: arrayJson.map((tagJson) => ApiArticleVariantsModel.fromJson(tagJson)).toList());
  }
}
