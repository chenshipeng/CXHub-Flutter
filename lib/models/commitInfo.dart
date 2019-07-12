import 'package:json_annotation/json_annotation.dart';
import "comitAuthorInfo.dart";
import "commit.dart";
import "verification.dart";
part 'commitInfo.g.dart';

@JsonSerializable()
class CommitInfo {
    CommitInfo();

    ComitAuthorInfo author;
    ComitAuthorInfo committer;
    String message;
    Commit tree;
    String url;
    num comment_count;
    Verification verification;
    
    factory CommitInfo.fromJson(Map<String,dynamic> json) => _$CommitInfoFromJson(json);
    Map<String, dynamic> toJson() => _$CommitInfoToJson(this);
}
