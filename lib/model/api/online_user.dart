// To parse required this JSON data, do
//
//     final onlineUser = onlineUserFromJson(jsonString);

import 'dart:convert';

OnlineUser onlineUserFromJson(String str) => OnlineUser.fromJson(json.decode(str));

String onlineUserToJson(OnlineUser data) => json.encode(data.toJson());

class OnlineUser {
    OnlineUser({
        required this.data,
    });

    List<Datum> data;

    factory OnlineUser.fromJson(Map<String, dynamic> json) => OnlineUser(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        required this.id,
        required this.email,
        required this.name,
        required this.photoProfile,
        required this.status,
    });

    String id;
    String email;
    String name;
    dynamic photoProfile;
    String status;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        email: json["email"],
        name: json["name"],
        photoProfile: json["photo_profile"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "email": email,
        "name": name,
        "photo_profile": photoProfile,
        "status": status,
    };
}
