import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../apptex_chat.dart';
import '../../core/services/chat_services.dart';
import '../../core/services/db_services.dart';
import '../../core/utils/utils.dart';
import '../../models/base_view_model.dart';
import '../../models/conversation_model.dart';
import '../../models/message_model.dart';

class ChatViewModel extends BaseViewModel {
  final ConversationModel model;
  ChatViewModel({required this.model}) {
    _chatServices.init(model);
    _init();
  }
  StreamSubscription<List<MessageModel>>? _streamSubscription;
  final _chatServices = ChatServices.instance;
  final _dbServices = ChatDBServices.instance;
  bool isChatReady = false;
  List<MessageModel> get messages => _chatServices.messages;
  ChatUserModel get currentUser => AppTexChat.instance.currentUser;
  ChatUserModel get otherUser =>
      model.users.firstWhere((element) => element.uid != currentUser.uid);

  void _init() {
    _dbServices.updateConversation(model.chatRoomId, {
      'users': [
        currentUser.toMap(),
        otherUser.toMap(),
      ]
    });
    if (model.lastMessageSenderId != currentUser.uid)
      _dbServices.updateUnreadMessageCount(model.chatRoomId, isReset: true);
    _streamSubscription =
        _chatServices.messagesStreamController?.stream.listen((event) {
      isChatReady = true;
      notifyListeners();
    });
  }

  String getMessageReferecneTime(Timestamp time) {
    final now = DateTime.now();
    final date = time.toDate();
    int days = daysBetween(date, now);

    if (days < 1) {
      return "Today";
    } else if (days < 2) {
      return "Yesterday";
    } else if (days <= 7) {
      return weekdayName[date.weekday].toString();
    } else {
      String sdate = months[date.month - 1] +
          " " +
          date.day.toString() +
          ", " +
          date.year.toString();
      return sdate;
    }
  }

  @override
  void dispose() {
    if (messages.isNotEmpty) if (messages.first.senderId != currentUser.uid)
      _dbServices.updateUnreadMessageCount(model.chatRoomId, isReset: true);
    _streamSubscription?.cancel();
    _chatServices.dispose();
    super.dispose();
  }
}
