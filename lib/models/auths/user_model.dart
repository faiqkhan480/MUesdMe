// ignore: depend_on_referenced_packages
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  User({
    this.userId,
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.fullName,
    this.profilePic,
    this.token,
    this.fcmToken,
    this.country,
    this.dob,
    this.gender,
    this.userName,
    this.phone,
    this.location,
    this.postalCode,
    this.aboutMe,
    this.follow,
    this.followedBy,
    this.followers,
    this.followings,
    this.posts,
    this.isLive,
    this.rtcToken,
    this.rtmToken,
    this.wallet,
  });

  @JsonKey(name: 'UserID')
  final int? userId;

  @JsonKey(name: 'Email')
  final String? email;

  @JsonKey(name: 'Password')
  final String? password;

  @JsonKey(name: 'FirstName')
  final String? firstName;

  @JsonKey(name: 'LastName')
  final String? lastName;

  @JsonKey(name: 'LastName')
  final String? fullName;

  @JsonKey(name: 'ProfilePic')
  String? profilePic;

  @JsonKey(name: 'Token')
  final String? token;

  @JsonKey(name: 'FCMToken')
  final String? fcmToken;

  @JsonKey(name: 'Country')
  final String? country;

  @JsonKey(name: 'DOB')
  final String? dob;

  @JsonKey(name: 'Gender')
  final String? gender;

  @JsonKey(name: 'UserName')
  final String? userName;

  @JsonKey(name: 'Phone')
  final String? phone;

  @JsonKey(name: 'Location')
  final String? location;

  @JsonKey(name: 'PostalCode')
  final String? postalCode;

  @JsonKey(name: 'AboutMe')
  final String? aboutMe;

  @JsonKey(name: 'Follow')
  int? follow;

  @JsonKey(name: 'FollowedBy')
  final int? followedBy;

  @JsonKey(name: 'Followers')
  int? followers;

  @JsonKey(name: 'Followings')
  int? followings;

  @JsonKey(name: 'Posts')
  final int? posts;

  @JsonKey(name: 'IsLive')
  final int? isLive;

  @JsonKey(name: 'RTCToken')
  final String? rtcToken;

  @JsonKey(name: 'RTMToken')
  final String? rtmToken;

  @JsonKey(name: 'Wallet')
  final double? wallet;

  User copyWith({
    int? userId,
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? fullName,
    String? profilePic,
    String? token,
    String? fcmToken,
    String? country,
    String? dob,
    String? gender,
    String? userName,
    String? phone,
    String? location,
    String? postalCode,
    String? aboutMe,
    int? follow,
    int? followedBy,
    int? followers,
    int? followings,
    int? posts,
    int? isLive,
    String? rtcToken,
    String? rtmToken,
    double? wallet
  }) {
    return User(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullName: fullName ?? this.fullName,
      profilePic: profilePic ?? this.profilePic,
      token: token ?? this.token,
      fcmToken: fcmToken ?? this.fcmToken,
      country: country ?? this.country,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      userName: userName ?? this.userName,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      postalCode: postalCode ?? this.postalCode,
      aboutMe: aboutMe ?? this.aboutMe,
      follow: follow ?? this.follow,
      followedBy: followedBy ?? this.followedBy,
      followers: followers ?? this.followers,
      followings: followings ?? this.followings,
      posts: posts ?? this.posts,
      isLive: isLive ?? this.isLive,
      rtcToken: rtcToken ?? this.rtcToken,
      rtmToken: rtmToken ?? this.rtmToken,
      wallet: wallet ?? this.wallet,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

}

List<User> userFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));