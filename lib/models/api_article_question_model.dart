class ApiArticleQuestionModel {
  int id;
  String coverImg;
  String message;

  ApiArticleQuestionModel({this.coverImg, this.id, this.message});

  factory ApiArticleQuestionModel.fromJson(Map<String, dynamic> jsonItem) {
    return ApiArticleQuestionModel(
        coverImg: jsonItem['cover_img'],
        id: jsonItem['id'],
        message: jsonItem['welcome_message']);
  }
}
