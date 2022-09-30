// ignore_for_file: non_constant_identifier_names

import 'package:apptex_chat/src/Controllers/chat_conrtroller.dart';
import 'package:apptex_chat/src/Controllers/contants.dart';
import 'package:apptex_chat/src/Controllers/messages_controller.dart';
import 'package:apptex_chat/src/Models/ChatModel.dart';
import 'package:apptex_chat/src/Models/UserModel.dart';
import 'package:apptex_chat/src/Screens/my_chats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AppTexChat {
  static String? _uuid;
  static String? _name;
  static String? _profileURl;
  static MessagesController? controler;
  static bool started = false;
  static initializeUser(
      {required String FullName,
      required String your_uuid,
      String profileUrl = ""}) async {
    if (!started) {
      await Firebase.initializeApp();

      _uuid ??= your_uuid;
      _name ??= FullName;
      _profileURl ??= profileUrl;
      started = true;
      controler = MessagesController(your_uuid);
      controler!.bindAllChats();
    }
  }

  static openChats(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyChats(controler!)));
  }

  static startChat(BuildContext context,
      {required String receiver_name,
      required String receiver_id,
      String receiver_profileUrl = ""}) {
    if (_uuid == null) {
      // ignore: avoid_print
      print(
          "ErrorCode XID_044: Please Call Initialize function before calling Start chat");
      return;
    }
    String chatRoomID = getGenericuuid(receiver_id);

    ChatModel model = ChatModel(
        uid: chatRoomID,
        createdAt: Timestamp.now(),
        lastMessage: "",
        lastMessageSendBy: "",
        unReadCount: 0,
        ReadByOther: false,
        uuids: [_uuid!, receiver_id],
        typers: [],
        lastMessageTimeStamp: Timestamp.now(),
        users: [
          UserModel(uid: _uuid!, name: _name!, profileUrl: _profileURl!),
          UserModel(
              uid: receiver_id,
              name: receiver_name,
              profileUrl: receiver_profileUrl)
        ]);

    firebaseFirestore
        .collection(roomCollection)
        .doc(chatRoomID)
        .set(model.toMap());

    ChatController controller = ChatController(chatRoomID);
    controller.startChat(context, model, _uuid!);
  }

  static String getGenericuuid(String userBUuid) {
    String chatRoomID = "";
    if (_uuid!.compareTo(userBUuid) == 1) {
      chatRoomID = _uuid! + "" + userBUuid;
    } else {
      chatRoomID = userBUuid + "" + _uuid!;
    }
    return chatRoomID;
  }
}

class ChatHome extends StatelessWidget {
  const ChatHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
