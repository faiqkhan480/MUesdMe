// To parse this JSON data, do
//
//     final chat = chatFromJson(jsonString);

import 'dart:convert';

Chat chatFromJson(String str) => Chat.fromJson(json.decode(str));

String chatToJson(Chat data) => json.encode(data.toJson());

class Chat {
  Chat({
    required this.uid,
    required this.message,
    this.type,
  });

  String uid;
  String message;
  String? type;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
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
