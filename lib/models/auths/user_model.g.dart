// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      userId: json['UserID'] as int?,
      email: json['Email'] as String?,
      password: json['Password'] as String?,
      firstName: json['FirstName'] as String?,
      lastName: json['LastName'] as String?,
      profilePic: json['ProfilePic'] as String?,
      token: json['Token'] as String?,
      fcmToken: json['FCMToken'] as String?,
      country: json['Country'] as String?,
      dob: json['DOB'] as String?,
      gender: json['Gender'] as String?,
      userName: json['UserName'] as String?,
      phone: json['Phone'] as String?,
      location: json['Location'] as String?,
      postalCode: json['PostalCode'] as String?,
      aboutMe: json['AboutMe'] as String?,
      follow: json['Follow'] as int?,
      followedBy: json['FollowedBy'] as int?,
      followers: json['Followers'] as int?,
      followings: json['Followings'] as int?,
      posts: json['Posts'] as int?,
      isLive: json['IsLive'] as int?,
      rtcToken: json['RTCToken'] as String?,
      rtmToken: json['RTMToken'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'UserID': instance.userId,
      'Email': instance.email,
      'Password': instance.password,
      'FirstName': instance.firstName,
      'LastName': instance.lastName,
      'ProfilePic': instance.profilePic,
      'Token': instance.token,
      'FCMToken': instance.fcmToken,
      'Country': instance.country,
      'DOB': instance.dob,
      'Gender': instance.gender,
      'UserName': instance.userName,
      'Phone': instance.phone,
      'Location': instance.location,
      'PostalCode': instance.postalCode,
      'AboutMe': instance.aboutMe,
      'Follow': instance.follow,
      'FollowedBy': instance.followedBy,
      'Followers': instance.followers,
      'Followings': instance.followings,
      'Posts': instance.posts,
      'IsLive': instance.isLive,
      'RTCToken': instance.rtcToken,
      'RTMToken': instance.rtmToken,
    };
