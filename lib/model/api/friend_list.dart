// To parse required this JSON data, do
//
//     final friendList = friendListFromJson(jsonString);

import 'dart:convert';

FriendList friendListFromJson(String str) =>
    FriendList.fromJson(json.decode(str));

String friendListToJson(FriendList data) => json.encode(data.toJson());

class FriendList {
  FriendList({
    required this.total,
    required this.data,
  });
  int total;
  List<Datum> data;

  factory FriendList.fromJson(Map<String, dynamic> json) => FriendList(
        total: json["total"],
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
    required this.status,
    required this.photoProfile,
    required this.from,
    required this.to,
  });

  String id;
  String email;
  String name;
  String status;
  dynamic photoProfile;
  List<From> from;
  List<To> to;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        email: json["email"],
        name: json["name"],
        status: json["status"],
        photoProfile: json["photo_profile"],
        from: List<From>.from(json["from"].map((x) => From.fromJson(x))),
        to: List<To>.from(json["to"].map((x) => To.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "email": email,
        "name": name,
        "status": status,
        "photo_profile": photoProfile,
        "from": List<dynamic>.from(from.map((x) => x)),
        "to": List<dynamic>.from(to.map((x) => x.toJson())),
      };
}

class From {
  From({
    required this.id,
    required this.from,
    required this.to,
    required this.status,
  });

  String id;
  String from;
  String to;
  String status;

  factory From.fromJson(Map<String, dynamic> json) => From(
        id: json["_id"],
        from: json["from"],
        to: json["to"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "from": from,
        "to": to,
        "status": status,
      };
}

class To {
  To({
    required this.id,
    required this.from,
    required this.to,
    required this.status,
  });

  String id;
  String from;
  String to;
  String status;

  factory To.fromJson(Map<String, dynamic> json) => To(
        id: json["_id"],
        from: json["from"],
        to: json["to"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "from": from,
        "to": to,
        "status": status,
      };
}
