// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, curly_braces_in_flow_control_structures

import 'dart:convert';

import 'package:chat_app/color.dart';
import 'package:chat_app/service/api_service.dart';
import 'package:chat_app/widget/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool hiddenNewPassword = true;
  bool hiddenConfirmNewPassword = true;
  bool isLoading = false;
  final argument = Get.arguments;
  TextEditingController newPassword = TextEditingController();
  TextEditingController newConfirmPassword = TextEditingController();

  Future resetPassword() async {
    Uri url = Uri.parse("$baseUrl/user/reset-password");
    if (newPassword.text != newConfirmPassword.text)
      return Get.snackbar("Error", "Password and new password is not same",
          backgroundColor: Colors.red.withOpacity(0.5));
    final res = await http.put(url,
        body: jsonEncode({"password": newPassword.text, "email": argument[1]}),headers: headers);
    if (res.statusCode == 200) {
      Get.offAll(BottomNavigation(), transition: Transition.rightToLeft);
      storage.write("token", argument[0]);
    } else {
      Get.snackbar("Error", jsonDecode(res.body)["message"]);
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
                  "assets/img/reset.png",
                  height: width / 1.3,
                ),
              ),
              SizedBox(
                height: width / 20,
              ),
              Text(
                "Reset Password?",
                style: TextStyle(fontSize: width / 17, fontFamily: "popinsemi"),
              ),
              SizedBox(
                height: width / 30,
              ),
              TextField(
                controller: newPassword,
                obscureText: hiddenNewPassword,
                decoration: InputDecoration(
                  label: Text("New password"),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hiddenNewPassword = !hiddenNewPassword;
                      });
                    },
                    icon: Icon(
                      hiddenNewPassword ? Iconsax.eye : Iconsax.eye_slash,
                      color: hiddenNewPassword ? grayText : greenTheme,
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
                height: width / 30,
              ),
              TextField(
                controller: newConfirmPassword,
                obscureText: hiddenConfirmNewPassword,
                decoration: InputDecoration(
                  label: Text("Confirm new password"),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hiddenConfirmNewPassword = !hiddenConfirmNewPassword;
                      });
                    },
                    icon: Icon(
                      hiddenConfirmNewPassword
                          ? Iconsax.eye
                          : Iconsax.eye_slash,
                      color: hiddenConfirmNewPassword ? grayText : greenTheme,
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
              Container(
                margin: EdgeInsets.only(top: width / 25),
                width: width,
                child: ElevatedButton(
                  onPressed: () {
                    resetPassword();
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
