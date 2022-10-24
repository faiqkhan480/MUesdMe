// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'api_res.g.dart';

@JsonSerializable()
class ApiRes {
  ApiRes({
    required this.code,
    required this.message,
    required this.users,
    required this.user,
    required this.feeds,
    required this.feed,
    required this.token,
    required this.feedComments,
    required this.messages,
    required this.listing,
  });

  @JsonKey(name: 'Code')
  final int? code;

  @JsonKey(name: 'Message')
  final String? message;

  @JsonKey(name: 'Users')
  final dynamic users;

  @JsonKey(name: 'User')
  final dynamic user;

  @JsonKey(name: 'Feeds')
  final dynamic feeds;

  @JsonKey(name: 'Feed')
  final dynamic feed;

  @JsonKey(name: 'Token')
  final dynamic token;

  @JsonKey(name: 'FeedComments')
  final dynamic feedComments;

  @JsonKey(name: 'Messages')
  final dynamic messages;

  @JsonKey(name: 'Listing')
  final dynamic listing;

  factory ApiRes.fromJson(Map<String, dynamic> json) => _$ApiResFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResToJson(this);
}
