// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'actorModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActorModel _$ActorModelFromJson(Map<String, dynamic> json) {
  return ActorModel()
    ..id = json['id'] as num
    ..login = json['login'] as String
    ..gravatar_id = json['gravatar_id'] as String
    ..avatar_url = json['avatar_url'] as String
    ..url = json['url'] as String;
}

Map<String, dynamic> _$ActorModelToJson(ActorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'gravatar_id': instance.gravatar_id,
      'avatar_url': instance.avatar_url,
      'url': instance.url
    };
