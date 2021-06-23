import 'api_answers_model.dart';
import 'api_meta_model.dart';

class ApiAnswersInfoModel {
  List<ApiAnswersModel> items;
  ApiMetaModel meta;

  ApiAnswersInfoModel({this.items,
    this.meta});

  factory ApiAnswersInfoModel.fromJson(Map<String, dynamic> jsonItem) {
    var arrayJson = jsonItem['items'] as List;
    return ApiAnswersInfoModel(
      meta: ApiMetaModel.fromJson(jsonItem['_meta']),
      items: arrayJson
          .map((tagJson) => ApiAnswersModel.fromJson(tagJson))
          .toList(),
    );
  }

  @override
  String toString() {
    return '{"items":$items}';
  }
}
