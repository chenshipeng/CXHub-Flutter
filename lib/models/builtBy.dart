import 'package:json_annotation/json_annotation.dart';

part 'builtBy.g.dart';

@JsonSerializable()
class BuiltBy {
    BuiltBy();

    String username;
    String href;
    String avatar;
    
    factory BuiltBy.fromJson(Map<String,dynamic> json) => _$BuiltByFromJson(json);
    Map<String, dynamic> toJson() => _$BuiltByToJson(this);
}
