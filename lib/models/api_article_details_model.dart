import 'api_article_details_info_model.dart';
class ApiArticleDetailsModel {
  String error;
  ApiArticleDetailsInfoModel info;
  String result;
  int status;

  ApiArticleDetailsModel(
      {this.error,
        this.info,
        this.result,
        this.status});

  factory ApiArticleDetailsModel.fromJson(Map<String, dynamic> jsonItem) {
    return ApiArticleDetailsModel(
      error: jsonItem['error'],
      info: ApiArticleDetailsInfoModel.fromJson(jsonItem['info']),
      result: jsonItem['result'],
      status: jsonItem['status']
    );
  }

  @override
  String toString() {
    return '{"error":"$error", "result":"$result", "status":$status, "info":$info}';
  }
}
