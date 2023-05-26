import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'feed.g.dart';

List<Feed> feedFromJson(String str) => List<Feed>.from(json.decode(str).map((x) => Feed.fromJson(x)));

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
    required this.feedDate,
    required this.postLiked,
    required this.shareUser,
  });

  @JsonKey(name: 'UserID')
  final int? userId;

  @JsonKey(name: 'FullName')
  final String? fullName;

  @JsonKey(name: 'UserName')
  final String? userName;

  @JsonKey(name: 'ProfilePic')
  String? profilePic;

  @JsonKey(name: 'FeedID')
  final int? feedId;

  @JsonKey(name: 'FeedPath')
  final String? feedPath;

  @JsonKey(name: 'PostViews')
  final int? postViews;

  @JsonKey(name: 'PostLikes')
  int? postLikes;

  @JsonKey(name: 'PostShares')
  final int? postShares;

  @JsonKey(name: 'PostComments')
  int? postComments;

  @JsonKey(name: 'FeedType')
  final String? feedType;

  @JsonKey(name: 'FeedDate')
  final DateTime? feedDate;

  @JsonKey(name: 'PostLiked')
  String? postLiked;

  @JsonKey(name: 'ShareUser')
  ShareUser? shareUser;

  factory Feed.fromJson(Map<String, dynamic> json) => _$FeedFromJson(json);

  Map<String, dynamic> toJson() => _$FeedToJson(this);

}

@JsonSerializable()
class ShareUser {
  ShareUser({
    required this.userId,
    required this.follow,
    required this.followedBy,
    required this.followers,
    required this.followings,
    required this.fullName,
    required this.profilePic,
    required this.userName,
  });

  @JsonKey(name: 'UserID')
  final int? userId;

  @JsonKey(name: 'Follow')
  final int? follow;

  @JsonKey(name: 'FollowedBy')
  final int? followedBy;

  @JsonKey(name: 'Followers')
  final int? followers;

  @JsonKey(name: 'Followings')
  final int? followings;

  @JsonKey(name: 'FullName')
  final String? fullName;

  @JsonKey(name: 'ProfilePic')
  final String? profilePic;

  @JsonKey(name: 'UserName')
  final String? userName;

  factory ShareUser.fromJson(Map<String, dynamic> json) => _$ShareUserFromJson(json);

  Map<String, dynamic> toJson() => _$ShareUserToJson(this);

}