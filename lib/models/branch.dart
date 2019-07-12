import 'package:json_annotation/json_annotation.dart';
import "commit.dart";
part 'branch.g.dart';

@JsonSerializable()
class Branch {
    Branch();

    String name;
    Commit commit;
    bool protected;
    
    factory Branch.fromJson(Map<String,dynamic> json) => _$BranchFromJson(json);
    Map<String, dynamic> toJson() => _$BranchToJson(this);
}
