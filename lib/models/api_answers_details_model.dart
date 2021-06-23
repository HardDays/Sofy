import 'package:sofy_new/models/api_answers_info_model.dart';

import 'api_meta_model.dart';

class ApiAnswersDetailsModel {
  String error;
  ApiAnswersInfoModel info;
  String result;
  int status;

  ApiAnswersDetailsModel(
      {this.error,
        this.info,
        this.result,
        this.status});

  factory ApiAnswersDetailsModel.fromJson(Map<String, dynamic> jsonItem) {
    return ApiAnswersDetailsModel(
      error: jsonItem['error'],
      info: ApiAnswersInfoModel.fromJson(jsonItem['info']),
      result: jsonItem['result'],
      status: jsonItem['status']
    );
  }

  @override
  String toString() {
    return '{"error":"$error", "result":"$result", "status":$status, "info":$info}';
  }
}
