import 'dart:developer';
import 'dart:io';

import 'package:apptex_chat/src/core/extensions/num_extensions.dart';
import 'package:apptex_chat/src/models/chat_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ntp/ntp.dart';

import 'core/services/chat_services.dart';
import 'core/services/db_services.dart';
import 'models/conversation_model.dart';
import 'models/message_model.dart';

class AppTexChat {
  AppTexChat._();
  static final AppTexChat _instance = AppTexChat._();
  static AppTexChat get instance => _instance;
  late ChatUserModel _currentUser;
  bool isInitialize = false;
  late int _ntpOffeset;

  ChatUserModel get currentUser => _currentUser;

  Future<void> initChat({required ChatUserModel currentUser}) async {
    _currentUser = currentUser;
    isInitialize = true;
    _ntpOffeset = await NTP.getNtpOffset(localTime: DateTime.now());
  }

  ///[startNewConversationWith] method will initialize current user caht with provided user
  ///it is [Future<ConversationModel>] method so controll your navigation also show some loading in the ui if needed
  Future<ConversationModel> startNewConversationWith(ChatUserModel userModel,
      {String? initialMessage}) async {
    if (!isInitialize) {
      log('AppTexChat Error: Initialize AppTextChat first by calling AppTexChat.instance.initChat()',
          name: 'AppTextChat');
    }

    final _dbServices = ChatDBServices.instance;
    final roomId = _getChatRoomID(userModel.uid);
    final model = ConversationModel(
        chatRoomId: roomId,
        lastMessage: initialMessage ?? '',
        userIds: [currentUser.uid, userModel.uid],
        lastMessageTime: Timestamp.now(),
        users: [currentUser, userModel],
        lastMessageSenderId: initialMessage == null ? '' : currentUser.uid,
        isRequestSent: false,
        unreadMessageCount: 0);

    final result = await _dbServices.startNewChat(model);
    ChatServices.instance.conversationModel = result ?? model;
    if (result != null) {
      return result;
    } else {
      return model;
    }
  }

  Future<void> sendTextMessage(String text) async {
    if (text.isEmpty) {
      log('Text is Empty in sendTextMessage [text]', name: 'Apptext Chat');
      return;
    }
    final _dbServices = ChatDBServices.instance;

    final _chatService = ChatServices.instance;
    final model = MessageModel(
        id: '',
        code: 'TXT',
        content: text,
        senderId: currentUser.uid,
        createdOn:
            Timestamp.fromDate(DateTime.now().add(_ntpOffeset.milliseconds)),
        isMessageRead: false);

    if (_chatService.conversationModel != null) {
      await _dbServices.sendMessage(
          _chatService.conversationModel!.chatRoomId, model);

      _dbServices
          .updateConversation(_chatService.conversationModel!.chatRoomId, {
        'lastMessage': text,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessageSenderId': currentUser.uid,
      });

      _dbServices
          .updateUnreadMessageCount(_chatService.conversationModel!.chatRoomId);
    } else {
      log('Conversation Model is Null', name: 'Apptext Chat');
    }
  }

  ///It will return messageId so that you can update your customMessage
  Future<String?> sendCustomMessage(
      MessageModel messageModel, String message) async {
    if (message.isEmpty) {
      log('Message is Empty in sendCustomMessage [message]',
          name: 'Apptext Chat');
      return null;
    }
    final _dbServices = ChatDBServices.instance;

    final _chatService = ChatServices.instance;

    if (_chatService.conversationModel != null) {
      final messageId = await _dbServices.sendMessage(
          _chatService.conversationModel!.chatRoomId, messageModel);
      _dbServices
          .updateConversation(_chatService.conversationModel!.chatRoomId, {
        'lastMessage': message,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessageSenderId': currentUser.uid,
      });
      return messageId;
    } else {
      log('Conversation Model is Null', name: 'Apptext Chat');
      return null;
    }
  }

