import 'package:meta/meta.dart';
import 'dart:convert';

class NoteModel {
  NoteModel({
    @required this.id,
    @required this.title,
    @required this.notes,
    @required this.color,
    @required this.createdAt,
    @required this.isLock,
  });

  String id;
  String title;
  String notes;
  dynamic color;
  String createdAt;
  bool isLock;

  factory NoteModel.fromJson(String str) => NoteModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NoteModel.fromMap(Map<dynamic, dynamic> json) => NoteModel(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        notes: json["notes"] == null ? null : json["notes"],
        color: json["color"] == null ? null : json["color"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
    isLock: json["isLock"] == null ? null : json["isLock"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "notes": notes == null ? null : notes,
        "color": color == null ? null : color,
        "created_at": createdAt == null ? null : createdAt,
    "isLock": isLock == null ? null : isLock,
      };
}
