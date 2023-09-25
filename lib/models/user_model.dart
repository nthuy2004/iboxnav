class UserModel {
  int? id;
  String? username;
  String? fullname;

  UserModel({
    this.id,
    this.username,
    this.fullname,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        username: json["username"],
        fullname: json["fullname"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "fullname": fullname,
      };
}
