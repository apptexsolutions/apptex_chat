// ignore_for_file: must_be_immutable

import 'package:apptex_chat/apptex_chat.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AppTexChat.init();
  AppTexChat.Login_My_User(
      FullName: "Raza",
      your_uuid: "raza",
      profileUrl: "https://avatars.githubusercontent.com/u/63047096?v=4");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StartChat(),
    );
  }
}

class StartChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(body: AppTexChat.UserChats());
  }
}
