// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unused_import, unused_local_variable
import 'dart:convert';
import 'package:chat_app/widget/bottom_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/color.dart';
import 'package:chat_app/screen/auth/forgot_password.dart';
import 'package:chat_app/screen/auth/register.dart';
import 'package:chat_app/screen/auth/verification.dart';
import 'package:chat_app/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool hidden = true;
  bool isLoading = false;
  bool resendLoading = false;
  String error = "";
  final storage = GetStorage();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future login() async {
    setState(() {
      isLoading = true;
    });
    Uri url = Uri.parse("$baseUrl/user/login");
    final res = await http.post(url,
        body: jsonEncode({"email": email.text, "password": password.text}),
        headers: headers);
    setState(() {
      if (res.statusCode == 200) {
        isLoading = false;
        var token = jsonDecode(res.body)["token"];
        storage.write("token", token);
        Get.off(BottomNavigation(), transition: Transition.rightToLeft);
      } else if (res.statusCode == 401) {
        isLoading = false;
        Dialogs.materialDialog(
            context: context,
            lottieBuilder: LottieBuilder.asset(
              "assets/json/lf20_sv76lawj.json",
              fit: BoxFit.contain,
            ),
            title: "Error",
            titleStyle: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 20,
                fontFamily: "popinsemi"),
            msg: "Your email hasn't been verified",
            msgStyle: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 30,
                fontFamily: "popin"),
            actions: [
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: grayText),
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width / 70)),
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.width / 80)),
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 25,
                        fontFamily: "popinmedium",
                        color: grayText),
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: greenTheme,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width / 70)),
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.width / 80)),
                  onPressed: () {
                    resendEmail(jsonDecode(res.body)["token"]);
                  },
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          "Verify email",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 25,
                              fontFamily: "popinmedium"),
                        )),
            ]);
      } else {
        isLoading = false;
        error = jsonDecode(res.body)["message"];
      }
    });
  }

  Future resendEmail(token) async {
    setState(() {
      resendLoading = true;
    });
    Uri url = Uri.parse("$baseUrl/user/resend-email");
    final res = await http.post(url,
        body: jsonEncode({"email": email.text}), headers: headers);
    setState(() {
      if (res.statusCode == 200) {
        resendLoading = false;
        Get.to(
            Verification(
              where: "login",
            ),
            transition: Transition.rightToLeft,
            arguments: [token, email.text]);
      } else {
        resendLoading = false;
        Get.snackbar("Error", jsonDecode(res.body)["message"]);
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
              SizedBox(
                height: width / 20,
              ),
              Center(
                child: Image.asset(
                  "assets/img/login.png",
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
                error == "user's not found" ? error : "",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: width / 35,
                    fontStyle: FontStyle.italic),
              ),
              SizedBox(
                height: width / 17,
              ),
              TextField(
                controller: password,
                obscureText: hidden,
                decoration: InputDecoration(
                  label: Text("Password"),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidden = !hidden;
                      });
                    },
                    icon: Icon(
                      hidden ? Iconsax.eye : Iconsax.eye_slash,
                      color: hidden ? grayText : greenTheme,
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
              Text(
                error == "password's wrong" ? error : "",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: width / 35,
                    fontStyle: FontStyle.italic),
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      onPressed: () {
                        Get.to(ForgotPassword(),
                            transition: Transition.rightToLeft);
                      },
                      child: Text(
                        "Forgot password",
                        style: TextStyle(
                            color: Color.fromARGB(255, 76, 76, 76),
                            fontSize: width / 30),
                      ))),
              Container(
                width: width,
                child: ElevatedButton(
                  onPressed: email.text.isEmpty || password.text.isEmpty
                      ? null
                      : () {
                          login();
                        },
                  style: ElevatedButton.styleFrom(
                      primary: greenTheme,
                      padding: EdgeInsets.symmetric(vertical: width / 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(width / 45))),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Sign in",
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
                      Get.to(Register(), transition: Transition.rightToLeft);
                    },
                    child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                                fontFamily: "popin",
                                color: Colors.black,
                                fontSize: width / 36),
                            children: [
                          TextSpan(text: "Don't have an Account? "),
                          TextSpan(
                              text: "Sign up",
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
