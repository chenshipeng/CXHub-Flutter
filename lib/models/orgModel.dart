import 'package:json_annotation/json_annotation.dart';

part 'orgModel.g.dart';

@JsonSerializable()
class OrgModel {
    OrgModel();

    String login;
    num id;
    String node_id;
    String avatar_url;
    String gravatar_id;
    String url;
    String html_url;
    String followers_url;
    String following_url;
    String gists_url;
    String starred_url;
    String subscriptions_url;
    String organizations_url;
    String repos_url;
    String events_url;
    String received_events_url;
    String type;
    bool site_admin;
    
    factory OrgModel.fromJson(Map<String,dynamic> json) => _$OrgModelFromJson(json);
    Map<String, dynamic> toJson() => _$OrgModelToJson(this);
}
