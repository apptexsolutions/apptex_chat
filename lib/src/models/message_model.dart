

import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String id;
  String code;
  String content;
  String senderId;
  Timestamp createdOn;
  bool isMessageRead;
  MessageModel({
     this.id='',
    required this.code,
    required this.content,
    required this.senderId,
    required this.createdOn,
    this.isMessageRead=false,
  });
  

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
      senderId: senderId ?? this.senderId,
      createdOn: createdOn ?? this.createdOn,
      isMessageRead: isMessageRead ?? this.isMessageRead,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'content': content,
      'senderId': senderId,
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
