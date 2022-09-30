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
  static bool _isInited = false;
  static String? _name;
  static String? _profileURl;
  static MessagesController? _controler;
  static bool _started = false;
  static Login_My_User(
      {required String FullName,
      required String your_uuid,
      String profileUrl = ""}) async {
    if (!_isInited) {
      // ignore: avoid_print
      print(
          "ErrorCode XID_051: Please Call 'Init()' in the main() function above runApp().");
      return;
    }

    if (!_started) {
      await Firebase.initializeApp();

      _uuid ??= your_uuid;
      _name ??= FullName;
      _profileURl ??= profileUrl;
      _started = true;
      _controler = MessagesController(your_uuid);
      _controler!.bindAllChats();
    }
  }

  static OpenMessages(BuildContext context) {
    if (!_isInited) {
      // ignore: avoid_print
      print(
          "ErrorCode XID_051: Please Call 'Init()' in the main() function above runApp().");
      return;
    }
    if (_uuid == null) {
      // ignore: avoid_print
      print(
          "ErrorCode XID_044: Please call 'Login_My_User' in the time of signing-in.'");
      return;
    }

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyChats(_controler!)));
  }

  static init({Color? primary}) {
    _isInited = true;
    if (primary != null) kprimary1 = primary;
  }

  static Start_Chat_With(BuildContext context,
      {required String receiver_name,
      required String receiver_id,
      String receiver_profileUrl = ""}) async {
    if (!_isInited) {
      // ignore: avoid_print
      print(
          "ErrorCode XID_051: Please Call 'Init()' in the main() function above runApp().");
      return;
    }
    if (_uuid == null) {
      // ignore: avoid_print
      print(
          "ErrorCode XID_044: Please call 'Login_My_User' in the time of signing-in.'");
      return;
    }
    String chatRoomID = _getGenericuuid(receiver_id);

    DocumentSnapshot ss = await firebaseFirestore
        .collection(roomCollection)
        .doc(chatRoomID)
        .get();

    if (!ss.exists) {
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
      model.lastMessage = null;
      firebaseFirestore
          .collection(roomCollection)
          .doc(chatRoomID)
          .set(model.toMap());

      ChatController controller = ChatController(chatRoomID);
      controller.startChat(context, model, _uuid!);
    } else {
      ChatModel model = ChatModel.fromMap(ss);
      ChatController controller = ChatController(chatRoomID);

      model.users.clear();

      model.users
          .add(UserModel(uid: _uuid!, name: _name!, profileUrl: _profileURl!));
      model.users.add(UserModel(
          uid: receiver_id,
          name: receiver_name,
          profileUrl: receiver_profileUrl));

      controller.startChat(context, model, _uuid!);

      firebaseFirestore
          .collection(roomCollection)
          .doc(chatRoomID)
          .update(model.toMap());
    }
  }

  static String _getGenericuuid(String userBUuid) {
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
