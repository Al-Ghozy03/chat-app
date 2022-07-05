// // ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_import, curly_braces_in_flow_control_structures

// import 'package:chat_app/api_service.dart';
// import 'package:chat_app/color.dart';
// import 'package:chat_app/model/api/asking_friend_model.dart';
// import 'package:chat_app/widget/custom_title.dart';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';

// class NotificationPage extends StatefulWidget {
//   const NotificationPage({super.key});

//   @override
//   State<NotificationPage> createState() => _NotificationPageState();
// }

// class _NotificationPageState extends State<NotificationPage> {
//   late Future askingFriend;
//   @override
//   void initState() {
//     askingFriend = ApiService().askingFriend();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: SafeArea(
//           child: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(width / 25),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CustomTitle(title: "Notifications"),
//               SizedBox(
//                 height: width / 17,
//               ),
//               FutureBuilder(
//                 builder: (context, AsyncSnapshot snapshot) {
//                   if (snapshot.connectionState != ConnectionState.done)
//                     return Text("loading");
//                   if (snapshot.hasError) return Text("error");
//                   if (snapshot.hasData) return _listNotif(width, snapshot.data);
//                   return Text("kosong");
//                 },
//                 future: askingFriend,
//               )
//             ],
//           ),
//         ),
//       )),
//     );
//   }

//   Widget _listNotif(width, AskingFriend data) {
//     return Column(
//       children: data.data
//           .map((data) => Column(
//                 children: [
//                   Row(
//                     children: [
//                       data.user[0].photoProfile == null
//                           ? CircleAvatar(
//                               minRadius: width / 18,
//                               maxRadius: width / 18,
//                               backgroundColor: grayInput,
//                               child: Icon(
//                                 Iconsax.user,
//                                 size: width / 20,
//                                 color: grayText,
//                               ),
//                             )
//                           : CircleAvatar(
//                               minRadius: width / 18,
//                               maxRadius: width / 18,
//                               backgroundColor: grayInput,
//                               backgroundImage: NetworkImage(data.user[0].photoProfile),
//                             ),
//                       SizedBox(
//                         width: width / 25,
//                       ),
//                       Flexible(
//                         child: RichText(
//                             text: TextSpan(
//                                 style: TextStyle(
//                                     fontFamily: "popin",
//                                     color: Colors.black,
//                                     fontSize: width / 26),
//                                 children: [
//                               TextSpan(
//                                 text: data.user[0].name,
//                                 style: TextStyle(fontFamily: "popinsemi"),
//                               ),
//                               TextSpan(text: " sent you asking friend"),
//                             ])),
//                       )
//                     ],
//                   ),
//                   Container(
//                     margin: EdgeInsets.symmetric(horizontal: width / 7),
//                     child: Row(
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {},
//                           style: ElevatedButton.styleFrom(
//                               primary: greenTheme,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius:
//                                       BorderRadius.circular(width / 50)),
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: width / 25,
//                                   vertical: width / 80)),
//                           child: Text(
//                             "Confirm",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontFamily: "popinmedium",
//                                 fontSize: width / 29),
//                           ),
//                         ),
//                         SizedBox(
//                           width: width / 30,
//                         ),
//                         TextButton(
//                           onPressed: () {},
//                           child: Text(
//                             "Delete",
//                             style: TextStyle(
//                                 color: grayText,
//                                 fontFamily: "popinmedium",
//                                 fontSize: width / 29),
//                           ),
//                         )
//                       ],
//                     ),
//                   )
//                 ],
//               ))
//           .toList(),
//     );
//   }
// }
