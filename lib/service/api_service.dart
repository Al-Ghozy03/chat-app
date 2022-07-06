// ignore_for_file: unused_import, avoid_print, library_prefixes

import 'package:chat_app/model/api/friend_model.dart';
import 'package:chat_app/model/api/online_user.dart';
import 'package:chat_app/model/api/profile_model.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:socket_io_client/socket_io_client.dart' as Io;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

String baseUrl = "http://192.168.0.17:4003";
Map<String, String> headers = {
  "Content-Type": "application/json",
  "Authorization": ""
};
final storage = GetStorage();
Io.Socket socket = Io.io(baseUrl, <String, dynamic>{
  "transports": ["websocket"]
});

class ApiService {
  void connectSocket() {
    socket.onConnect((data) {
      socket.emit("online", Jwt.parseJwt(storage.read("token"))["id"]);
      print("connect");
    });
    socket.onConnectError((data) => print("error $data"));
    socket.onDisconnect((data) {
      socket.emit("offline", Jwt.parseJwt(storage.read("token"))["id"]);
    });
  }

  Future acceptFriend(String id) async {
    headers["Authorization"] = "Bearer ${storage.read("token")}";
    final res = await http.put(Uri.parse("$baseUrl/friend/accept/$id"),
        headers: headers);
    if (res.statusCode == 200) {
      print("ok");
      return true;
    } else {
      print(res.statusCode);
      return false;
    }
  }

  Future addFriend(String id) async {
    headers["Authorization"] = "Bearer ${storage.read("token")}";
    final res =
        await http.post(Uri.parse("$baseUrl/friend/add/$id"), headers: headers);
    if (res.statusCode == 200) {
      return true;
    } else {
      print(res.statusCode);
      return false;
    }
  }

  Future profile(String id) async {
    Uri url = Uri.parse("$baseUrl/user/profile/$id");
    headers["Authorization"] = "Bearer ${storage.read("token")} ";
    final res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      return profileFromJson(res.body);
    } else {
      print(res.statusCode);
      return false;
    }
  }

  Future userOnline() async {
    Uri url = Uri.parse("$baseUrl/user/online");
    headers["Authorization"] = "Bearer ${storage.read("token")} ";
    final res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      return onlineUserFromJson(res.body);
    } else {
      print(res.statusCode);
      return false;
    }
  }
}
