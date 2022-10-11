import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable(createToJson: false)
class Comment {
  Comment({
    required this.userId,
    required this.fullName,
    required this.userName,
    required this.profilePic,
    required this.feedId,
    required this.postViews,
    required this.postLikes,
    required this.postShares,
    required this.postComments,
    required this.feedDate,
    required this.comment,
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

  @JsonKey(name: 'PostViews')
  final int? postViews;

  @JsonKey(name: 'PostLikes')
  final int? postLikes;

  @JsonKey(name: 'PostShares')
  final int? postShares;

  @JsonKey(name: 'PostComments')
  final int? postComments;

  @JsonKey(name: 'FeedDate')
  final int? feedDate;

  @JsonKey(name: 'Comment')
  final String? comment;

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

}

List<Comment> commentFromJson(String str) => List<Comment>.from(json.decode(str).map((x) => Comment.fromJson(x)));
