import 'api_vibration_info_model.dart';

class ApiVibrationAnswerModel {
  String error;
  ApiVibrationInfoModel info;
  String result;
  int status;

  ApiVibrationAnswerModel(
      {this.error,
        this.info,
        this.result,
        this.status});

  factory ApiVibrationAnswerModel.fromJson(Map<String, dynamic> jsonItem) {
    return ApiVibrationAnswerModel(
        error: jsonItem['error'],
        info: ApiVibrationInfoModel.fromJson(jsonItem['info']),
        result: jsonItem['result'],
        status: jsonItem['status']
    );
  }

  @override
  String toString() {
    return '{"error":"$error", "result":"$result", "status":$status, "info":$info}';
  }
}
