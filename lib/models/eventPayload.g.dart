// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eventPayload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventPayload _$EventPayloadFromJson(Map<String, dynamic> json) {
  return EventPayload()
    ..ref = json['ref'] as String
    ..ref_type = json['ref_type'] as String
    ..master_branch = json['master_branch'] as String
    ..description = json['description'] as String
    ..pusher_type = json['pusher_type'] as String
    ..action = json['action'] as String;
}

Map<String, dynamic> _$EventPayloadToJson(EventPayload instance) =>
    <String, dynamic>{
      'ref': instance.ref,
      'ref_type': instance.ref_type,
      'master_branch': instance.master_branch,
      'description': instance.description,
      'pusher_type': instance.pusher_type,
      'action': instance.action
    };
