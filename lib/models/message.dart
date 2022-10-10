import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

List<Message> messageFromJson(String str) => List<Message>.from(json.decode(str).map((x) => Message.fromJson(x)));

@JsonSerializable()
class Message {
  Message({
    required this.userId,
    required this.chatId,
    required this.message,
    required this.messageDate,
  });

  @JsonKey(name: 'UserID')
  final int? userId;

  @JsonKey(name: 'ChatID')
  final int? chatId;

  @JsonKey(name: 'Message')
  final String? message;

  @JsonKey(name: 'MessageDate')
  final DateTime? messageDate;

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);

}
