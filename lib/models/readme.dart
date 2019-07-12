import 'package:json_annotation/json_annotation.dart';
import 'link.dart';
part 'readme.g.dart';

@JsonSerializable()
class Readme {
    Readme();

    String name;
    String path;
    String sha;
    num size;
    String url;
    String html_url;
    String git_url;
    String download_url;
    String type;
    String content;
    String encoding;
    @JsonKey(name: '_links') Link links;
    
    factory Readme.fromJson(Map<String,dynamic> json) => _$ReadmeFromJson(json);
    Map<String, dynamic> toJson() => _$ReadmeToJson(this);
}
