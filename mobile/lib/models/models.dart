import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@JsonSerializable()
class UserModel {
  UserModel({required this.login, required this.password});

  final String login;
  final String password;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable()
class NotesModel {
  NotesModel({required this.notes});

  final List notes;

  factory NotesModel.fromJson(Map<String, dynamic> json) =>
      _$NotesModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotesModelToJson(this);
}
