// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Verification _$VerificationFromJson(Map<String, dynamic> json) {
  return Verification()
    ..verified = json['verified'] as bool
    ..reason = json['reason'] as String
    ..signature = json['signature'] as String
    ..payload = json['payload'] as String;
}

Map<String, dynamic> _$VerificationToJson(Verification instance) =>
    <String, dynamic>{
      'verified': instance.verified,
      'reason': instance.reason,
      'signature': instance.signature,
      'payload': instance.payload
    };
