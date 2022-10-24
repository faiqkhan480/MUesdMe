// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'args.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Args _$ArgsFromJson(Map<String, dynamic> json) => Args(
      isBroadcaster: json['is_broadcaster'] as bool?,
      broadcaster: json['broadcaster'] == null
          ? null
          : User.fromJson(json['broadcaster'] as Map<String, dynamic>),
      callType: $enumDecode(_$CallTypeEnumMap, json['call_type']),
      callMode: $enumDecode(_$CallTypeEnumMap, json['call_mode']),
    );

Map<String, dynamic> _$ArgsToJson(Args instance) => <String, dynamic>{
      'is_broadcaster': instance.isBroadcaster,
      'broadcaster': instance.broadcaster,
      'call_type': _$CallTypeEnumMap[instance.callType]!,
      'call_mode': _$CallTypeEnumMap[instance.callMode]!,
    };

const _$CallTypeEnumMap = {
  CallType.incoming: 'incoming',
  CallType.outgoing: 'outgoing',
  CallType.ongoing: 'ongoing',
  CallType.video: 'video',
  CallType.audio: 'audio',
};
