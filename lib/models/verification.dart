import 'package:json_annotation/json_annotation.dart';

part 'verification.g.dart';

@JsonSerializable()
class Verification {
    Verification();

    bool verified;
    String reason;
    String signature;
    String payload;
    
    factory Verification.fromJson(Map<String,dynamic> json) => _$VerificationFromJson(json);
    Map<String, dynamic> toJson() => _$VerificationToJson(this);
}
