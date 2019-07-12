import 'package:json_annotation/json_annotation.dart';

part 'actorModel.g.dart';

@JsonSerializable()
class ActorModel {
    ActorModel();

    num id;
    String login;
    String gravatar_id;
    String avatar_url;
    String url;
    
    factory ActorModel.fromJson(Map<String,dynamic> json) => _$ActorModelFromJson(json);
    Map<String, dynamic> toJson() => _$ActorModelToJson(this);
}
