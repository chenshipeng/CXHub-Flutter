// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Commit _$CommitFromJson(Map<String, dynamic> json) {
  return Commit()
    ..sha = json['sha'] as String
    ..node_id = json['node_id'] as String
    ..commit = json['commit'] == null
        ? null
        : CommitInfo.fromJson(json['commit'] as Map<String, dynamic>)
    ..url = json['url'] as String
    ..html_url = json['html_url'] as String
    ..comments_url = json['comments_url'] as String
    ..author = json['author'] == null
        ? null
        : UserModel.fromJson(json['author'] as Map<String, dynamic>)
    ..committer = json['committer'] == null
        ? null
        : UserModel.fromJson(json['committer'] as Map<String, dynamic>)
    ..parents = (json['parents'] as List)
        ?.map((e) =>
            e == null ? null : Commit.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$CommitToJson(Commit instance) => <String, dynamic>{
      'sha': instance.sha,
      'node_id': instance.node_id,
      'commit': instance.commit,
      'url': instance.url,
      'html_url': instance.html_url,
      'comments_url': instance.comments_url,
      'author': instance.author,
      'committer': instance.committer,
      'parents': instance.parents
    };