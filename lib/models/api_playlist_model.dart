class ApiPlayListModel {
  String coverImg;
  int dateCreated;
  int dateUpdated;
  int id;
  String titleEn;
  String titleRu;

  ApiPlayListModel(
      {this.coverImg,
        this.dateCreated,
        this.dateUpdated,
        this.id,
        this.titleEn,
        this.titleRu});

  factory ApiPlayListModel.fromJson(Map<String, dynamic> jsonItem) {
    return ApiPlayListModel(
        coverImg: jsonItem['cover_img'],
        dateCreated: jsonItem['date_created'],
        dateUpdated: jsonItem['date_updated'],
        id: jsonItem['id'],
        titleEn: jsonItem['title']['en'],
        titleRu: jsonItem['title']['ru']
    );
  }

  @override
  String toString() {
    return '{"coverImg":"$coverImg", "dateCreated":$dateCreated, "dateUpdated":$dateUpdated, "id":$id, "titleEn":"$titleEn", "titleRu":"$titleRu"}';
}
}

