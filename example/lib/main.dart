// ignore_for_file: must_be_immutable

import 'package:apptex_chat/apptex_chat.dart';
import 'package:example/custom_button_square.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
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
  String myUUID = "xxx1";
  String otherUser = "xxx2";

  StartChat({Key? key}) : super(key: key) {
    AppTexChat.initializeUser(FullName: "Jamshed Khan", your_uuid: myUUID);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "A :     My User UID    : " + myUUID,
          ),
          Text(
            "B : Other User UID    : " + otherUser,
          ),
          const SizedBox(height: 29),
          Center(
            child: CustomButtonSquare(
              onTap: () {
                //this required two uuids..
                //current User uuid, and where you want to chat with.

                AppTexChat.startChat(context,
                    receiver_name: "Sayed idrees",
                    receiver_id: otherUser,
                    receiver_profileUrl:
                        "https://www.emmys.com/sites/default/files/styles/bio_pics_detail/public/bios/alexandra-daddario-2022-noms-450x600.jpg?itok=pACDocwq");
              },
              buttonColor: Colors.green,
              buttonName: 'Initiate Chat between User A and B',
              width: size.width * 0.8,
            ),
          ),
          const SizedBox(height: 29),
          Center(
            child: CustomButtonSquare(
              onTap: () {
                //This will trasnfer you to the Chats
                AppTexChat.openChats(context);
              },
              buttonColor: Colors.green,
              buttonName: 'Open all of my Chats',
              width: size.width * 0.8,
            ),
          )
        ],
      ),
    );
  }
}
