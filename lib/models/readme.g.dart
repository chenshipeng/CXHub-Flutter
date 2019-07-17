// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'readme.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Readme _$ReadmeFromJson(Map<String, dynamic> json) {
  return Readme()
    ..name = json['name'] as String
    ..path = json['path'] as String
    ..sha = json['sha'] as String
    ..size = json['size'] as num
    ..url = json['url'] as String
    ..html_url = json['html_url'] as String
    ..git_url = json['git_url'] as String
    ..download_url = json['download_url'] as String
    ..type = json['type'] as String
    ..content = json['content'] as String
    ..encoding = json['encoding'] as String
    ..links = json['_links'];
}

Map<String, dynamic> _$ReadmeToJson(Readme instance) => <String, dynamic>{
      'name': instance.name,
      'path': instance.path,
      'sha': instance.sha,
      'size': instance.size,
      'url': instance.url,
      'html_url': instance.html_url,
      'git_url': instance.git_url,
      'download_url': instance.download_url,
      'type': instance.type,
      'content': instance.content,
      'encoding': instance.encoding,
      '_links': instance.links
    };
