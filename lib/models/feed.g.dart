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
      feedDate: json['FeedDate'] == null
          ? null
          : DateTime.parse(json['FeedDate'] as String),
      postLiked: json['PostLiked'] as String?,
      shareUser: json['ShareUser'] == null
          ? null
          : ShareUser.fromJson(json['ShareUser'] as Map<String, dynamic>),
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
      'FeedDate': instance.feedDate?.toIso8601String(),
      'PostLiked': instance.postLiked,
      'ShareUser': instance.shareUser,
    };

ShareUser _$ShareUserFromJson(Map<String, dynamic> json) => ShareUser(
      userId: json['UserID'] as int?,
      follow: json['Follow'] as int?,
      followedBy: json['FollowedBy'] as int?,
      followers: json['Followers'] as int?,
      followings: json['Followings'] as int?,
      fullName: json['FullName'] as String?,
      profilePic: json['ProfilePic'] as String?,
      userName: json['UserName'] as String?,
    );

Map<String, dynamic> _$ShareUserToJson(ShareUser instance) => <String, dynamic>{
      'UserID': instance.userId,
      'Follow': instance.follow,
      'FollowedBy': instance.followedBy,
      'Followers': instance.followers,
      'Followings': instance.followings,
      'FullName': instance.fullName,
      'ProfilePic': instance.profilePic,
      'UserName': instance.userName,
    };
