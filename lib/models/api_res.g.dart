// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiRes _$ApiResFromJson(Map<String, dynamic> json) => ApiRes(
      code: json['Code'] as int?,
      message: json['Message'] as String?,
      users: json['Users'],
      user: json['User'],
      feeds: json['Feeds'],
      token: json['Token'],
    );

Map<String, dynamic> _$ApiResToJson(ApiRes instance) => <String, dynamic>{
      'Code': instance.code,
      'Message': instance.message,
      'Users': instance.users,
      'User': instance.user,
      'Feeds': instance.feeds,
      'Token': instance.token,
    };
