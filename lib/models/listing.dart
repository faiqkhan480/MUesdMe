import 'package:json_annotation/json_annotation.dart';

part 'listing.g.dart';

@JsonSerializable()
class Listing {
  Listing({
    required this.userId,
    required this.price,
    required this.quantity,
    required this.type,
    required this.category,
    required this.title,
    required this.status,
    required this.description,
    required this.files,
  });

  @JsonKey(name: 'UserID')
  final int? userId;

  @JsonKey(name: 'Price')
  final double? price;

  @JsonKey(name: 'Quantity')
  final int? quantity;

  @JsonKey(name: 'Type')
  final String? type;

  @JsonKey(name: 'Category')
  final String? category;

  @JsonKey(name: 'Title')
  final String? title;

  @JsonKey(name: 'Status')
  final String? status;

  @JsonKey(name: 'Description')
  final String? description;
  final List<FileElement>? files;

  Listing copyWith({
    int? userId,
    double? price,
    int? quantity,
    String? type,
    String? category,
    String? title,
    String? status,
    String? description,
    List<FileElement>? files,
  }) {
    return Listing(
      userId: userId ?? this.userId,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      type: type ?? this.type,
      category: category ?? this.category,
      title: title ?? this.title,
      status: status ?? this.status,
      description: description ?? this.description,
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
