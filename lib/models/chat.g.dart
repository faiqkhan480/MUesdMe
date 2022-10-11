// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
      userId: json['UserID'] as int?,
      chatId: json['ChatID'] as int?,
      fullName: json['FullName'] as String?,
      profilePic: json['ProfilePic'] as String?,
      message: json['Message'] as String?,
      messageDate: json['MessageDate'] == null
          ? null
          : DateTime.parse(json['MessageDate'] as String),
    );

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'UserID': instance.userId,
      'ChatID': instance.chatId,
      'FullName': instance.fullName,
      'ProfilePic': instance.profilePic,
      'Message': instance.message,
      'MessageDate': instance.messageDate?.toIso8601String(),
    };
