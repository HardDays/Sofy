import '../api_article_articles_model.dart';

class ApiFavTopicsAnswerModel {
  String error;
  List<ApiFavTopicsInfoModel> info;
  String result;
  int status;

  ApiFavTopicsAnswerModel({this.error, this.info, this.result, this.status});

  factory ApiFavTopicsAnswerModel.fromJson(Map<String, dynamic> jsonItem) {
    var arrayJson = jsonItem['info'] as List;
    return ApiFavTopicsAnswerModel(
        error: jsonItem['error'],
        info: arrayJson
            .map((tagJson) => ApiFavTopicsInfoModel.fromJson(tagJson))
            .toList(),
        result: jsonItem['result'],
        status: jsonItem['status']);
  }

  @override
  String toString() {
    return '{"error":"$error", "result":"$result", "status":$status, "info":$info}';
  }
}

class ApiFavTopicsInfoModel {
  List<ApiFavArticlesModel> items;
  int id;
  String name;
  String icon;
  int view;
  bool isFavorite;

  ApiFavTopicsInfoModel({this.items, this.id, this.name, this.icon, this.view, this.isFavorite});

  factory ApiFavTopicsInfoModel.fromJson(
      Map<String, dynamic> jsonItem) {
    var arrayJson = jsonItem['articles'] as List;
    return ApiFavTopicsInfoModel(
        items: arrayJson
            .map((tagJson) => ApiFavArticlesModel.fromJson(tagJson))
            .toList(),
        id: jsonItem['id'],
        name: jsonItem['name'],
        icon: jsonItem['icon_img'],
        isFavorite: jsonItem['is_favorite'],
        view: jsonItem['view']);
  }
}

class ApiFavArticlesModel {
  String id;
  String coverImg;
  String title;
  String content;
  String authorUserId;
  String likesCount;
  String view;
  String popular;
  String repliesCount;
  String dateCreated;
  String isPaid;

  ApiFavArticlesModel(
      {this.id,
        this.coverImg,
        this.title,
        this.content,
        this.authorUserId,
        this.likesCount,
        this.view,
        this.popular,
        this.repliesCount,
        this.dateCreated,
        this.isPaid});

  factory ApiFavArticlesModel.fromJson(Map<String, dynamic> jsonItem) {
    return ApiFavArticlesModel(
        id: jsonItem['id'],
        coverImg: jsonItem['cover_img'],
        title: jsonItem['title'],
        content: jsonItem['content'],
        authorUserId: jsonItem['author_user_id'],
        likesCount: jsonItem['likes_count'],
        view: jsonItem['view'],
        popular: jsonItem['popular'],
        repliesCount: jsonItem['replies_count'],
        isPaid: jsonItem['is_paid'],
        dateCreated: jsonItem['date_created']);
  }
}
