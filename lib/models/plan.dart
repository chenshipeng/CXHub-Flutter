import 'package:json_annotation/json_annotation.dart';

part 'plan.g.dart';

@JsonSerializable()
class Plan {
    Plan();

    String name;
    num space;
    num private_repos;
    num collaborators;
    
    factory Plan.fromJson(Map<String,dynamic> json) => _$PlanFromJson(json);
    Map<String, dynamic> toJson() => _$PlanToJson(this);
}
