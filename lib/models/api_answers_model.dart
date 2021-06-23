import 'api_article_poll_model.dart';
import 'api_article_question_model.dart';

class ApiAnswersModel {
  int id;
  int questionId;
  int userId;
  String content;
  int publication;

  ApiAnswersModel(
      {this.id, this.questionId, this.userId, this.publication, this.content});

  factory ApiAnswersModel.fromJson(Map<String, dynamic> jsonItem) {
    return ApiAnswersModel(
        id: jsonItem['id'],
        questionId: jsonItem['question_id'],
        userId: jsonItem['user_id'],
        publication: jsonItem['publication'],
        content: jsonItem['content']);
  }
}
