// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace

import 'dart:convert';

import 'package:chat_app/color.dart';
import 'package:chat_app/screen/auth/verification.dart';
import 'package:chat_app/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool isLoading = false;
  TextEditingController email = TextEditingController();
  Future forgotPassword() async {
    Uri url = Uri.parse("$baseUrl/user/forgot-password");
    final res = await http.post(url,
        body: jsonEncode({"email": email.text}), headers: headers);
    if (res.statusCode == 200) {
      Get.to(
          Verification(
            where: "forgot",
          ),
          arguments: [jsonDecode(res.body)["token"], email.text],
          transition: Transition.rightToLeft);
    } else {
      Get.snackbar("Error", jsonDecode(res.body)["message"],
          backgroundColor: Colors.red.withOpacity(0.5));
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
                  "assets/img/forgot.png",
                  height: width / 1.3,
                ),
              ),
              SizedBox(
                height: width / 20,
              ),
              Text(
                "Forgot Password?",
                style: TextStyle(fontSize: width / 17, fontFamily: "popinsemi"),
              ),
              Text(
                "Don't worry! We will help you to recover your password",
                style: TextStyle(fontSize: width / 30, color: grayText),
              ),
              SizedBox(
                height: width / 20,
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
              Container(
                margin: EdgeInsets.only(top: width / 20),
                width: width,
                child: ElevatedButton(
                  onPressed: () {
                    forgotPassword();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: greenTheme,
                      padding: EdgeInsets.symmetric(vertical: width / 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(width / 45))),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Submit",
                          style: TextStyle(
                              fontSize: width / 22, fontFamily: "popinsemi"),
                        ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
