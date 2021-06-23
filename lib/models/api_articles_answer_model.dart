import 'package:sofy_new/models/api_articles_info_model.dart';

class ApiArticlesAnswerModel {
  String error;
  ApiArticlesInfoModel info;
  String result;
  int status;

  ApiArticlesAnswerModel(
      {this.error,
        this.info,
        this.result,
        this.status});

  factory ApiArticlesAnswerModel.fromJson(Map<String, dynamic> jsonItem, isNew) {
    return ApiArticlesAnswerModel(
      error: jsonItem['error'],
      info: ApiArticlesInfoModel.fromJson(jsonItem['info'], isNew),
      result: jsonItem['result'],
      status: jsonItem['status']
    );
  }

  @override
  String toString() {
    return '{"error":"$error", "result":"$result", "status":$status, "info":$info}';
  }
}