  Future<void> updateCustomMessage(
      String id, String message, MessageModel model) async {
    if (message.isEmpty) {
      log('Message is Empty in UpdateCustom [message]', name: 'Apptext Chat');
      return;
    }
    final _dbServices = ChatDBServices.instance;

    final _chatService = ChatServices.instance;
    await _dbServices.updateExistingMessage(
        id, _chatService.conversationModel!.chatRoomId, model.toMap());
    _dbServices.updateConversation(_chatService.conversationModel!.chatRoomId, {
      'lastMessage': message,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'lastMessageSenderId': currentUser.uid,
    });
    _dbServices
        .updateUnreadMessageCount(_chatService.conversationModel!.chatRoomId);
  }

  Future<void> sendImage(File file) async {
    final _dbServices = ChatDBServices.instance;

    final _chatService = ChatServices.instance;
    final model = MessageModel(
        id: '',
        code: 'IMG',
        content: '',
        senderId: currentUser.uid,
        createdOn:
            Timestamp.fromDate(DateTime.now().add(_ntpOffeset.milliseconds)),
        isMessageRead: false);

    if (_chatService.conversationModel != null) {
      final _id = await _dbServices.sendMessage(
          _chatService.conversationModel!.chatRoomId, model);
      _dbServices
          .updateConversation(_chatService.conversationModel!.chatRoomId, {
        'lastMessage': 'Image',
        'lastMessageSenderId': currentUser.uid,
        'lastMessageTime': FieldValue.serverTimestamp(),
      });
      _dbServices
          .updateUnreadMessageCount(_chatService.conversationModel!.chatRoomId);
      String name =
          currentUser.uid + Timestamp.now().millisecondsSinceEpoch.toString();
      String _url = await _dbServices.uploadFile(file, "ApptexChat/$name.jpg");
      _dbServices.updateExistingMessage(
          _id, _chatService.conversationModel!.chatRoomId, {'content': _url});
    } else {
      log('Conversation Model is Null', name: 'Apptext Chat');
    }
  }

  Future<void> sendVoiceMessage(File file) async {
    final _dbServices = ChatDBServices.instance;

    final _chatService = ChatServices.instance;
    final model = MessageModel(
        id: '',
        code: 'MP3',
        content: '',
        senderId: currentUser.uid,
        createdOn:
            Timestamp.fromDate(DateTime.now().add(_ntpOffeset.milliseconds)),
        isMessageRead: false);

    if (_chatService.conversationModel != null) {
      final _id = await _dbServices.sendMessage(
          _chatService.conversationModel!.chatRoomId, model);
      _dbServices
          .updateConversation(_chatService.conversationModel!.chatRoomId, {
        'lastMessage': 'Voice',
        'lastMessageSenderId': currentUser.uid,
        'lastMessageTime': FieldValue.serverTimestamp(),
      });
      _dbServices
          .updateUnreadMessageCount(_chatService.conversationModel!.chatRoomId);
      String name =
          currentUser.uid + Timestamp.now().millisecondsSinceEpoch.toString();
      String _url = await _dbServices.uploadFile(file, "ApptexChat/$name");
      log("URL =============> $_url");
      await _dbServices.updateExistingMessage(
          _id, _chatService.conversationModel!.chatRoomId, {'content': _url});
    } else {
      log('Conversation Model is Null', name: 'Apptext Chat');
    }
  }

  Future<void> updateExistingMessage(
      String roomId, String messageId, Map<String, dynamic> fields) async {
    final _dbServices = ChatDBServices.instance;
    await _dbServices.updateExistingMessage(messageId, roomId, fields);
  }

  Future<void> deleteMessage(
    String roomId,
    String messageId,
  ) async {
    final _dbServices = ChatDBServices.instance;
    await _dbServices.deleteMessage(roomId, messageId);
  }

  String _getChatRoomID(String otherUserId) {
    String chatRoomID = "";
    if (currentUser.uid.compareTo(otherUserId) == 1) {
      chatRoomID = currentUser.uid + "_" + otherUserId;
    } else {
      chatRoomID = otherUserId + "_" + currentUser.uid;
    }
    return chatRoomID;
  }

  Future<void> updateConversation(
      String roomId, Map<String, dynamic> fields) async {
    final _dbServices = ChatDBServices.instance;

    await _dbServices.updateConversation(roomId, fields);
  }
}
