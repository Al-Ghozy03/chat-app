// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors
import 'dart:async';

import 'package:chat_app/service/api_service.dart';
import 'package:chat_app/color.dart';
import 'package:chat_app/model/api/asking_friend.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';

class Asking extends StatefulWidget {
  const Asking({super.key});

  @override
  State<Asking> createState() => _AskingState();
}

class _AskingState extends State<Asking> {
  late Future asking;
  int limit = 10;
  int page = 1;
  bool hasLoading = false;
  Future askingFriend() async {
    headers["Authorization"] = "Bearer ${storage.read("token")}";
    final res = await http.get(
        Uri.parse("$baseUrl/friend/asking-friend?limit=$limit&page=$page"),
        headers: headers);
    if (res.statusCode == 200) {
      setState(() {
        hasLoading = true;
      });
      return askingFriendFromJson(res.body);
    } else {
      return false;
    }
  }

  FutureOr refetch() {
    setState(() {
      limit = limit + 1;
    });
    asking = askingFriend();
  }

  @override
  void initState() {
    asking = askingFriend();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return FutureBuilder(
      builder: (context, AsyncSnapshot snapshot) {
        if (!hasLoading) {
          if (snapshot.connectionState != ConnectionState.done)
            return _loading(width);
        }
        if (snapshot.hasError) return Text("error");
        if (snapshot.hasData) return _builder(width, snapshot.data);
        return Text("kosong");
      },
      future: asking,
    );
  }

  Widget _builder(width, AskingFriend data) {
    return Column(
      children: [
        StaggeredGrid.count(
          crossAxisCount: 1,
          mainAxisSpacing: width / 20,
          children: data.data
              .map((data) => InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            data.user[0].photoProfile == null
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
                                        NetworkImage(data.user[0].photoProfile),
                                  ),
                            SizedBox(
                              width: width / 30,
                            ),
                            Text(
                              data.user[0].name,
                              style: TextStyle(
                                  fontFamily: "popinsemi",
                                  fontSize: width / 24),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                ApiService()
                                    .acceptFriend(data.user[0].id)
                                    .then((value) {
                                  setState(() {
                                    asking = askingFriend();
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
                      ],
                    ),
                  ))
              .toList(),
        ),
        Center(
          child: TextButton(
              onPressed: () {
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
