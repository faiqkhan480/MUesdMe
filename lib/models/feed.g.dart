// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Feed _$FeedFromJson(Map<String, dynamic> json) => Feed(
      userId: json['UserID'] as int?,
      fullName: json['FullName'] as String?,
      userName: json['UserName'] as String?,
      profilePic: json['ProfilePic'] as String?,
      feedId: json['FeedID'] as int?,
      feedPath: json['FeedPath'] as String?,
      postViews: json['PostViews'] as int?,
      postLikes: json['PostLikes'] as int?,
      postShares: json['PostShares'] as int?,
      postComments: json['PostComments'] as int?,
      feedType: json['FeedType'] as String?,
      feedDate: DateTime.parse(json["FeedDate"]) as DateTime?,
    );

Map<String, dynamic> _$FeedToJson(Feed instance) => <String, dynamic>{
      'UserID': instance.userId,
      'FullName': instance.fullName,
      'UserName': instance.userName,
      'ProfilePic': instance.profilePic,
      'FeedID': instance.feedId,
      'FeedPath': instance.feedPath,
      'PostViews': instance.postViews,
      'PostLikes': instance.postLikes,
      'PostShares': instance.postShares,
      'PostComments': instance.postComments,
      'FeedType': instance.feedType,
      "FeedDate": instance.feedDate?.toIso8601String(),
    };
