import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../Models/MessageModel.dart';

class ChatController extends GetxController {
  RxList<MessageModel> chats = <MessageModel>[].obs;

  // init() {
  //   chats.bindStream(firebaseFirestore
  //       .collection("chats")
  //       .doc("")
  //       .collection("Messages")
  //       .orderBy("timestamp", descending: true)
  //       .snapshots()
  //       .map((event) {
  //     var s = event.docs.map((e) => MessageModel.fromSnapshot(e)).toList();

  //     return s;
  //   }));
  // }
}
