import 'api_playlist_info_model.dart';

class ApiPlayListAnswerModel {
  String error;
  ApiPlayListInfoModel info;
  String result;
  int status;

  ApiPlayListAnswerModel(
      {this.error,
        this.info,
        this.result,
        this.status});

  factory ApiPlayListAnswerModel.fromJson(Map<String, dynamic> jsonItem) {
    return ApiPlayListAnswerModel(
      error: jsonItem['error'],
      info: ApiPlayListInfoModel.fromJson(jsonItem['info']),
      result: jsonItem['result'],
      status: jsonItem['status']
    );
  }

  @override
  String toString() {
    return '{"error":"$error", "result":"$result", "status":$status, "info":$info}';
  }
}
