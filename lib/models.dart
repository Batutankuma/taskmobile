import 'dart:convert';

List<Task> taskFromJson(String str) =>
    List<Task>.from(json.decode(str).map((x) => Task.fromJson(x)));
List<Task> listFromJson(data) =>
    data.map<Task>((json) => Task.fromJson(json)).toList();

String taskToJson(List<Task> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Task {
  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.userId,
  });

  String id;
  String title;
  String description;
  String priority;
  bool status;
  String userId;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        priority: json["priority"],
        status: json["status"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "priority": priority,
        "status": status,
        "userId": userId,
      };
}

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.id,
    required this.name,
    required this.lastname,
    required this.email,
    required this.password,
    required this.avatar,
    required this.createAt,
    required this.updateAt,
  });

  String id;
  String name;
  String lastname;
  String email;
  String password;
  String avatar;
  DateTime createAt;
  DateTime updateAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        lastname: json["lastname"],
        email: json["email"],
        password: json["password"],
        avatar: json["avatar"],
        createAt: DateTime.parse(json["createAt"]),
        updateAt: DateTime.parse(json["updateAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastname": lastname,
        "email": email,
        "password": password,
        "avatar": avatar,
        "createAt": createAt.toIso8601String(),
        "updateAt": updateAt.toIso8601String(),
      };
}
