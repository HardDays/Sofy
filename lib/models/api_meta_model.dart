class ApiMetaModel {
  int currentPage;
  int pageCount;
  int perPage;
  int totalCount;

  ApiMetaModel(
      {this.currentPage,
        this.pageCount,
        this.perPage,
        this.totalCount});

  factory ApiMetaModel.fromJson(Map<String, dynamic> jsonItem) {
    return ApiMetaModel(
        currentPage: jsonItem['currentPage'],
        pageCount: jsonItem['pageCount'],
        perPage: jsonItem['perPage'],
        totalCount: jsonItem['totalCount']
    );
  }

  @override
  String toString() {
    return '{"currentPage":$currentPage, "pageCount":$pageCount, "perPage":$perPage, "totalCount":$totalCount}';
  }
}

