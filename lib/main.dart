// ignore_for_file: prefer_const_constructors, unused_import, prefer_typing_uninitialized_variables, avoid_print

import 'dart:developer';

import 'package:chat_app/color.dart';
import 'package:chat_app/service/api_service.dart';
import 'package:chat_app/widget/bottom_navigation.dart';
import 'package:chat_app/screen/auth/login.dart';
import 'package:chat_app/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final storage = GetStorage();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      socket.emit("online", Jwt.parseJwt(storage.read("token"))["id"]);
    }
    if (state == AppLifecycleState.paused) {
      socket.emit("offline", Jwt.parseJwt(storage.read("token"))["id"]);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          fontFamily: "popin",
          colorScheme: ThemeData().colorScheme.copyWith(primary: greenTheme)),
      debugShowCheckedModeBanner: false,
      title: "Chat app",
      home: storage.read("token") == null ? Login() : BottomNavigation(),
    );
  }
}
