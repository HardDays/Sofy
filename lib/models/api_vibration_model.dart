import 'api_vibration_data_model.dart';

class ApiVibrationModel {
  String coverImg;
  List<ApiVibrationDataModel> data;
  int dateCreated;
  int dateUpdated;
  int id;
  int isAndroidVisible;
  int isIosVisible;
  int isTest;
  bool isTrial;
  int likesCount;
  //String playlistName;
  String titleEn;
  String titleRu;
  bool favorite;
  int parentPlaylistId;

  ApiVibrationModel(
      {this.coverImg,
        this.data,
        this.dateCreated,
        this.dateUpdated,
        this.id,
        this.isAndroidVisible,
        this.isIosVisible,
        this.isTest,
        this.isTrial,
        this.likesCount,
        //this.playlistName,
        this.titleEn,
        this.titleRu,
        this.favorite,
      this.parentPlaylistId});

  factory ApiVibrationModel.fromJson(Map<String, dynamic> jsonItem) {
    var arrayJson = jsonItem['data'] as List;
    bool _isTrial;
    if (jsonItem['is_trial'] == 1) {
      _isTrial = true;
    } else {
      _isTrial = false;
    }
    return ApiVibrationModel(
        coverImg: jsonItem['cover_img'],
        data: arrayJson.map((tagJson) => ApiVibrationDataModel.fromJson(tagJson)).toList(),
        dateCreated: jsonItem['date_created'],
        dateUpdated: jsonItem['date_updated'],
        id: jsonItem['id'],
        isAndroidVisible: jsonItem['is_android_visible'],
        isIosVisible: jsonItem['is_ios_visible'],
        isTest: jsonItem['is_test'],
        isTrial: _isTrial,
        likesCount: jsonItem['likes_count'],
        //playlistName: jsonItem['playlist_name'],
        titleEn: jsonItem['title']['en'],
        titleRu: jsonItem['title']['ru'],
        parentPlaylistId: jsonItem['parent_playlist_id'],
        favorite: false
    );
  }

  @override
  String toString() {
    return '{"coverImg":"$coverImg", "data":$data, "dateCreated":$dateCreated, "dateUpdated":$dateUpdated, "id":$id, "isAndroidVisible":$isAndroidVisible, "isIosVisible":$isIosVisible, "isTest":$isTest, "isTrial":$isTrial, "likesCount":$likesCount, "titleEn":"$titleEn", "titleRu":"$titleRu", "parentPlaylistId":"$parentPlaylistId",}';
  }
}