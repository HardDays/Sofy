class Replies {
  final List<Reply> replies;

  Replies(this.replies);

  Replies.fromJson(Map<String, dynamic> json)
      : replies = (json['info']['items'] as List)
            .map((e) => new Reply.fromJson(e))
            .toList();
}

class Reply {
  final String id;
  final String articleId;
  final String userId;
  final String parentId;
  final String content;
  final String dateCreated;
  String likesCount;
  final String userName;
  final String coverImg;
  String isLiked;

  Reply(
      this.id,
      this.articleId,
      this.userId,
      this.parentId,
      this.content,
      this.dateCreated,
      this.likesCount,
      this.userName,
      this.coverImg,
      this.isLiked);

  Reply.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        articleId = json['article_id'],
        userId = json['user_id'],
        parentId = json['parent_id'],
        dateCreated = json['date_created'],
        likesCount = json['likes_count'],
        userName = json['username'],
        coverImg = json['user_cover_img'],
        isLiked = json['is_liked'],
        content = json['content'];
}
