import 'api_article_poll_model.dart';
import 'api_article_question_model.dart';

class ApiArticleModel {
  String articleTopicId;
  String isPaid;
  String coverImg;
  String title;
  String content;
  String langCode;
  String authorUserId;
  String likesCount;
  String view;
  String popular;
  String repliesCount;
  ApiArticlePollModel apiArticlePollModel;
  ApiArticleQuestionModel apiArticleQuestionModel;
  int rating;

  ApiArticleModel(
      {this.articleTopicId,
        this.isPaid,
        this.coverImg,
        this.title,
        this.content,
        this.langCode,
        this.authorUserId,
        this.likesCount,
        this.view,
        this.popular,
        this.repliesCount,
        this.apiArticlePollModel,
        this.apiArticleQuestionModel,
        this.rating});

  factory ApiArticleModel.fromJson(Map<String, dynamic> jsonItem) {
    return ApiArticleModel(
      articleTopicId: jsonItem['article_topic_id'],
      isPaid: jsonItem['is_paid'],
      coverImg: jsonItem['cover_img'],
      title: jsonItem['title'],
      content: jsonItem['content'],
      langCode: jsonItem['lang_code'],
      authorUserId: jsonItem['author_user_id'],
      likesCount: jsonItem['likes_count'],
      view: jsonItem['view'],
      popular: jsonItem['popular'],
      repliesCount: jsonItem['replies_count'],
      apiArticlePollModel: ApiArticlePollModel.fromJson(jsonItem['poll']),
      apiArticleQuestionModel: jsonItem['question'] != null ? ApiArticleQuestionModel.fromJson(jsonItem['question']) : null,
      rating: jsonItem['rating'] is int ? jsonItem['rating'] : -1);
  }
}
