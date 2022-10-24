// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiRes _$ApiResFromJson(Map<String, dynamic> json) => ApiRes(
      code: json['Code'] as int?,
      message: json['Message'] as String?,
      users: json['Users'],
      user: json['User'],
      feeds: json['Feeds'],
      feed: json['Feed'],
      token: json['Token'],
      feedComments: json['FeedComments'],
      messages: json['Messages'],
      listing: json['Listing'] == null
          ? null
          : Listing.fromJson(json['Listing'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApiResToJson(ApiRes instance) => <String, dynamic>{
      'Code': instance.code,
      'Message': instance.message,
      'Users': instance.users,
      'User': instance.user,
      'Feeds': instance.feeds,
      'Feed': instance.feed,
      'Token': instance.token,
      'FeedComments': instance.feedComments,
      'Messages': instance.messages,
      'Listing': instance.listing,
    };

Listing _$ListingFromJson(Map<String, dynamic> json) => Listing(
      itemId: json['ItemID'] as int?,
      userId: json['UserID'] as int?,
      price: json['Price'] as int?,
      quantity: json['Quantity'] as int?,
      files: (json['files'] as List<dynamic>?)
          ?.map((e) => FileElement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListingToJson(Listing instance) => <String, dynamic>{
      'ItemID': instance.itemId,
      'UserID': instance.userId,
      'Price': instance.price,
      'Quantity': instance.quantity,
      'files': instance.files,
    };

FileElement _$FileElementFromJson(Map<String, dynamic> json) => FileElement(
      filePath: json['FilePath'] as String?,
    );

Map<String, dynamic> _$FileElementToJson(FileElement instance) =>
    <String, dynamic>{
      'FilePath': instance.filePath,
    };
