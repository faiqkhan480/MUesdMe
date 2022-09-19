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
  });

  String uid;
  String message;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    uid: json["uid"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "message": message,
  };
}
