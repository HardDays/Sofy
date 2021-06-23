class ApiArticlesModel {
  int id;
  int articleTopicId;
  String coverImg;
  String title;
  String content;
  int authorUserId;
  int likesCount;
  int view;
  int popular;
  int repliesCount;
  int dateCreated;
  int dateUpdated;
  int isPaid;

  ApiArticlesModel(
      {this.id,
      this.articleTopicId,
      this.coverImg,
      this.title,
      this.content,
      this.authorUserId,
      this.likesCount,
      this.view,
      this.popular,
      this.repliesCount,
      this.dateCreated,
      this.dateUpdated,
      this.isPaid});

  factory ApiArticlesModel.fromJson(Map<String, dynamic> jsonItem) {
    return ApiArticlesModel(
        id: jsonItem['id'],
        articleTopicId: jsonItem['article_topic_id'],
        coverImg: jsonItem['cover_img'],
        title: jsonItem['title'],
        content: jsonItem['content'],
        authorUserId: jsonItem['author_user_id'],
        likesCount: jsonItem['likes_count'],
        view: jsonItem['view'],
        popular: jsonItem['popular'],
        repliesCount: jsonItem['replies_count'],
        isPaid: jsonItem['is_paid'],
        dateCreated: jsonItem['date_created'],
        dateUpdated: jsonItem['date_updated']);
  }
}
