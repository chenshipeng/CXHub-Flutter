import 'package:json_annotation/json_annotation.dart';

part 'comitAuthorInfo.g.dart';

@JsonSerializable()
class ComitAuthorInfo {
    ComitAuthorInfo();

    String name;
    String email;
    String date;
    
    factory ComitAuthorInfo.fromJson(Map<String,dynamic> json) => _$ComitAuthorInfoFromJson(json);
    Map<String, dynamic> toJson() => _$ComitAuthorInfoToJson(this);
}
