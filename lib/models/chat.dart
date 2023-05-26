import 'package:json_annotation/json_annotation.dart';

// To parse this JSON data, do
//
//     final chat = chatFromJson(jsonString);

import 'dart:convert';

part 'chat.g.dart';

List<Chat> chatFromJson(String str) => List<Chat>.from(json.decode(str).map((x) => Chat.fromJson(x)));

@JsonSerializable()
class Chat {
  Chat({
    this.userId,
    this.chatId,
    this.fullName,
    this.profilePic,
    this.message,
    this.messageDate,
  });

  @JsonKey(name: 'UserID')
  final int? userId;

  @JsonKey(name: 'ChatID')
  final int? chatId;

  @JsonKey(name: 'FullName')
  final String? fullName;

  @JsonKey(name: 'ProfilePic')
  final String? profilePic;

  @JsonKey(name: 'Message')
  final String? message;

  @JsonKey(name: 'MessageDate')
  final DateTime? messageDate;

  Chat copyWith({
    int? userId,
    int? chatId,
    String? fullName,
    String? profilePic,
    String? message,
    DateTime? messageDate
  }) {
    return Chat(
        userId: userId ?? this.userId,
        chatId: chatId ?? this.chatId,
        fullName: fullName ?? this.fullName,
        profilePic: profilePic ?? this.profilePic,
        message: message ?? this.message,
        messageDate: messageDate ?? this.messageDate
    );
  }

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);
}

ChatMessage chatMessageFromJson(String str) => ChatMessage.fromJson(json.decode(str));

String chatToJson(ChatMessage data) => json.encode(data.toJson());

class ChatMessage {
  ChatMessage({
    required this.uid,
    required this.message,
    this.type,
  });

  String uid;
  String message;
  String? type;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    uid: json["uid"],
    message: json["message"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "message": message,
    "type": type,
  };
}
