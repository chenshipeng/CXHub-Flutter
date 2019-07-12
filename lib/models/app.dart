import 'package:json_annotation/json_annotation.dart';

part 'app.g.dart';

@JsonSerializable()
class App {
    App();

    String url;
    String name;
    String client_id;
    
    factory App.fromJson(Map<String,dynamic> json) => _$AppFromJson(json);
    Map<String, dynamic> toJson() => _$AppToJson(this);
}
