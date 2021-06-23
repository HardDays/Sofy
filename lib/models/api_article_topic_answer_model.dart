import 'api_article_topic_info_model.dart';

class ApiArticleTopicAnswerModel {
  String error;
  ApiArticleTopicInfoModel info;
  String result;
  int status;

  ApiArticleTopicAnswerModel(
      {this.error,
        this.info,
        this.result,
        this.status});

  factory ApiArticleTopicAnswerModel.fromJson(Map<String, dynamic> jsonItem) {
    return ApiArticleTopicAnswerModel(
      error: jsonItem['error'],
      info: ApiArticleTopicInfoModel.fromJson(jsonItem['info']),
      result: jsonItem['result'],
      status: jsonItem['status']
    );
  }

  @override
  String toString() {
    return '{"error":"$error", "result":"$result", "status":$status, "info":$info}';
  }
}
