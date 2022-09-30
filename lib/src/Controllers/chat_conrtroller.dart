import 'dart:io';

import 'package:apptex_chat/src/Controllers/contants.dart';
import 'package:apptex_chat/src/Models/ChatModel.dart';
import 'package:apptex_chat/src/Models/UserModel.dart';
import 'package:apptex_chat/src/Screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';

import '../Models/MessageModel.dart';

class ChatController extends GetxController {
  RxList<MessageModel> chats = <MessageModel>[].obs;
  //FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  String roomUID;

  RxBool isTokenLoaded = false.obs;
  TextEditingController txtMsg = TextEditingController();
  ScrollController scrollController = ScrollController();
  ScrollController textFieldScrollController = ScrollController();
  RxBool isMaxScroll = false.obs;
  RxBool showPadding = false.obs;
  RxBool showSendButton = false.obs;
  RxBool micButtonPressed = false.obs;
  RxBool showLockAndSlide = false.obs;
  RxBool isSuccessful = false.obs;

  ChatController(this.roomUID) {
    // init();
  }

  @override
  void onInit() {
    scrollController.addListener(() {
      if (scrollController.position.pixels > 360 && !isMaxScroll.value) {
        isMaxScroll.value = true;
      } else if (scrollController.position.pixels < 360 && isMaxScroll.value) {
        isMaxScroll.value = false;
      }
    });
    chats.bindStream(firebaseFirestore
        .collection(roomCollection)
        .doc(roomUID)
        .collection(chatMessagesCollection)
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((event) {
      var s = event.docs.map((e) => MessageModel.fromSnapshot(e)).toList();
      return s;
    }));
    super.onInit();
  }

  startChat(BuildContext context, ChatModel model, String myUID) async {
    UserModel mine = model.users.firstWhere((element) => element.uid == myUID);

    UserModel otherUser =
        model.users.firstWhere((element) => element.uid != myUID);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatScreen(
                  chatController: this,
                  chatroomID: model.uid,
                  title: otherUser.name,
                  otherUserURl: otherUser.profileUrl,
                  userProfile: mine.profileUrl,
                  myUID: myUID,
                  fcm: "fcm",
                  myName: mine.name,
                )));
  }

  Future<String> uploadFile(File file, String serverPath) async {
    Reference reference = FirebaseStorage.instance.ref().child(serverPath);
    UploadTask uploadTask = reference.putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }

  Future addMessageSend(
      Map<String, dynamic> msgInput, String userFCMToken, String myname) async {
    // notificationController.sendNotification(
    //     title: myname,
    //     body: msgInput["message"],
    //     token: userFCMToken,
    //     isBooking: false);

    await firebaseFirestore
        .collection(roomCollection)
        .doc(roomUID)
        .collection(chatMessagesCollection)
        .doc()
        .set(msgInput)
        .then((value) {
      String msg = msgInput["CODE"] == "IMG" ? "Image" : msgInput["message"];
      Map<String, dynamic> lastMessageInfoMap = {
        "ReadByOther": false,
        "LastMessage": msg,
        "LastMsg_TimeStamp": Timestamp.now(),
        "LastMsg_SentBy": msgInput["sendBy"]
      };

      firebaseFirestore
          .collection(roomCollection)
          .doc(roomUID)
          .update(lastMessageInfoMap);

      return value;
    });
  }

  scrollToEnd() {
    scrollController
        .animateTo(scrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 600),
            curve: Curves.decelerate)
        .then((value) {
      isMaxScroll.value = false;
    });
  }

  Future<File?> pickMedia_only() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 35,
    );
    if (pickedFile == null) return null;

    return File(pickedFile.path);
  }
}
