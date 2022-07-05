// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_typing_uninitialized_variables, deprecated_member_use, depend_on_referenced_packages, avoid_print

import 'dart:io';
import 'dart:async';
import 'package:chat_app/color.dart';
import 'package:chat_app/service/api_service.dart';
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  final data;
  EditProfile({required this.data});
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController bio = TextEditingController();
  bool isLoading = false;
  bool hidden = true;
  File _image = File("");
  File? path;
  final picker = ImagePicker();
  Future<void> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        path = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future updateProfile(File imgFile) async {
    setState(() {
      isLoading = true;
    });

    final req = http.MultipartRequest("PUT", Uri.parse("$baseUrl/user/update"));
    req.fields["email"] = email.text;
    req.fields["name"] = name.text;
    if (password.text.isNotEmpty) {
      req.fields["password"] = password.text;
    }
    req.fields["bio"] = bio.text;
    req.headers["Authorization"] = "Bearer ${storage.read("token")}";
    if (_image.path.isNotEmpty) {
      var stream = http.ByteStream(DelegatingStream.typed(imgFile.openRead()));
      var length = await imgFile.length();
      var multipartFile = http.MultipartFile("photo_profile", stream, length,
          filename: basename(imgFile.path));
      req.files.add(multipartFile);
    }
    await req.send().then((value) async {
      http.Response.fromStream(value).then((res) {
        if (res.statusCode == 200) {
          setState(() {
            isLoading = false;
          });
          Get.back();
          return true;
        } else {
          setState(() {
            isLoading = false;
          });
          print(res.body);
          return false;
        }
      });
    });
  }

  @override
  void initState() {
    email.text = widget.data.email;
    name.text = widget.data.name;
    widget.data.bio != null ? bio.text = widget.data.bio : bio.text;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                      SizedBox(height: width / 10),
                      Center(
                          child: InkWell(
                        onTap: () => getImage(),
                        child: path == null
                            ? CircleAvatar(
                                backgroundColor: grayInput,
                                minRadius: width / 6,
                                maxRadius: width / 6,
                                child: Icon(
                                  Iconsax.camera5,
                                  color: Colors.white,
                                  size: width / 7,
                                ))
                            : CircleAvatar(
                                backgroundColor: grayInput,
                                minRadius: width / 6,
                                maxRadius: width / 6,
                                backgroundImage: FileImage(path!),
                                child: Icon(
                                  Iconsax.camera5,
                                  color: Colors.white.withOpacity(0.8),
                                  size: width / 7,
                                ),
                              ),
                      )),
                      SizedBox(
                        height: width / 10,
                      ),
                      _form(width)
                    ],
                  )))),
    );
  }

  Widget _form(width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        SizedBox(height: width / 18),
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
        SizedBox(height: width / 18),
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
        SizedBox(height: width / 18),
        TextField(
          maxLines: null,
          controller: bio,
          decoration: InputDecoration(
            label: Text("Bio"),
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
        Container(
          margin: EdgeInsets.only(top: width / 20),
          width: width,
          child: ElevatedButton(
            onPressed: email.text.isEmpty || name.text.isEmpty
                ? null
                : () {
                    updateProfile(_image);
                  },
            style: ElevatedButton.styleFrom(
                primary: greenTheme,
                padding: EdgeInsets.symmetric(vertical: width / 60),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(width / 45))),
            child: isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : Text(
                    "Save",
                    style: TextStyle(
                        fontSize: width / 22, fontFamily: "popinsemi"),
                  ),
          ),
        ),
      ],
    );
  }
}
