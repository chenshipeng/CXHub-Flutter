// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Link _$LinkFromJson(Map<String, dynamic> json) {
  return Link()
    ..self = json['self'] as String
    ..git = json['git'] as String
    ..html = json['html'] as String;
}

Map<String, dynamic> _$LinkToJson(Link instance) => <String, dynamic>{
      'self': instance.self,
      'git': instance.git,
      'html': instance.html
    };