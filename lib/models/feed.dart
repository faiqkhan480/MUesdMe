import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'feed.g.dart';

@JsonSerializable()
class Feed {
  Feed({
    required this.userId,
    required this.fullName,
    required this.userName,
    required this.profilePic,
    required this.feedId,
    required this.feedPath,
    required this.postViews,
    required this.postLikes,
    required this.postShares,
    required this.postComments,
    required this.feedType,
  });

  @JsonKey(name: 'UserID')
  final int? userId;

  @JsonKey(name: 'FullName')
  final String? fullName;

  @JsonKey(name: 'UserName')
  final String? userName;

  @JsonKey(name: 'ProfilePic')
  final String? profilePic;

  @JsonKey(name: 'FeedID')
  final int? feedId;

  @JsonKey(name: 'FeedPath')
  final String? feedPath;

  @JsonKey(name: 'PostViews')
  final int? postViews;

  @JsonKey(name: 'PostLikes')
  final int? postLikes;

  @JsonKey(name: 'PostShares')
  final int? postShares;

  @JsonKey(name: 'PostComments')
  final int? postComments;

  @JsonKey(name: 'FeedType')
  final String? feedType;

  factory Feed.fromJson(Map<String, dynamic> json) => _$FeedFromJson(json);

  Map<String, dynamic> toJson() => _$FeedToJson(this);

}

List<Feed> feedFromJson(String str) => List<Feed>.from(json.decode(str).map((x) => Feed.fromJson(x)));

