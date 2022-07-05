// To parse required this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'dart:convert';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
    Profile({
        required this.data,
    });

    Data data;

    factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

class Data {
    Data({
        required this.id,
        required this.email,
        required this.name,
        required this.bio,
        required this.photoProfile,
        required this.status,
    });

    String id;
    String email;
    String name;
    dynamic bio;
    dynamic photoProfile;
    String status;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        email: json["email"],
        name: json["name"],
        bio: json["bio"],
        photoProfile: json["photo_profile"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "email": email,
        "name": name,
        "bio": bio,
        "photo_profile": photoProfile,
        "status": status,
    };
}
