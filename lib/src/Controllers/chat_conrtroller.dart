import 'dart:io';

import 'package:apptex_chat/src/Controllers/contants.dart';
import 'package:apptex_chat/src/Models/ChatModel.dart';
import 'package:apptex_chat/src/Models/UserModel.dart';
import 'package:apptex_chat/src/Screens/chat_screen.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';

import '../Models/MessageModel.dart';

class ChatController extends GetxController {
  RxList<MessageModel> messages = <MessageModel>[].obs;
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
  RxBool isChatReady = false.obs;
  bool isAllowedVoice;
  ChatController(this.roomUID, this.isAllowedVoice);

  //Reply
  Rxn<String> replyMessage = Rxn();
  final FocusNode focusNode = FocusNode();

  //Voice Message
  late final RecorderController recorderController;

  @override
  void onInit() {
    recorderController = RecorderController()
      ..bitRate = 48000
      ..sampleRate = 44100
      ..androidEncoder = AndroidEncoder.aac
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC;

    scrollController.addListener(() {
      if (scrollController.position.pixels > 360 && !isMaxScroll.value) {
        isMaxScroll.value = true;
      } else if (scrollController.position.pixels < 360 && isMaxScroll.value) {
        isMaxScroll.value = false;
      }
    });
    messages.bindStream(firebaseFirestore
        .collection(roomCollection)
        .doc(roomUID)
        .collection(chatMessagesCollection)
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((event) {
      var s = event.docs.map((e) => MessageModel.fromSnapshot(e)).toList();

      return s;
    }));

    ever(messages, (s) {
      isChatReady.value = true;
    });

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

  Future<void> updateExistingMessage(
      String id, Map<String, dynamic> map) async {
    firebaseFirestore
        .collection(roomCollection)
        .doc(roomUID)
        .collection(chatMessagesCollection)
        .doc(id)
        .update(map);
  }

  Future<String> addMessageSend(
      Map<String, dynamic> msgInput, String userFCMToken, String myname) async {
    // notificationController.sendNotification(
    //     title: myname,
    //     body: msgInput["message"],
    //     token: userFCMToken,
    //     isBooking: false);
    replyMessage.value = null;
    String msg = '';
    switch (msgInput["CODE"]) {
      case 'IMG':
        msg = 'Image';
        break;
      case 'MSG':
        msg = msgInput["message"];
        break;
      case 'MP3':
        msg = 'Audio';
        break;
      default:
        msg = msgInput["message"];
    }
    final ref = firebaseFirestore
        .collection(roomCollection)
        .doc(roomUID)
        .collection(chatMessagesCollection)
        .doc();
    await ref.set(msgInput);

    Map<String, dynamic> lastMessageInfoMap = {
      "ReadByOther": false,
      "lastMessage": msg,
      "lastMessageTimeStamp": Timestamp.now(),
      "lastMessageSendBy": msgInput["sendBy"]
    };

    firebaseFirestore
        .collection(roomCollection)
        .doc(roomUID)
        .update(lastMessageInfoMap);
    return ref.id;
  }

  scrollToEnd() {
    if (messages.length > 1) {
      scrollController
          .animateTo(scrollController.position.minScrollExtent,
              duration: const Duration(milliseconds: 600),
              curve: Curves.decelerate)
          .then((value) {
        isMaxScroll.value = false;
      });
    }
  }

  // ignore: non_constant_identifier_names
  Future<File?> pickMediaOnly() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 35,
    );
    if (pickedFile == null) return null;

    return File(pickedFile.path);
  }
}
