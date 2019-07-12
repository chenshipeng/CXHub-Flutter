import 'package:json_annotation/json_annotation.dart';
import "app.dart";
part 'login.g.dart';

@JsonSerializable()
class Login {
    Login();

    num id;
    String url;
    List scopes;
    String token;
    String token_last_eight;
    String hashed_token;
    App app;
    String note;
    String note_url;
    String updated_at;
    String created_at;
    String fingerprint;
    
    factory Login.fromJson(Map<String,dynamic> json) => _$LoginFromJson(json);
    Map<String, dynamic> toJson() => _$LoginToJson(this);
}
