// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      userId: json['UserID'] as int?,
      chatId: json['ChatID'] as int?,
      message: json['Message'] as String?,
      messageDate: json['MessageDate'] == null
          ? null
          : DateTime.parse(json['MessageDate'] as String),
      type: json['Type'] as String?,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'UserID': instance.userId,
      'ChatID': instance.chatId,
      'Message': instance.message,
      'MessageDate': instance.messageDate?.toIso8601String(),
      'Type': instance.type,
    };
