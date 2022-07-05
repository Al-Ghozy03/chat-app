// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, prefer_const_constructors_in_immutables, prefer_typing_uninitialized_variables, sized_box_for_whitespace, curly_braces_in_flow_control_structures, avoid_print
import 'dart:async';

import 'package:chat_app/screen/auth/login.dart';
import 'package:chat_app/screen/user/edit.dart';
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

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future profile;
  bool isDark = false;
  late Future myFriend;
  bool hasLoading = false;
  String userId = Jwt.parseJwt(storage.read("token"))["id"];
  final Controller controller = Get.put(Controller());

  FutureOr refetch() {
    profile = ApiService().profile(userId);
  }

  Future logout() async {
    Uri url = Uri.parse("$baseUrl/user/logout");
    headers["Authorization"] = "Bearer ${storage.read("token")}";
    final res = await http.delete(url, headers: headers);
    if (res.statusCode == 200) {
      socket.emit("offline", Jwt.parseJwt(storage.read("token"))["id"]);
      storage.remove("token");
      Get.offAll(Login(), transition: Transition.rightToLeft);
      return true;
    } else {
      print(res.body);
    }
  }

  Future friend() async {
    Uri url = Uri.parse("$baseUrl/friend?id=$userId");
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

  void bottomDialog() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(MediaQuery.of(context).size.width / 20),
          topRight: Radius.circular(MediaQuery.of(context).size.width / 20),
        )),
        context: context,
        clipBehavior: Clip.antiAlias,
        builder: (context) {
          final width = MediaQuery.of(context).size.width;
          return Container(
            height: width / 3,
            padding: EdgeInsets.all(width / 25),
            color: Colors.white,
            child: StatefulBuilder(
              builder: (context, StateSetter stateSetter) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Iconsax.moon,
                              size: MediaQuery.of(context).size.width / 17,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 30,
                            ),
                            Text(
                              "Dark mode",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 28),
                            ),
                          ],
                        ),
                        Switch(
                            value: isDark,
                            onChanged: (value) {
                              stateSetter(() {
                                isDark = value;
                              });
                            })
                      ],
                    ),
                    SizedBox(height: width / 20),
                    InkWell(
                      onTap: () {
                        logout();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Iconsax.logout,
                                size: width / 17,
                              ),
                              SizedBox(
                                width: width / 30,
                              ),
                              Text(
                                "Logout",
                                style: TextStyle(fontSize: width / 28),
                              ),
                            ],
                          ),
                          Icon(Iconsax.arrow_right_3)
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        });
  }

  @override
  void initState() {
    profile = ApiService().profile(userId);
    myFriend = friend();
    myFriend.then((value) => controller.increment(value.data.length));
    super.initState();
  }

  @override
  void dispose() {
    controller.toDefault();
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
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: () {
                        bottomDialog();
                      },
                      icon: Icon(Icons.menu)),
                ),
                SizedBox(height: width / 15),
                FutureBuilder(
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState != ConnectionState.done)
                        return Text("Loading");
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
            return InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      data.from == token
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
                        data.from == token
                            ? data.receiver[0].name
                            : data.asker[0].name,
                        style: TextStyle(
                            fontFamily: "popinsemi", fontSize: width / 24),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                              vertical: width / 55, horizontal: width / 40),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(width: 2, color: greenTheme),
                              borderRadius: BorderRadius.circular(width / 55))),
                      onPressed: () {},
                      icon: Icon(Iconsax.user_tick,
                          size: width / 20, color: greenTheme),
                      label: Text(
                        "Friend",
                        style: TextStyle(
                            color: greenTheme,
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
        Container(
          width: width,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: greenTheme,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(width / 50)),
                  padding: EdgeInsets.symmetric(
                      horizontal: width / 25, vertical: width / 80)),
              onPressed: () {
                Get.to(EditProfile(data: data.data),
                        transition: Transition.rightToLeftWithFade)
                    ?.then((value) {
                  setState(() {
                    profile = ApiService().profile(userId);
                  });
                });
              },
              child:
                  Text("Edit profile", style: TextStyle(fontSize: width / 25))),
        )
        // Row(
        //   children: [
        //     ElevatedButton.icon(
        //       onPressed: () {},
        //       style: ElevatedButton.styleFrom(
        //           primary: greenTheme,
        //           shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(width / 50)),
        //           padding: EdgeInsets.symmetric(
        //               horizontal: width / 25, vertical: width / 80)),
        //       icon: Icon(
        //         Iconsax.user_add,
        //         size: width / 18,
        //       ),
        //       label: Text(
        //         "Confirm",
        //         style: TextStyle(
        //             color: Colors.white,
        //             fontFamily: "popinmedium",
        //             fontSize: width / 29),
        //       ),
        //     ),
        //     SizedBox(
        //       width: width / 30,
        //     ),
        //     TextButton.icon(
        //       onPressed: () {},
        //       icon: Icon(Iconsax.message,
        //           size: width / 18, color: grayText),
        //       label: Text(
        //         "Delete",
        //         style: TextStyle(
        //             color: grayText,
        //             fontFamily: "popinmedium",
        //             fontSize: width / 29),
        //       ),
        //     )
        //   ],
        // )
      ],
    );
  }
}
