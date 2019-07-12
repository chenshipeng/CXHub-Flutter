// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

App _$AppFromJson(Map<String, dynamic> json) {
  return App()
    ..url = json['url'] as String
    ..name = json['name'] as String
    ..client_id = json['client_id'] as String;
}

Map<String, dynamic> _$AppToJson(App instance) => <String, dynamic>{
      'url': instance.url,
      'name': instance.name,
      'client_id': instance.client_id
    };
