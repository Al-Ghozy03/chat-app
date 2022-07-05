// To parse required this JSON data, do
//
//     final friend = friendFromJson(jsonString);

import 'dart:convert';

Friend friendFromJson(String str) => Friend.fromJson(json.decode(str));

String friendToJson(Friend data) => json.encode(data.toJson());

class Friend {
    Friend({
        required this.total,
        required this.data,
    });

    int total;
    List<Datum> data;

    factory Friend.fromJson(Map<String, dynamic> json) => Friend(
        total: json["total"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        required this.id,
        required this.from,
        required this.to,
        required this.status,
        required this.asker,
        required this.receiver,
    });

    String id;
    String from;
    String to;
    String status;
    List<Asker> asker;
    List<Asker> receiver;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        from: json["from"],
        to: json["to"],
        status: json["status"],
        asker: List<Asker>.from(json["asker"].map((x) => Asker.fromJson(x))),
        receiver: List<Asker>.from(json["receiver"].map((x) => Asker.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "from": from,
        "to": to,
        "status": status,
        "asker": List<dynamic>.from(asker.map((x) => x.toJson())),
        "receiver": List<dynamic>.from(receiver.map((x) => x.toJson())),
    };
}

class Asker {
    Asker({
        required this.id,
        required this.email,
        required this.name,
        required this.photoProfile,
        required this.status,
        required this.from,
        required this.to,
    });

    String id;
    String email;
    String name;
    dynamic photoProfile;
    String status;
    List<From> from;
    List<From> to;

    factory Asker.fromJson(Map<String, dynamic> json) => Asker(
        id: json["_id"],
        email: json["email"],
        name: json["name"],
        photoProfile: json["photo_profile"],
        status: json["status"],
        from: List<From>.from(json["from"].map((x) => From.fromJson(x))),
        to: List<From>.from(json["to"].map((x) => From.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "email": email,
        "name": name,
        "photo_profile": photoProfile,
        "status": status,
        "from": List<dynamic>.from(from.map((x) => x.toJson())),
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
