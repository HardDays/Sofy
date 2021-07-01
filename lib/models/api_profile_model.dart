class ApiProfileModel {
  int id;
  String username;
  String email;
  String instagramId;
  String coverImg;
  String role;
  int status;

  ApiProfileModel(
      {this.id,
      this.coverImg,
      this.email,
      this.instagramId,
      this.role,
      this.status,
      this.username});

  factory ApiProfileModel.fromJson(Map<String, dynamic> jsonItem) {
    return ApiProfileModel(
        id: jsonItem['id'],
        coverImg: jsonItem['cover_img'],
        username: jsonItem['username'],
        email: jsonItem['email'],
        instagramId: jsonItem['instagram_id'],
        role: jsonItem['role'],
        status: jsonItem['status']);
  }
}
