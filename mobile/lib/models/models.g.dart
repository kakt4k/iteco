// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  login: json['login'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'login': instance.login,
  'password': instance.password,
};

NotesModel _$NotesModelFromJson(Map<String, dynamic> json) =>
    NotesModel(notes: json['notes'] as List<dynamic>);

Map<String, dynamic> _$NotesModelToJson(NotesModel instance) =>
    <String, dynamic>{'notes': instance.notes};
