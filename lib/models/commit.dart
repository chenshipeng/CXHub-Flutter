import 'package:json_annotation/json_annotation.dart';
import "commitInfo.dart";
import "userModel.dart";
part 'commit.g.dart';

@JsonSerializable()
class Commit {
    Commit();

    String sha;
    String node_id;
    CommitInfo commit;
    String url;
    String html_url;
    String comments_url;
    UserModel author;
    UserModel committer;
    List<Commit> parents;
    
    factory Commit.fromJson(Map<String,dynamic> json) => _$CommitFromJson(json);
    Map<String, dynamic> toJson() => _$CommitToJson(this);
}
