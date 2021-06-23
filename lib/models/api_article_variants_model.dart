class ApiArticleVariantsModel {
  int id;
  int pollId;
  String content;
  int percent;
  int answerCount;
  bool selected;

  ApiArticleVariantsModel(
      {this.id,
      this.pollId,
      this.content,
      this.percent,
      this.answerCount,
      this.selected});

  factory ApiArticleVariantsModel.fromJson(Map<String, dynamic> jsonItem) {
    return ApiArticleVariantsModel(
      id: jsonItem['id'],
      pollId: jsonItem['poll_id'],
      content: jsonItem['content'],
      percent: jsonItem['percent'],
      answerCount: jsonItem['answer_count'],
      selected: jsonItem['selected'],
    );
  }
}
