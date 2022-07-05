// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, avoid_print, curly_braces_in_flow_control_structures

import 'package:chat_app/color.dart';
import 'package:chat_app/model/api/online_user.dart';
import 'package:chat_app/screen/chat.dart';
import 'package:chat_app/service/api_service.dart';
import 'package:chat_app/widget/custom_title.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jwt_decode/jwt_decode.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future userOnline;
  @override
  void initState() {
    userOnline = ApiService().userOnline();
    socket.emit("online", Jwt.parseJwt(storage.read("token"))["id"]);
    ApiService().connectSocket();
    super.initState();
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
              _header(width),
              SizedBox(
                height: width / 20,
              ),
              Text(
                "Online",
                style:
                    TextStyle(fontFamily: "popinmedium", fontSize: width / 20),
              ),
              SizedBox(
                height: width / 25,
              ),
              FutureBuilder(
                future: userOnline,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState != ConnectionState.done)
                    return Container(
                      height: width / 5,
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, i) {
                          return _loadingUserOnline(width);
                        },
                        itemCount: 10,
                        separatorBuilder: (_, i) => SizedBox(
                          width: width / 20,
                        ),
                      ),
                    );
                  if (snapshot.hasError) return Text("error");
                  if (snapshot.hasData)
                    return _onlineUser(width, snapshot.data);
                  return Text("empty");
                },
              ),
              Divider(
                thickness: 1.5,
                color: Color(0xffE1E1E1),
              ),
              SizedBox(
                height: width / 20,
              ),
              _listUserChat(width),
            ],
          ),
        ),
      )),
    );
  }

  Widget _listUserChat(width) {
    return InkWell(
      onTap: () => Get.to(Chat(), transition: Transition.rightToLeft),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                minRadius: width / 17,
                maxRadius: width / 17,
              ),
              SizedBox(
                width: width / 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Jane",
                    style: TextStyle(
                        fontFamily: "popinsemi", fontSize: width / 24),
                  ),
                  Text(
                    "Oke mas",
                    style: TextStyle(color: grayText, fontSize: width / 35),
                  )
                ],
              )
            ],
          ),
          Column(
            children: [
              Text(
                "12.30",
                style: TextStyle(fontSize: width / 35, color: grayText),
              ),
              CircleAvatar(
                minRadius: width / 60,
                maxRadius: width / 60,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _onlineUser(width, OnlineUser data) {
    return Container(
      height: width / 5,
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return Column(
            children: [
              Stack(
                children: [
                  data.data[i].photoProfile == null
                      ? CircleAvatar(
                          minRadius: width / 15,
                          maxRadius: width / 15,
                          backgroundColor: grayInput,
                          child: Icon(
                            Iconsax.user,
                            color: grayText,
                            size: width / 16,
                          ),
                        )
                      : CircleAvatar(
                          minRadius: width / 15,
                          maxRadius: width / 15,
                          backgroundColor: grayInput,
                          backgroundImage:
                              NetworkImage(data.data[i].photoProfile),
                        ),
                  Positioned(
                    left: width / 11.9,
                    top: width / 12,
                    child: Container(
                      height: width / 20,
                      width: width / 20,
                      decoration: BoxDecoration(
                          color: greenOnline,
                          borderRadius: BorderRadius.circular(width),
                          border: Border.all(color: Colors.white, width: 3)),
                    ),
                  )
                ],
              ),
              Text(
                data.data[i].name.length >= 6
                    ? "${data.data[i].name.substring(0, 6)}...."
                    : data.data[i].name,
                style: TextStyle(fontSize: width / 25),
              )
            ],
          );
        },
        itemCount: data.data.length,
        separatorBuilder: (context, index) => SizedBox(
          width: width / 20,
        ),
      ),
    );
  }

  Widget _loadingUserOnline(width) {
    return Column(
      children: [
        FadeShimmer.round(
          size: width / 7.5,
          baseColor: Colors.grey.withOpacity(0.5),
          highlightColor: Colors.grey.withOpacity(0.2),
        ),
        SizedBox(
          height: width / 60,
        ),
        FadeShimmer(
          radius: width,
          width: width / 8,
          height: width / 40,
          baseColor: Colors.grey.withOpacity(0.5),
          highlightColor: Colors.grey.withOpacity(0.2),
        )
      ],
    );
  }

  Widget _header(width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomTitle(
          title: "Message",
        ),
        CircleAvatar(
          minRadius: width / 16,
          maxRadius: width / 16,
          backgroundColor: grayInput,
          child: Icon(
            Iconsax.user,
            color: grayText,
            size: width / 20,
          ),
        )
      ],
    );
  }
}
