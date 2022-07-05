// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:chat_app/color.dart';
import 'package:chat_app/screen/friend/index.dart';
import 'package:chat_app/screen/home.dart';
import 'package:chat_app/screen/user/profile.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int selectedIndex = 0;
  void onTapItem(int i) {
    setState(() {
      selectedIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screen = [Home(), FriendPage(), ProfilePage()];
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle:
            TextStyle(fontFamily: "popinsemi", fontSize: width / 31),
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Iconsax.message5,
              size: width / 18,
            ),
            label: "Chats",
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Iconsax.profile_2user,
                size: width / 18,
              ),
              label: "Friends"),
          // BottomNavigationBarItem(
          //     icon: Icon(
          //       Iconsax.notification,
          //       size: width / 18,
          //     ),
          //     label: "Notifications"),
          BottomNavigationBarItem(
              icon: Icon(
                Iconsax.user,
                size: width / 18,
              ),
              label: "Account"),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: greenTheme,
        unselectedItemColor: Colors.grey,
        onTap: onTapItem,
      ),
      body: screen[selectedIndex],
    );
  }
}
