// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, prefer_const_constructors_in_immutables, prefer_typing_uninitialized_variables, sized_box_for_whitespace, curly_braces_in_flow_control_structures, avoid_print, use_key_in_widget_constructors, must_be_immutable
import 'dart:async';

import 'package:chat_app/service/getx_service.dart';
import 'package:chat_app/service/api_service.dart';
import 'package:chat_app/color.dart';
import 'package:chat_app/model/api/friend_model.dart';
import 'package:chat_app/model/api/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';

class ProfileFriend extends StatefulWidget {
  String id;
  ProfileFriend({required this.id});
  @override
  State<ProfileFriend> createState() => _ProfileFriendState();
}

class _ProfileFriendState extends State<ProfileFriend> {
  late Future profile;
  bool isDark = false;
  late Future myFriend;
  bool hasLoading = false;
  final Controller controller = Get.put(Controller());
  int limit = 10;
  int page = 1;

  FutureOr refetch() {
    profile = ApiService().profile(widget.id);
  }

  Future friend() async {
    Uri url =
        Uri.parse("$baseUrl/friend?id=${widget.id}&limit=$limit&page=$page");
    headers["Authorization"] = "Bearer ${storage.read("token")} ";
    final res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      setState(() {
        hasLoading = true;
      });
      return friendFromJson(res.body);
    } else {
      return false;
    }
  }

  @override
  void initState() {
    profile = ApiService().profile(widget.id);
    myFriend = friend();
    myFriend.then((value) => controller.setFriend(value.total));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(width / 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Iconsax.arrow_left)),
                SizedBox(height: width / 15),
                FutureBuilder(
                    builder: (context, AsyncSnapshot snapshot) {
                      if (!hasLoading) {
                        if (snapshot.connectionState != ConnectionState.done)
                          return Text("Loading");
                      }
                      if (snapshot.hasError) return Text("error");
                      if (snapshot.hasData)
                        return _profileBuilder(width, snapshot.data);
                      return Text("kosong");
                    },
                    future: profile),
                SizedBox(height: width / 20),
                FutureBuilder(
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState != ConnectionState.done)
                        return Text("Loading");
                      if (snapshot.hasError) return Text("error");
                      if (snapshot.hasData)
                        return _friendBuilder(width, snapshot.data);
                      return Text("kosong");
                    },
                    future: myFriend),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _friendBuilder(width, Friend data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Friends",
            style: TextStyle(fontSize: width / 23, fontFamily: "popinsemi")),
        SizedBox(height: width / 20),
        StaggeredGrid.count(
          crossAxisCount: 1,
          mainAxisSpacing: width / 20,
          children: data.data.map((data) {
            String token = Jwt.parseJwt(storage.read("token"))["id"];
            bool isAsking = false;
            bool isAsked = false;
            bool isMe = false;
            bool isFriend = false;
            // ----------------------------------
            if (data.asker.any((element) => element.id == token) ||
                data.receiver.any((element) => element.id == token)) {
              isMe = true;
            }
            // ----------------------------------
            // isAsking = data.asker[0].from.any((element) =>
            //     element.from == token && element.status == "ask" ||
            //     element.to == token && element.status == "ask");
            // isAsking = data.asker[0].to.any((element) =>
            //     element.from == token && element.status == "ask" ||
            //     element.to == token && element.status == "ask");

            if (data.from == widget.id) {
              isAsked = data.receiver[0].from.any((element) =>
                  element.to == token &&
                  element.status == "ask" &&
                  element.from != token);
            } else {
              isAsked = data.asker[0].from.any((element) =>
                  element.to == token &&
                  element.status == "ask" &&
                  element.from != token);
            }

            if (data.from == widget.id) {
              if (data.receiver[0].from.isNotEmpty &&
                  data.receiver[0].to.isEmpty) {
                isFriend = data.receiver[0].from.any((element) =>
                    element.from == token && element.status == "friend" ||
                    element.to == token && element.status == "friend");
              }

              if (data.receiver[0].from.isEmpty &&
                  data.receiver[0].to.isNotEmpty) {
                isFriend = data.receiver[0].to.any((element) =>
                    element.from == token && element.status == "friend" ||
                    element.to == token && element.status == "friend");
              }

              if (data.receiver[0].from.isNotEmpty &&
                  data.receiver[0].to.isNotEmpty) {
                isFriend = data.receiver[0].from.any((element) =>
                    element.from == token && element.status == "friend" ||
                    element.to == token && element.status == "friend");
              }
            } else {
              if (data.asker[0].from.isNotEmpty && data.asker[0].to.isEmpty) {
                isFriend = data.asker[0].from.any((element) =>
                    element.from == token && element.status == "friend" ||
                    element.to == token && element.status == "friend");
              }

              if (data.asker[0].from.isEmpty && data.asker[0].to.isNotEmpty) {
                isFriend = data.asker[0].to.any((element) =>
                    element.from == token && element.status == "friend" ||
                    element.to == token && element.status == "friend");
              }

              if (data.asker[0].from.isNotEmpty &&
                  data.asker[0].to.isNotEmpty) {
                isFriend = data.asker[0].from.any((element) =>
                    element.from == token && element.status == "friend" ||
                    element.to == token && element.status == "friend");
              }
            }

            if (data.from == widget.id) {
              if (data.receiver[0].to.any((element) =>
                      element.from == token && element.status == "ask") ||
                  data.receiver[0].from.any((element) =>
                      element.from == token && element.status == "ask")) {
                isAsking = true;
              } else {
                isAsking = false;
              }
            } else {
              if (data.asker[0].to.any((element) =>
                      element.from == token && element.status == "ask") ||
                  data.asker[0].from.any((element) =>
                      element.from == token && element.status == "ask")) {
                isAsking = true;
              } else {
                isAsking = false;
              }
            }

            return InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      data.from == widget.id
                          ? data.receiver[0].photoProfile == null
                              ? CircleAvatar(
                                  minRadius: width / 17,
                                  maxRadius: width / 17,
                                  backgroundColor: grayInput,
                                  child: Icon(
                                    Iconsax.user,
                                    size: width / 20,
                                    color: grayText,
                                  ),
                                )
                              : CircleAvatar(
                                  minRadius: width / 17,
                                  maxRadius: width / 17,
                                  backgroundColor: grayInput,
                                  backgroundImage: NetworkImage(
                                      data.receiver[0].photoProfile),
                                )
                          : data.asker[0].photoProfile == null
                              ? CircleAvatar(
                                  minRadius: width / 17,
                                  maxRadius: width / 17,
                                  backgroundColor: grayInput,
                                  child: Icon(
                                    Iconsax.user,
                                    size: width / 20,
                                    color: grayText,
                                  ),
                                )
                              : CircleAvatar(
                                  minRadius: width / 17,
                                  maxRadius: width / 17,
                                  backgroundColor: grayInput,
                                  backgroundImage:
                                      NetworkImage(data.asker[0].photoProfile),
                                ),
                      SizedBox(
                        width: width / 30,
                      ),
                      Text(
                        data.from == widget.id
                            ? data.receiver[0].name
                            : data.asker[0].name,
                        style: TextStyle(
                            fontFamily: "popinsemi", fontSize: width / 24),
                      ),
                    ],
                  ),
                  isAsked
                      ? Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                ApiService()
                                    .acceptFriend(data.from == widget.id
                                        ? data.receiver[0].id
                                        : data.asker[0].id)
                                    .then((value) {
                                  setState(() {
                                    myFriend = friend();
                                  });
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: greenTheme,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(width / 50)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width / 25,
                                      vertical: width / 80)),
                              child: Text(
                                "Confirm",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "popinmedium",
                                    fontSize: width / 29),
                              ),
                            ),
                            SizedBox(
                              width: width / 30,
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Delete",
                                style: TextStyle(
                                    color: grayText,
                                    fontFamily: "popinmedium",
                                    fontSize: width / 29),
                              ),
                            )
                          ],
                        )
                      : isMe
                          ? Container()
                          : ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  primary: isAsking
                                      ? Colors.white
                                      : isFriend
                                          ? Colors.white
                                          : greenTheme,
                                  elevation: 0,
                                  padding: EdgeInsets.symmetric(
                                      vertical: width / 55,
                                      horizontal: width / 40),
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 2,
                                          color:
                                              isAsking ? grayText : greenTheme),
                                      borderRadius:
                                          BorderRadius.circular(width / 55))),
                              onPressed: () {
                                if (!isFriend && !isAsking) {
                                  ApiService()
                                      .addFriend(data.from == widget.id
                                          ? data.receiver[0].id
                                          : data.asker[0].id)
                                      .then((value) {
                                    // setState(() {
                                    myFriend = friend();
                                    // });
                                  });
                                }
                              },
                              icon: Icon(
                                  isAsking
                                      ? Iconsax.clock
                                      : isFriend
                                          ? Iconsax.user_tick
                                          : Iconsax.user_add,
                                  size: width / 20,
                                  color: isAsking
                                      ? grayText
                                      : isFriend
                                          ? greenTheme
                                          : Colors.white),
                              label: Text(
                                isAsking
                                    ? "Asking"
                                    : isFriend
                                        ? "Friend"
                                        : "Add friend",
                                style: TextStyle(
                                    color: isAsking
                                        ? grayText
                                        : isFriend
                                            ? greenTheme
                                            : Colors.white,
                                    fontSize: width / 35,
                                    fontFamily: "popinsemi"),
                              ))
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _profileBuilder(width, Profile data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            data.data.photoProfile == null
                ? CircleAvatar(
                    maxRadius: width / 8,
                    minRadius: width / 8,
                    backgroundColor: grayInput,
                    child:
                        Icon(Iconsax.user, color: grayText, size: width / 10),
                  )
                : CircleAvatar(
                    maxRadius: width / 8,
                    minRadius: width / 8,
                    backgroundColor: grayInput,
                    backgroundImage: NetworkImage(data.data.photoProfile),
                  ),
            SizedBox(width: width / 15),
            Column(
              children: [
                Text(controller.totalFriend.toString(),
                    style: TextStyle(
                        fontFamily: "popinsemi", fontSize: width / 20)),
                Text("Friends", style: TextStyle(fontSize: width / 32))
              ],
            )
          ],
        ),
        SizedBox(height: width / 20),
        Text(data.data.name,
            style: TextStyle(fontSize: width / 23, fontFamily: "popinsemi")),
        SizedBox(height: width / 40),
        data.data.bio == null
            ? Text("")
            : Text(data.data.bio,
                style: TextStyle(fontSize: width / 30, color: grayText)),
        SizedBox(height: width / 20),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  primary: greenTheme,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(width / 50)),
                  padding: EdgeInsets.symmetric(
                      horizontal: width / 25, vertical: width / 80)),
              icon: Icon(
                Iconsax.user_add,
                size: width / 18,
              ),
              label: Text(
                "Confirm",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "popinmedium",
                    fontSize: width / 29),
              ),
            ),
            SizedBox(
              width: width / 30,
            ),
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Iconsax.message, size: width / 18, color: grayText),
              label: Text(
                "Delete",
                style: TextStyle(
                    color: grayText,
                    fontFamily: "popinmedium",
                    fontSize: width / 29),
              ),
            )
          ],
        )
      ],
    );
  }
}
