// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  String title;
  CustomTitle({required this.title});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Text(
      title,
      style: TextStyle(fontFamily: "popinsemi", fontSize: width / 17),
    );
  }
}
