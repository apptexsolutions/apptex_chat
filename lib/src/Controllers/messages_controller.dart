import 'package:apptex_chat/src/Models/ChatModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'contants.dart';

class MessagesController extends GetxController {
  RxList<ChatModel> chats = <ChatModel>[].obs;
  RxList<ChatModel> filteredChats = <ChatModel>[].obs;
  MessagesController(this.myuuid);
  String myuuid;

  bindAllChats() {
    chats.bindStream(FirebaseFirestore.instance
        .collection(roomCollection)
        .where("uuids", arrayContains: myuuid)
        .orderBy("lastMessageTimeStamp", descending: true)
        .snapshots()
        .map((event) {
      var s = event.docs.map((e) => ChatModel.fromMap(e)).toList();

      return s;
    }));
  }
}
