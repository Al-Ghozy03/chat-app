// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures
import 'dart:async';
import 'package:chat_app/color.dart';
import 'package:chat_app/model/api/friend_model.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jwt_decode/jwt_decode.dart';

class MyFriend extends StatefulWidget {
  const MyFriend({super.key});

  @override
  State<MyFriend> createState() => _MyFriendState();
}

class _MyFriendState extends State<MyFriend> {
  late Future myFriend;
  bool hasLoading = false;
  String userId = Jwt.parseJwt(storage.read("token"))["id"];
  int limit = 3;
  int page = 1;
  ScrollController scrollController = ScrollController();
  bool isLoading = false;
  List friendList = [];
  FutureOr refetch() {
    myFriend = friend();
    myFriend.then((value) {
      value.data.map((e) {
        setState(() {
          friendList.add(e);
        });
      }).toList();
    });
  }

  Future friend() async {
    setState(() {
      isLoading = true;
    });
    Uri url = Uri.parse("$baseUrl/friend?id=$userId&limit=$limit&page=$page");
    headers["Authorization"] = "Bearer ${storage.read("token")} ";
    final res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      var data = friendFromJson(res.body);
      setState(() {
        isLoading = false;
        if (!hasLoading) {
          data.data.map((e) => friendList.add(e)).toList();
        }
        hasLoading = true;
      });
      return data;
    } else {
      setState(() {
        isLoading = false;
      });
      return false;
    }
  }

  @override
  void initState() {
    myFriend = friend();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      controller: scrollController,
      child: FutureBuilder(
        future: myFriend,
        builder: (context, AsyncSnapshot snapshot) {
          if (!hasLoading) {
            if (snapshot.connectionState != ConnectionState.done)
              return _loading(width);
          }
          if (snapshot.hasError) return Text("error");
          if (snapshot.hasData) return _builder(width, snapshot.data);
          return Text("kosong");
        },
      ),
    );
  }

  Widget _builder(width, Friend data) {
    return Column(
      children: [
        StaggeredGrid.count(
          crossAxisCount: 1,
          mainAxisSpacing: width / 20,
          children: friendList.map((data) {
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
                                  backgroundImage: NetworkImage(
                                      data.asker[0].photoProfile),
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
        SizedBox(
          height: width / 20,
        ),
        Center(
          child: TextButton(
              onPressed: () {
                page++;
                refetch();
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
