import 'package:json_annotation/json_annotation.dart';
import "userModel.dart";
part 'issue.g.dart';

@JsonSerializable()
class Issue {
    Issue();

    String url;
    String repository_url;
    String labels_url;
    String comments_url;
    String events_url;
    String html_url;
    num id;
    String node_id;
    num number;
    String title;
    UserModel user;
    String state;
    bool locked;
    String milestone;
    num comments;
    String created_at;
    String updated_at;
    String closed_at;
    String author_association;
    String body;
    
    factory Issue.fromJson(Map<String,dynamic> json) => _$IssueFromJson(json);
    Map<String, dynamic> toJson() => _$IssueToJson(this);
}
