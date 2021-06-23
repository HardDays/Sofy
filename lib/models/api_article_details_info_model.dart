import 'api_article_model.dart';

class ApiArticleDetailsInfoModel {
  ApiArticleModel article;

  ApiArticleDetailsInfoModel(
      {this.article,});

  factory ApiArticleDetailsInfoModel.fromJson(Map<String, dynamic> jsonItem) {
    return ApiArticleDetailsInfoModel(
        article: ApiArticleModel.fromJson(jsonItem['article'])
    );
  }

  @override
  String toString() {
    return '{"article":$article}';
  }
}
