// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, unused_element

import 'package:chat_app/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffF9F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Iconsax.arrow_left,
            color: Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
        toolbarHeight: width / 5,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.vertical(bottom: Radius.circular(width / 30))),
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  minRadius: width / 15,
                  maxRadius: width / 15,
                  backgroundColor: grayInput,
                  child: Icon(
                    Iconsax.user,
                    color: grayText,
                    size: width / 16,
                  ),
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
            SizedBox(
              width: width / 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Jane",
                  style: TextStyle(
                      fontFamily: "popinsemi",
                      fontSize: width / 24,
                      color: Colors.black),
                ),
                Text(
                  "Online",
                  style: TextStyle(color: grayText, fontSize: width / 35),
                )
              ],
            )
          ],
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(width / 25),
        child: Column(
          children: [
            Expanded(
                child: Container(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                itemBuilder: (context, i) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: _receiveMessage(width),
                  );
                },
                itemCount: 20,
              ),
            )),
            _sendArea(width)
          ],
        ),
      )),
    );
  }

  Widget _receiveMessage(width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: width / 60),
          padding: EdgeInsets.all(width / 25),
          decoration: BoxDecoration(
              color: Color(0xffF2F2F2),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(width / 20),
                  bottomLeft: Radius.circular(width / 20),
                  bottomRight: Radius.circular(width / 20))),
          child: Text(
            "hloo",
            style: TextStyle(
              fontSize: width / 26,
            ),
          ),
        ),
        Text("20.30")
      ],
    );
  }

  Widget _messageFromMe(width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: width / 60),
          padding: EdgeInsets.all(width / 25),
          decoration: BoxDecoration(
              color: greenTheme,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(width / 20),
                  bottomLeft: Radius.circular(width / 20),
                  bottomRight: Radius.circular(width / 20))),
          child: Text(
            "hloo",
            style: TextStyle(fontSize: width / 26, color: Colors.white),
          ),
        ),
        Text("20.30")
      ],
    );
  }

  Widget _sendArea(width) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(0, 10))
            ]),
            child: Stack(
              alignment: Alignment.center,
              children: [
                TextField(
                  maxLines: null,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Type here...',
                    contentPadding: EdgeInsets.only(
                        left: width / 50,
                        top: width / 30,
                        bottom: width / 30,
                        right: width / 8),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(width / 20)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          primary: greenTheme,
                          padding: EdgeInsets.all(width / 35),
                          shape: CircleBorder()),
                      child: Icon(Iconsax.send_1)),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
