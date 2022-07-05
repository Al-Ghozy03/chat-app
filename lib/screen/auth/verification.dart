// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_print, must_be_immutable

import 'dart:convert';
import 'package:chat_app/color.dart';
import 'package:chat_app/screen/auth/reset_password.dart';
import 'package:chat_app/service/api_service.dart';
import 'package:chat_app/widget/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;

class Verification extends StatefulWidget {
  String where;
  Verification({super.key, required this.where});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  bool isLoading = false;
  var arguments = Get.arguments;
  bool resendLoading = false;

  Future verifyEmail(token) async {
    Uri url = Uri.parse("$baseUrl/user/verify-email/${arguments[1]}");
    final res = await http.post(url,
        body: jsonEncode({"token": token}), headers: headers);
    if (res.statusCode == 200) {
      storage.write("token", arguments[0]);
      Get.offAll(BottomNavigation(), transition: Transition.rightToLeft);
    } else {
      Get.snackbar("Error", jsonDecode(res.body)["message"],
          backgroundColor: Colors.red.withOpacity(0.6));
    }
  }

  Future verifyForgotPassword(token) async {
    Uri url = Uri.parse("$baseUrl/user/verify-forgot-password/${arguments[1]}");
    final res = await http.post(url,
        body: jsonEncode({"token": token}), headers: headers);
    if (res.statusCode == 200) {
      Get.to(ResetPassword(),
          transition: Transition.rightToLeft, arguments: arguments);
    } else {
      print("hehe");
      Get.snackbar("Error", jsonDecode(res.body)["message"],
          backgroundColor: Colors.red.withOpacity(0.6));
    }
  }

  void loadingDialog() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          final width = MediaQuery.of(context).size.width;
          return Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: width / 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: width / 40,
                  ),
                  Text('Loading...')
                ],
              ),
            ),
          );
        });
  }

  Future resendEmail() async {
    setState(() {
      resendLoading = true;
    });
    Uri url = Uri.parse("$baseUrl/user/resend-email");
    final res = await http.post(url,
        body: jsonEncode({"email": arguments[1]}), headers: headers);
    setState(() {
      if (res.statusCode == 200) {
        resendLoading = false;
        print("berhasil");
        Get.back();
      } else {
        resendLoading = false;
        Get.back();
        print(res.body);
      }
    });
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
                child: Text(
                  "Verification",
                  style:
                      TextStyle(fontFamily: "popinsemi", fontSize: width / 15),
                ),
              ),
              SizedBox(
                height: width / 30,
              ),
              Text(
                "We have sent the code to ${arguments[1]}. Enter the verification code",
                style: TextStyle(color: grayText, fontSize: width / 30),
              ),
              SizedBox(
                height: width / 14,
              ),
              Center(
                child: Pinput(
                  onCompleted: (value) {
                    if (widget.where == "forgot") {
                      verifyForgotPassword(value);
                    } else {
                      verifyEmail(value);
                    }
                  },
                  defaultPinTheme: PinTheme(
                      margin: EdgeInsets.symmetric(horizontal: width / 80),
                      height: width / 5.4,
                      width: width / 5.4,
                      textStyle: TextStyle(
                          fontSize: width / 18, fontFamily: "popinsemi"),
                      decoration: BoxDecoration(
                          border: Border.all(color: grayInput),
                          borderRadius: BorderRadius.circular(width / 30))),
                ),
              ),
              SizedBox(
                height: width / 25,
              ),
              Center(
                child: TextButton(
                    onPressed: () {
                      resendEmail();
                      if (resendLoading) {
                        loadingDialog();
                      }
                    },
                    child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                                fontFamily: "popin",
                                color: Colors.black,
                                fontSize: width / 36),
                            children: [
                          TextSpan(text: "Didn't receive email? "),
                          TextSpan(
                              text: "Resend",
                              style: TextStyle(color: Color(0xff509764))),
                        ]))),
              ),
              Container(
                margin: EdgeInsets.only(top: width / 40),
                width: width,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      primary: greenTheme,
                      padding: EdgeInsets.symmetric(vertical: width / 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(width / 45))),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Verify code",
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
