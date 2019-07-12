// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Issue _$IssueFromJson(Map<String, dynamic> json) {
  return Issue()
    ..url = json['url'] as String
    ..repository_url = json['repository_url'] as String
    ..labels_url = json['labels_url'] as String
    ..comments_url = json['comments_url'] as String
    ..events_url = json['events_url'] as String
    ..html_url = json['html_url'] as String
    ..id = json['id'] as num
    ..node_id = json['node_id'] as String
    ..number = json['number'] as num
    ..title = json['title'] as String
    ..user = json['user'] == null
        ? null
        : UserModel.fromJson(json['user'] as Map<String, dynamic>)
    ..state = json['state'] as String
    ..locked = json['locked'] as bool
    ..milestone = json['milestone'] as String
    ..comments = json['comments'] as num
    ..created_at = json['created_at'] as String
    ..updated_at = json['updated_at'] as String
    ..closed_at = json['closed_at'] as String
    ..author_association = json['author_association'] as String
    ..body = json['body'] as String;
}

Map<String, dynamic> _$IssueToJson(Issue instance) => <String, dynamic>{
      'url': instance.url,
      'repository_url': instance.repository_url,
      'labels_url': instance.labels_url,
      'comments_url': instance.comments_url,
      'events_url': instance.events_url,
      'html_url': instance.html_url,
      'id': instance.id,
      'node_id': instance.node_id,
      'number': instance.number,
      'title': instance.title,
      'user': instance.user,
      'state': instance.state,
      'locked': instance.locked,
      'milestone': instance.milestone,
      'comments': instance.comments,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'closed_at': instance.closed_at,
      'author_association': instance.author_association,
      'body': instance.body
    };
