// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  User({
    required this.userId,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.profilePic,
    required this.token,
    required this.fcmToken,
    required this.country,
    required this.dob,
    required this.gender,
    required this.userName,
    required this.phone,
    required this.location,
    required this.postalCode,
    required this.aboutMe,
    required this.followedBy,
    required this.followers,
    required this.followings,
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

  @JsonKey(name: 'ProfilePic')
  final String? profilePic;

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

  @JsonKey(name: 'FollowedBy')
  final int? followedBy;

  @JsonKey(name: 'Followers')
  final int? followers;

  @JsonKey(name: 'Followings')
  final int? followings;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

}
