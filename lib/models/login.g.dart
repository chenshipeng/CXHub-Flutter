// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Login _$LoginFromJson(Map<String, dynamic> json) {
  return Login()
    ..id = json['id'] as num
    ..url = json['url'] as String
    ..scopes = json['scopes'] as List
    ..token = json['token'] as String
    ..token_last_eight = json['token_last_eight'] as String
    ..hashed_token = json['hashed_token'] as String
    ..app = json['app'] == null
        ? null
        : App.fromJson(json['app'] as Map<String, dynamic>)
    ..note = json['note'] as String
    ..note_url = json['note_url'] as String
    ..updated_at = json['updated_at'] as String
    ..created_at = json['created_at'] as String
    ..fingerprint = json['fingerprint'] as String;
}

Map<String, dynamic> _$LoginToJson(Login instance) => <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'scopes': instance.scopes,
      'token': instance.token,
      'token_last_eight': instance.token_last_eight,
      'hashed_token': instance.hashed_token,
      'app': instance.app,
      'note': instance.note,
      'note_url': instance.note_url,
      'updated_at': instance.updated_at,
      'created_at': instance.created_at,
      'fingerprint': instance.fingerprint
    };
