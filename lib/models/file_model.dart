import 'dart:convert';

class FileModel {
  List<String>? files;
  String? folder;

  FileModel({this.files, this.folder});

  FileModel.fromJson(Map<String, dynamic> json) {
    files = json['files'].cast<String>();
    folder = json['folderName'];
  }
}

// To parse this JSON data, do
//
//     final videoFile = videoFileFromJson(jsonString);

List<VideoFile> videoFileFromJson(String str) => List<VideoFile>.from(json.decode(str).map((x) => VideoFile.fromJson(x)));

String videoFileToJson(List<VideoFile> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VideoFile {
  VideoFile({
    this.files,
    this.folder,
  });

  List<FileElement>? files;
  String? folder;

  factory VideoFile.fromJson(Map<String, dynamic> json) => VideoFile(
    files: List<FileElement>.from(json["files"].map((x) => FileElement.fromJson(x))),
    folder: json["folderName"],
  );

  Map<String, dynamic> toJson() => {
    "files": files != null ? List<dynamic>.from(files!.map((x) => x.toJson())) : [],
    "folderName": folder,
  };
}

class FileElement {
  FileElement({
    this.album,
    this.artist,
    this.path,
    this.dateAdded,
    this.displayName,
    this.duration,
    this.size,
  });

  String? album;
  String? artist;
  String? path;
  String? dateAdded;
  String? displayName;
  String? duration;
  String? size;

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
    album: json["album"],
    artist: json["artist"],
    path: json["path"],
    dateAdded: json["dateAdded"],
    displayName: json["displayName"],
    duration: json["duration"],
    size: json["size"],
  );

  Map<String, dynamic> toJson() => {
    "album": album,
    "artist": artist,
    "path": path,
    "dateAdded": dateAdded,
    "displayName": displayName,
    "duration": duration,
    "size": size,
  };
}
