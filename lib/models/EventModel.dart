import 'package:json_annotation/json_annotation.dart';
import "eventPayload.dart";
import "repoModel.dart";
import "actorModel.dart";
import "orgModel.dart";
part 'EventModel.g.dart';

@JsonSerializable()
class EventModel {
    EventModel();

    String type;
    bool public;
    EventPayload payload;
    RepoModel repo;
    ActorModel actor;
    OrgModel org;
    String created_at;
    String id;
    
    factory EventModel.fromJson(Map<String,dynamic> json) => _$EventModelFromJson(json);
    Map<String, dynamic> toJson() => _$EventModelToJson(this);
}
