import 'package:json_annotation/json_annotation.dart';

part 'license.g.dart';

@JsonSerializable()
class License {
    License();

    String key;
    String name;
    String spdx_id;
    String url;
    String node_id;
    
    factory License.fromJson(Map<String,dynamic> json) => _$LicenseFromJson(json);
    Map<String, dynamic> toJson() => _$LicenseToJson(this);
}
