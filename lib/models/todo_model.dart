// To parse this JSON data, do
//
//     final todoModel = todoModelFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class TodoModel {
  TodoModel({
    @required this.id,
    @required this.color,
    @required this.todos,
    @required this.createdAt,
    @required this.isLock,
  });

  String id;
  dynamic color;
  List<Todo> todos;
  String createdAt;
  bool isLock;

  factory TodoModel.fromJson(String str) => TodoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TodoModel.fromMap(Map<dynamic, dynamic> json) => TodoModel(
        id: json["id"] == null ? null : json["id"],
        color: json["color"] == null ? null : json["color"],
        todos: json["todos"] == null
            ? null
            : List<Todo>.from(json["todos"].map((x) => Todo.fromMap(x))),
        createdAt: json["created_at"] == null ? null : json["created_at"],
        isLock: json["isLock"] == null ? null : json["isLock"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "color": color == null ? null : color,
        "todos": todos == null
            ? null
            : List<dynamic>.from(todos.map((x) => x.toMap())),
        "created_at": createdAt == null ? null : createdAt,
        "isLock": isLock == null ? null : isLock,
      };
}

class Todo {
  Todo({
    @required this.task,
    @required this.check,
  });

  String task;
  bool check;

  factory Todo.fromJson(String str) => Todo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Todo.fromMap(Map<dynamic, dynamic> json) => Todo(
        task: json["task"] == null ? null : json["task"],
        check: json["check"] == null ? null : json["check"],
      );

  Map<String, dynamic> toMap() => {
        "task": task == null ? null : task,
        "check": check == null ? null : check,
      };
}
