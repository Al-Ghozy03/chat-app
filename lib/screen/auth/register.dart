// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_print

import 'dart:convert';

import 'package:chat_app/color.dart';
import 'package:chat_app/screen/auth/verification.dart';
import 'package:chat_app/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isShow = true;
  bool isLoading = false;
  String error = "";
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();

  Future register() async {
    setState(() {
      isLoading = true;
    });
    Uri url = Uri.parse("$baseUrl/user/register");
    final res = await http.post(url,
        body: jsonEncode({
          "email": email.text,
          "name": name.text,
          "password": password.text
        }),
        headers: headers);
    if (res.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      var data = jsonDecode(res.body);
      Get.to(Verification(where: "register",),
          transition: Transition.rightToLeft,
          arguments: [data["token"], email.text]);
    } else {
      setState(() {
        isLoading = false;
        error = jsonDecode(res.body)["message"];
      });
      print(res.statusCode);
    }
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
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Iconsax.arrow_left)),
              Center(
                child: Image.asset(
                  "assets/img/register.png",
                  height: width / 1.3,
                ),
              ),
              SizedBox(
                height: width / 25,
              ),
              TextField(
                controller: email,
                decoration: InputDecoration(
                  label: Text("Email"),
                  labelStyle: TextStyle(fontSize: width / 25),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: width / 30, vertical: width / 25),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                      ),
                      borderRadius: BorderRadius.circular(width / 45)),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              Text(
                error == "email has been used" ? error : "",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: width / 35,
                    fontStyle: FontStyle.italic),
              ),
              SizedBox(
                height: width / 40,
              ),
              TextField(
                controller: name,
                decoration: InputDecoration(
                  label: Text("Name"),
                  labelStyle: TextStyle(fontSize: width / 25),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: width / 30, vertical: width / 25),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                      ),
                      borderRadius: BorderRadius.circular(width / 45)),
                ),
              ),
              SizedBox(
                height: width / 17,
              ),
              TextField(
                controller: password,
                obscureText: isShow,
                decoration: InputDecoration(
                  label: Text("Password"),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isShow = !isShow;
                      });
                    },
                    icon: Icon(
                      isShow ? Iconsax.eye : Iconsax.eye_slash,
                      color: isShow ? grayText : greenTheme,
                    ),
                  ),
                  labelStyle: TextStyle(fontSize: width / 25),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: width / 30, vertical: width / 25),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                      ),
                      borderRadius: BorderRadius.circular(width / 45)),
                ),
                keyboardType: TextInputType.visiblePassword,
              ),
              SizedBox(
                height: width / 17,
              ),
              Container(
                width: width,
                child: ElevatedButton(
                  onPressed: () {
                    if (email.text.isEmpty ||
                        name.text.isEmpty ||
                        password.text.isEmpty) {
                      return;
                    }
                    register();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: email.text.isEmpty ||
                              name.text.isEmpty ||
                              password.text.isEmpty
                          ? disableButton
                          : greenTheme,
                      padding: EdgeInsets.symmetric(vertical: width / 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(width / 45))),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Sign up",
                          style: TextStyle(
                              fontSize: width / 22, fontFamily: "popinsemi"),
                        ),
                ),
              ),
              SizedBox(
                height: width / 40,
              ),
              Center(
                child: TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                                fontFamily: "popin",
                                color: Colors.black,
                                fontSize: width / 36),
                            children: [
                          TextSpan(text: "Already have an account? "),
                          TextSpan(
                              text: "Sign in",
                              style: TextStyle(color: Color(0xff509764))),
                        ]))),
              )
            ],
          ),
        ),
      )),
    );
  }
}
