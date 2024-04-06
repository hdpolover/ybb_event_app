// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? id;
  String? fullName;
  String? email;
  String? password;
  String? isVerified;
  String? programCategoryId;
  String? refCode;
  String? programId;
  String? isActive;
  String? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({
    this.id,
    this.fullName,
    this.email,
    this.password,
    this.isVerified,
    this.programCategoryId,
    this.programId,
    this.refCode,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        fullName: json["full_name"],
        email: json["email"],
        password: json["password"],
        isVerified: json["is_verified"],
        programCategoryId: json["program_category_id"],
        isActive: json["is_active"],
        isDeleted: json["is_deleted"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "full_name": fullName,
        "email": email,
        "password": password,
        "program_category_id": programCategoryId,
        "program_id": programId,
        "ref_code": refCode,
      };

  Map<String, dynamic> toAllJson() => {
        "id": id,
        "full_name": fullName,
        "email": email,
        "password": password,
        "is_verified": isVerified,
        "program_category_id": programCategoryId,
        "is_active": isActive,
        "is_deleted": isDeleted,
        "created_at": createdAt.toString(),
        "updated_at": updatedAt.toString(),
      };
}
