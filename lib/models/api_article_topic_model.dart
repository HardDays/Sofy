class ApiArticleTopicModel {
  int id;
  String coverImg;
  String name;
  String langCode;
  bool selected;
  int view;
  int popular;

  ApiArticleTopicModel(
      {this.coverImg,
      this.view,
      this.popular,
      this.id,
      this.name,
      this.langCode,
      this.selected});

  factory ApiArticleTopicModel.fromJson(Map<String, dynamic> jsonItem) {
    return ApiArticleTopicModel(
        coverImg: jsonItem['icon_img'],
        id: jsonItem['id'],
        view: jsonItem['view'],
        popular: jsonItem['popular'],
        langCode: jsonItem['lang_code'],
        name: jsonItem['name'],
        selected: false);
  }

  @override
  String toString() {
    return '{"coverImg":"$coverImg", "id":$id, "view":$view,"popular":$popular,"name":"$name", "langCode":"$langCode"}';
  }
}
