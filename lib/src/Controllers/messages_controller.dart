import 'package:apptex_chat/src/Models/ChatModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/get_rx.dart';

import '../Models/UserModel.dart';
import 'contants.dart';

class MessagesController {
  final RxList<ChatModel> _chats = <ChatModel>[].obs;
  RxList<ChatModel> filteredChats = <ChatModel>[].obs;
  RxString txtSeached = "".obs;

  final String _myuuid;
  List<UserModel> users = <UserModel>[].obs;
  bool showBackButton;

  MessagesController(this._myuuid, this.showBackButton) {
    debounce(txtSeached, (callback) {
      filteredChats.value = [];

      if (txtSeached.trim().isEmpty) {
        filteredChats.addAll(_chats);
      } else {
        List<ChatModel> chattss = [];
        chattss.addAll(_chats);

        List<UserModel> userss = [];
        userss.addAll(users.where((element) =>
            element.name.toLowerCase().contains(txtSeached.toLowerCase())));

        for (UserModel item in userss) {
          List<ChatModel> models =
              chattss.where((p0) => p0.users.contains(item)).toList();
          filteredChats.addAll(models);
        }
      }
    });
  }

  bindAllChats(String myuuid) {
    _chats.bindStream(FirebaseFirestore.instance
        .collection(roomCollection)
        .where("uuids", arrayContains: myuuid)
        .orderBy("lastMessageTimeStamp", descending: true)
        .snapshots()
        .map((event) {
      var s = event.docs.map((e) => ChatModel.fromMap(e)).toList();
      updateUsers(s);
      if (txtSeached.isEmpty) {
        filteredChats.clear();
        filteredChats.addAll(s);
      }
      return s;
    }));
  }

  void updateUsers(List<ChatModel> s) {
    users.clear();
    for (ChatModel x in s) {
      for (UserModel y in x.users) {
        if (y.uid != _myuuid) {
          users.add(y);
        }
      }
    }
    // print("TotaL Users : " + users.length.toString());
  }

  get myID => _myuuid;

  // initSearch() {
  //   RxList<ChatModel> __chats = <ChatModel>[].obs;

  //   __chats.addAll(_chats);

  //   if (txtSearcher.text.trim().isNotEmpty) {
  //     List<UserModel> userss = [];
  //     userss.addAll(users.where((element) =>
  //         element.name.toLowerCase().contains(txtSearcher.text.toLowerCase())));
  //     // filteredChats.clear();

  //     filteredChats.value =
  //         __chats.where((p0) => p0.uid.contains(txtSearcher.text)).toList();
  //     for (UserModel item in userss) {
  //       List<ChatModel> models =
  //           __chats.where((p0) => p0.users.contains(item)).toList();
  //       filteredChats.addAll(models);
  //     }
  //   } else {
  //     filteredChats = __chats;
  //   }

  //   //print(_chats.length.toString() + " => " + filteredChats.length.toString());
  //   print("_Chats : " + _chats.length.toString());
  //   print("__Chats : " + __chats.length.toString());
  //   print("Filtered : " + filteredChats.length.toString());
  //   print("----------------");
  // }
}
