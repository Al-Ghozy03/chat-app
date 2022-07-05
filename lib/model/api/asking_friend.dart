// To parse required this JSON data, do
//
//     final askingFriend = askingFriendFromJson(jsonString);

import 'dart:convert';

AskingFriend askingFriendFromJson(String str) => AskingFriend.fromJson(json.decode(str));

String askingFriendToJson(AskingFriend data) => json.encode(data.toJson());

class AskingFriend {
    AskingFriend({
        required this.data,
    });

    List<Datum> data;

    factory AskingFriend.fromJson(Map<String, dynamic> json) => AskingFriend(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        required this.id,
        required this.from,
        required this.to,
        required this.status,
        required this.user,
    });

    String id;
    String from;
    String to;
    String status;
    List<User> user;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        from: json["from"],
        to: json["to"],
        status: json["status"],
        user: List<User>.from(json["user"].map((x) => User.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "from": from,
        "to": to,
        "status": status,
        "user": List<dynamic>.from(user.map((x) => x.toJson())),
    };
}

class User {
    User({
        required this.id,
        required this.email,
        required this.name,
        required this.photoProfile,
        required this.status
    });

    String id;
    String email;
    String name;
    dynamic photoProfile;
    String status;

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        email: json["email"],
        name: json["name"],
        status: json["status"],
        photoProfile: json["photo_profile"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "email": email,
        "name": name,
        "status": status,
        "photo_profile": photoProfile,
    };
}
