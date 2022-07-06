// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, curly_braces_in_flow_control_structures, iterable_contains_unrelated_type, non_constant_identifier_names, sized_box_for_whitespace
import 'dart:async';
import 'dart:convert';
import 'package:chat_app/screen/friend/friend.dart';
import 'package:chat_app/screen/friend/profile_friend.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/service/api_service.dart';
import 'package:chat_app/model/api/friend_list.dart';
import 'package:chat_app/screen/friend/asking_friend.dart';
import 'package:chat_app/color.dart';
import 'package:chat_app/widget/custom_title.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jwt_decode/jwt_decode.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  List menu = ["All", "Asking friend", "Friend"];
  int activeTab = 0;
  bool isLoading = false;
  int limit = 4;
  int counter = 5;
  bool hasLoading = false;
  late Future friend;
  List allFriend = [];
  ScrollController scrollController = ScrollController();

  FutureOr refetch(String key) {
    setState(() {
      limit = limit + counter;
    });
    friend = searchFriend(key);
  }

  Future searchFriend(String key) async {
    headers["Authorization"] = "Bearer ${storage.read("token")}";
    final res = await http.get(
        Uri.parse("$baseUrl/friend/search?key=$key&limit=$limit&page=1"),
        headers: headers);
    if (res.statusCode == 200) {
      setState(() {
        hasLoading = true;
      });
      List data = jsonDecode(res.body)["data"];
      data.map((data) {
        setState(() {
          allFriend.add(data);
        });
      }).toList();
      return friendListFromJson(res.body);
    } else {
      setState(() {
        isLoading = false;
      });
      return false;
    }
  }

  @override
  void initState() {
    friend = searchFriend("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
            padding: EdgeInsets.all(width / 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTitle(title: "Friends"),
                SizedBox(
                  height: width / 25,
                ),
                TextField(
                  onTap: () {
                    setState(() {
                      activeTab = 0;
                    });
                  },
                  onChanged: (value) {
                    refetch(value);
                  },
                  decoration: InputDecoration(
                      hintText: "Search people",
                      hintStyle: TextStyle(color: Color(0xffC1C1C1)),
                      suffixIcon: Icon(
                        Iconsax.search_normal_1,
                        color: Color(0xffC1C1C1),
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(width / 30)),
                      filled: true,
                      fillColor: Color(0xffF6F6F6)),
                ),
                SizedBox(
                  height: width / 20,
                ),
                Container(
                    margin: EdgeInsets.only(bottom: width / 30),
                    height: width / 13,
                    child: ListView.separated(
                        separatorBuilder: (_, i) => SizedBox(
                              width: width / 30,
                            ),
                        itemCount: menu.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, i) {
                          return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  primary: activeTab == i
                                      ? greenTheme
                                      : Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width / 18, vertical: 0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(width))),
                              onPressed: () {
                                setState(() {
                                  activeTab = i;
                                });
                              },
                              child: Text(menu[i],
                                  style: TextStyle(
                                      fontSize: activeTab == i
                                          ? width / 27
                                          : width / 30,
                                      color: activeTab == i
                                          ? Colors.white
                                          : grayText)));
                        })),
                SizedBox(
                  height: width / 20,
                ),
                activeTab == 0
                    ? FutureBuilder(
                        builder: (context, AsyncSnapshot snapshot) {
                          if (!hasLoading) {
                            if (snapshot.connectionState !=
                                ConnectionState.done) return _loading(width);
                          }
                          if (snapshot.hasError) return Text("error");
                          if (snapshot.hasData)
                            return _allBuilder(width, snapshot.data);
                          return Text("kosong");
                        },
                        future: friend,
                      )
                    : activeTab == 1
                        ? Asking()
                        : MyFriend(),
                SizedBox(
                  height: width / 20,
                ),
              ],
            )),
      )),
    );
  }

  Widget _allBuilder(width, FriendList data) {
    return Column(
      children: [
        StaggeredGrid.count(
          crossAxisCount: 1,
          mainAxisSpacing: width / 20,
          children: data.data.map((data) {
            String token = Jwt.parseJwt(storage.read("token"))["id"];
            bool isFriend = false;
            bool isAsking = false;
            
          // --------------------------------------
            bool isAsked = data.from.any((element) =>
                element.from != token &&
                element.status == "ask" &&
                element.to == token);
          // --------------------------------------

            isAsking = data.from.any((element) =>
                element.from == token && element.from == "ask" ||
                element.to == token && element.status == "ask");

            if (data.from.isNotEmpty && data.to.isEmpty) {
              isAsking = data.from.any((element) =>
                  element.from == token && element.status == "ask" );

              isFriend = data.from.any((element) =>
                  element.from == token && element.status == "friend" ||
                  element.to == token && element.status == "friend");
            }
            if (data.from.isEmpty && data.to.isNotEmpty) {
              isAsking = data.to.any((element) =>
                  element.from == token && element.status == "ask" );
              isFriend = data.to.any((element) =>
                  element.from == token && element.status == "friend" ||
                  element.to == token && element.status == "friend");
            }
            if (data.from.isNotEmpty && data.to.isNotEmpty) {
              isAsking = data.from.any((element) =>
                  element.from == token && element.status == "ask" );

              isFriend = data.from.any((element) =>
                  element.from == token && element.status == "friend" ||
                  element.to == token && element.status == "friend");
            }
            if (data.from.isEmpty && data.to.isNotEmpty) {
              isAsking = data.to.any((element) =>
                  element.from == token && element.status == "ask" );
              isFriend = data.to.any((element) =>
                  element.from == token && element.status == "friend" ||
                  element.to == token && element.status == "friend");
            }
            return InkWell(
              onTap: () => Get.to(ProfileFriend(id: data.id),
                  transition: Transition.rightToLeftWithFade),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      data.photoProfile == null
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
                              backgroundImage: NetworkImage(data.photoProfile),
                            ),
                      SizedBox(
                        width: width / 30,
                      ),
                      Text(
                        data.name,
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
                                    .acceptFriend(data.id)
                                    .then((value) {
                                  setState(() {
                                    friend = searchFriend("");
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
                      : ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              primary: isAsking
                                  ? Colors.white
                                  : isFriend
                                      ? Colors.white
                                      : greenTheme,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(
                                  vertical: width / 55, horizontal: width / 40),
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 2,
                                      color: isAsking
                                          ? grayInput
                                          : isFriend
                                              ? greenTheme
                                              : Colors.black.withOpacity(0)),
                                  borderRadius:
                                      BorderRadius.circular(width / 55))),
                          onPressed: () {
                            if (isAsking) return;
                            if (!isFriend) {
                              ApiService().addFriend(data.id).then((value) {
                                setState(() {
                                  friend = searchFriend("");
                                });
                              });
                              setState(() {
                                isAsking = true;
                              });
                            }
                          },
                          icon: Icon(
                            isAsking
                                ? Iconsax.clock
                                : !isFriend
                                    ? Iconsax.user_add
                                    : Iconsax.user_tick,
                            size: width / 20,
                            color: isAsking
                                ? grayText
                                : isFriend
                                    ? greenTheme
                                    : Colors.white,
                          ),
                          label: Text(
                            isAsking
                                ? "Asking"
                                : !isFriend
                                    ? "Add friend"
                                    : "Friend",
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
        SizedBox(
          height: width / 20,
        ),
        Center(
          child: TextButton(
              onPressed: () {
                refetch("");
              },
              child: Text(
                "More",
                style: TextStyle(color: grayText, fontSize: width / 30),
              )),
        ),
      ],
    );
  }

  Widget _loading(width) {
    return StaggeredGrid.count(
      crossAxisCount: 1,
      mainAxisSpacing: width / 20,
      children: [
        Row(
          children: [
            FadeShimmer.round(
              size: width / 7.5,
              baseColor: Colors.grey.withOpacity(0.5),
              highlightColor: Colors.grey.withOpacity(0.2),
            ),
            SizedBox(
              width: width / 30,
            ),
            FadeShimmer(
              radius: width,
              width: width / 2,
              height: width / 25,
              baseColor: Colors.grey.withOpacity(0.5),
              highlightColor: Colors.grey.withOpacity(0.2),
            )
          ],
        ),
        Row(
          children: [
            FadeShimmer.round(
              size: width / 7.5,
              baseColor: Colors.grey.withOpacity(0.5),
              highlightColor: Colors.grey.withOpacity(0.2),
            ),
            SizedBox(
              width: width / 30,
            ),
            FadeShimmer(
              radius: width,
              width: width / 2,
              height: width / 25,
              baseColor: Colors.grey.withOpacity(0.5),
              highlightColor: Colors.grey.withOpacity(0.2),
            )
          ],
        ),
        Row(
          children: [
            FadeShimmer.round(
              size: width / 7.5,
              baseColor: Colors.grey.withOpacity(0.5),
              highlightColor: Colors.grey.withOpacity(0.2),
            ),
            SizedBox(
              width: width / 30,
            ),
            FadeShimmer(
              radius: width,
              width: width / 2,
              height: width / 25,
              baseColor: Colors.grey.withOpacity(0.5),
              highlightColor: Colors.grey.withOpacity(0.2),
            )
          ],
        ),
        Row(
          children: [
            FadeShimmer.round(
              size: width / 7.5,
              baseColor: Colors.grey.withOpacity(0.5),
              highlightColor: Colors.grey.withOpacity(0.2),
            ),
            SizedBox(
              width: width / 30,
            ),
            FadeShimmer(
              radius: width,
              width: width / 2,
              height: width / 25,
              baseColor: Colors.grey.withOpacity(0.5),
              highlightColor: Colors.grey.withOpacity(0.2),
            )
          ],
        ),
        Row(
          children: [
            FadeShimmer.round(
              size: width / 7.5,
              baseColor: Colors.grey.withOpacity(0.5),
              highlightColor: Colors.grey.withOpacity(0.2),
            ),
            SizedBox(
              width: width / 30,
            ),
            FadeShimmer(
              radius: width,
              width: width / 2,
              height: width / 25,
              baseColor: Colors.grey.withOpacity(0.5),
              highlightColor: Colors.grey.withOpacity(0.2),
            )
          ],
        ),
        Row(
          children: [
            FadeShimmer.round(
              size: width / 7.5,
              baseColor: Colors.grey.withOpacity(0.5),
              highlightColor: Colors.grey.withOpacity(0.2),
            ),
            SizedBox(
              width: width / 30,
            ),
            FadeShimmer(
              radius: width,
              width: width / 2,
              height: width / 25,
              baseColor: Colors.grey.withOpacity(0.5),
              highlightColor: Colors.grey.withOpacity(0.2),
            )
          ],
        ),
      ],
    );
  }
}
