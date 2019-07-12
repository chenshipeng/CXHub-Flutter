import 'package:json_annotation/json_annotation.dart';

part 'eventPayload.g.dart';

@JsonSerializable()
class EventPayload {
    EventPayload();

    String ref;
    String ref_type;
    String master_branch;
    String description;
    String pusher_type;
    String action;
    
    factory EventPayload.fromJson(Map<String,dynamic> json) => _$EventPayloadFromJson(json);
    Map<String, dynamic> toJson() => _$EventPayloadToJson(this);
}
