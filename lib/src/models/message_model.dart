import 'package:apptex_chat/apptex_chat.dart';
import 'package:apptex_chat/src/core/services/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String id;
  String code;
  String content;
  String _senderId;
  Timestamp createdOn;
  bool isMessageRead;
  MessageModel({
    this.id = '',
    required this.code,
    required this.content,
    required String senderId,
    required this.createdOn,
    this.isMessageRead = false,
  }) : _senderId = senderId;

  ChatUserModel get sender => AppTexChat.instance.currentUser.uid == _senderId
      ? AppTexChat.instance.currentUser
      : ChatServices.instance.conversationModel!.otherUser;
  bool get isMine => AppTexChat.instance.currentUser.uid == _senderId;

  MessageModel copyWith({
    String? id,
    String? code,
    String? content,
    String? senderId,
    Timestamp? createdOn,
    bool? isMessageRead,
  }) {
    return MessageModel(
      id: id ?? this.id,
      code: code ?? this.code,
      content: content ?? this.content,
      senderId: senderId ?? _senderId,
      createdOn: createdOn ?? this.createdOn,
      isMessageRead: isMessageRead ?? this.isMessageRead,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'content': content,
      'senderId': _senderId,
      'createdOn': createdOn,
      'isMessageRead': isMessageRead,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] as String,
      code: map['code'] as String,
      content: map['content'] as String,
      senderId: map['senderId'] as String,
      createdOn: map['createdOn'],
      isMessageRead: map['isMessageRead'] as bool,
    );
  }
}
