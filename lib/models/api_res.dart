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
  final Listing? listing;

  factory ApiRes.fromJson(Map<String, dynamic> json) => _$ApiResFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResToJson(this);
}

@JsonSerializable()
class Listing {
  Listing({
    required this.itemId,
    required this.userId,
    required this.price,
    required this.quantity,
    required this.files,
  });

  @JsonKey(name: 'ItemID')
  final int? itemId;

  @JsonKey(name: 'UserID')
  final int? userId;

  @JsonKey(name: 'Price')
  final int? price;

  @JsonKey(name: 'Quantity')
  final int? quantity;
  final List<FileElement>? files;

  Listing copyWith({
    int? itemId,
    int? userId,
    int? price,
    int? quantity,
    List<FileElement>? files,
  }) {
    return Listing(
      itemId: itemId ?? this.itemId,
      userId: userId ?? this.userId,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      files: files ?? this.files,
    );
  }

  factory Listing.fromJson(Map<String, dynamic> json) => _$ListingFromJson(json);

  Map<String, dynamic> toJson() => _$ListingToJson(this);

}

@JsonSerializable()
class FileElement {
  FileElement({
    required this.filePath,
  });

  @JsonKey(name: 'FilePath')
  final String? filePath;

  FileElement copyWith({
    String? filePath,
  }) {
    return FileElement(
      filePath: filePath ?? this.filePath,
    );
  }

  factory FileElement.fromJson(Map<String, dynamic> json) => _$FileElementFromJson(json);

  Map<String, dynamic> toJson() => _$FileElementToJson(this);

}
