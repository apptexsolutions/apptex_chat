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
  StartChat() {
    AppTexChat.initializeUser(
        FullName: "Jamshed Khan", your_uuid: "JamshedUUID");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: CustomButtonSquare(
              OnTap: () {
                //this required two uuids..
                //current User uuid, and where you want to chat with.
                AppTexChat.startChat(context,
                    receiver_name: "Sayed idrees", receiver_id: "sayeduuid");
              },
              buttonColor: Colors.green,
              buttonName: 'Initiate Chat between User A and B',
              width: size.width * 0.8,
            ),
          )
        ],
      ),
    );
  }
}
