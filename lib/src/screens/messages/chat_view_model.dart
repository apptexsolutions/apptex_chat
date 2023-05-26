import 'dart:async';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../apptex_chat.dart';
import '../../core/services/chat_services.dart';
import '../../core/services/db_services.dart';
import '../../core/utils/utils.dart';
import '../../models/base_view_model.dart';
import '../../models/conversation_model.dart';
import '../../models/message_model.dart';

class ChatViewModel extends BaseViewModel {
  ChatViewModel({required this.model}) {
    _chatServices.init(model);
    _init();
  }

  //Variables
  final AppTexChat _appTexChat = AppTexChat.instance;
  final ConversationModel model;
  bool showSendButton = false;
  final _chatServices = ChatServices.instance;
  final _dbServices = ChatDBServices.instance;
  bool isChatReady = false;
  bool micButtonPressed = false;

  //Controllers
  final TextEditingController messageController = TextEditingController();
  late final RecorderController recorderController;

  //Subsciptions
  StreamSubscription<List<MessageModel>>? _streamSubscription;

  //Getters
  List<MessageModel> get messages => _chatServices.messages;
  ChatUserModel get currentUser => AppTexChat.instance.currentUser;
  ChatUserModel get otherUser => model.otherUser;

  //Methods

  void _init() {
    recorderController = RecorderController()
      ..bitRate = 48000
      ..sampleRate = 44100;
    _dbServices.updateConversation(model.chatRoomId, {
      'users': [
        currentUser.toMap(),
        otherUser.toMap(),
      ]
    });
    if (!model.isLastMessageMine) {
      _dbServices.updateUnreadMessageCount(model.chatRoomId, isReset: true);
    }
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

  sendTextMessage() {
    _appTexChat.sendTextMessage(messageController.text);
    messageController.clear();

    showSendButton = false;
    notifyListeners();
  }

  startRecording() async {
    if (!recorderController.hasPermission) {
      recorderController.checkPermission();
    }
    micButtonPressed = true;
    notifyListeners();
    String name =
        currentUser.uid + Timestamp.now().millisecondsSinceEpoch.toString();
    await recorderController.record(path: Directory.systemTemp.path + '/$name');
  }

  cancelVoiceMessage() {
    micButtonPressed = false;
    recorderController.stop(false);
    recorderController.reset();
    notifyListeners();
  }

  sendVoiceMessage() async {
    micButtonPressed = false;
    notifyListeners();
    final path = await recorderController.stop(true);
    _appTexChat.sendVoiceMessage(File(path!));
  }

  void update() {
    notifyListeners();
  }

  @override
  void dispose() {
    if (messages.isNotEmpty && !messages.first.isMine) {
      _dbServices.updateUnreadMessageCount(model.chatRoomId, isReset: true);
    }
    _streamSubscription?.cancel();
    _chatServices.dispose();
    super.dispose();
  }
}
