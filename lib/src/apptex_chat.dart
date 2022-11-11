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
import 'package:permission_handler/permission_handler.dart';

class AppTexChat {
  AppTexChat._();
  static final AppTexChat _instance = AppTexChat._();
  static AppTexChat get instance => _instance;

  static String? _uuid;
  static bool _isInited = false;
  static String? _name;
  static String? _profileURl;
  static MessagesController? _controler;
  static bool _isStarted = false;
  static bool _isVoicePermissionAccepted = false;

  static Future<void> init({Color? primaryColor, Color? secondaryColor}) async {
    _isInited = true;
    if (primaryColor != null) kprimary1 = primaryColor;
    if (secondaryColor != null) kprimary5 = secondaryColor;
  }

  requestPermission() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status.isDenied) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> Login_My_User(
      {required String FullName,
      required String your_uuid,
      String profileUrl = ""}) async {
    if (!_isInited) {
      // ignore: avoid_print
      print(
          "ErrorCode XID_051: Please Call 'ApptexChat.instance.Init()' in the main() function above runApp().");
      return;
    }
    bool permissionStatus = await requestPermission();
    if (!permissionStatus) {
      print("-- Permission Denied");
      _isVoicePermissionAccepted = false;
    } else {
      print("-- Permission Accepted");
      _isVoicePermissionAccepted = true;
    }

    if (!_isStarted) {
      await Firebase.initializeApp();
      _isStarted = true;
    }

    _uuid = your_uuid;
    _name = FullName;
    _profileURl = profileUrl;
    _controler = MessagesController(your_uuid);
    _controler!.bindAllChats(your_uuid);
  }

  //Chats
  UserChats() {
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

    return MyChats(_controler!);
  }

  OpenMessages(BuildContext context) {
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

  Widget GetMyMessages(BuildContext context) {
    if (!_isInited) {
      // ignore: avoid_print
      String error =
          "ErrorCode XID_051: Please Call 'Init()' in the main() function above runApp().";

      print(error);
      return Text(
        error,
        style: myStyle(12, false, color: Colors.red),
      );
    }
    if (_uuid == null) {
      // ignore: avoid_print

      String error =
          "ErrorCode XID_044: Please call 'Login_My_User' in the time of signing-in.'";
      print(error);
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(error),
      );
    }

    return MyChats(_controler!);
  }

  Start_Chat_With(BuildContext context,
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

      ChatController controller =
          ChatController(chatRoomID, _isVoicePermissionAccepted);
      controller.startChat(context, model, _uuid!);
    } else {
      ChatModel model = ChatModel.fromMap(ss);
      ChatController controller =
          ChatController(chatRoomID, _isVoicePermissionAccepted);

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

  String _getGenericuuid(String userBUuid) {
    String chatRoomID = "";
    if (_uuid!.compareTo(userBUuid) == 1) {
      chatRoomID = _uuid! + "" + userBUuid;
    } else {
      chatRoomID = userBUuid + "" + _uuid!;
    }
    return chatRoomID;
  }
}
