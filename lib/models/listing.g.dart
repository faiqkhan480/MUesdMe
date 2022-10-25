// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Listing _$ListingFromJson(Map<String, dynamic> json) => Listing(
      userId: json['UserID'] as int?,
      itemId: json['ItemID'] as int?,
      price: (json['Price'] as num?)?.toDouble(),
      quantity: json['Quantity'] as int?,
      type: json['Type'] as String?,
      category: json['Category'] as String?,
      title: json['Title'] as String?,
      status: json['Status'] as String?,
      mainFile: json['MainFile'] as String?,
      description: json['Description'] as String?,
      userDetails: json['UserDetails'] == null
          ? null
          : User.fromJson(json['UserDetails'] as Map<String, dynamic>),
      files: (json['files'] as List<dynamic>?)
          ?.map((e) => FileElement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListingToJson(Listing instance) => <String, dynamic>{
      'UserID': instance.userId,
      'ItemID': instance.itemId,
      'Price': instance.price,
      'Quantity': instance.quantity,
      'Type': instance.type,
      'Category': instance.category,
      'Title': instance.title,
      'Status': instance.status,
      'MainFile': instance.mainFile,
      'UserDetails': instance.userDetails,
      'Description': instance.description,
      'files': instance.files,
    };

FileElement _$FileElementFromJson(Map<String, dynamic> json) => FileElement(
      filePath: json['FilePath'] as String?,
    );

Map<String, dynamic> _$FileElementToJson(FileElement instance) =>
    <String, dynamic>{
      'FilePath': instance.filePath,
    };
