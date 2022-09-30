// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names, file_names

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:apptex_chat/src/Models/UserModel.dart';

class ChatModel {
  String uid;
  Timestamp createdAt; // IMG || MSG || AUDIO || VIDEO
  String? lastMessage;
  String lastMessageSendBy;
  int unReadCount;
  bool ReadByOther;
  List<dynamic> uuids;
  List<dynamic> typers;
  Timestamp lastMessageTimeStamp;
  List<UserModel> users;
  ChatModel({
    required this.uid,
    required this.createdAt,
    required this.lastMessage,
    required this.lastMessageSendBy,
    required this.unReadCount,
    required this.ReadByOther,
    required this.uuids,
    required this.typers,
    required this.lastMessageTimeStamp,
    required this.users,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'createdAt': createdAt,
      'lastMessage': lastMessage,
      'lastMessageSendBy': lastMessageSendBy,
      'unReadCount': unReadCount,
      'ReadByOther': ReadByOther,
      'uuids': uuids,
      'typers': typers,
      'lastMessageTimeStamp': lastMessageTimeStamp,
      'users': users.map((x) => x.toMap()).toList(),
    };
  }

  factory ChatModel.fromMap(DocumentSnapshot snapshot) {
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    return ChatModel(
      uid: map['uid'] as String,
      createdAt: map['createdAt'],
      lastMessage: map['lastMessage'],
      lastMessageSendBy: map['lastMessageSendBy'] as String,
      unReadCount: map['unReadCount'] as int,
      ReadByOther: map['ReadByOther'] as bool,
      uuids: map['uuids'], //List<String>.from((map['uuids'] as List<String>),
      typers:
          map['uuids'], // List<String>.from((map['typers'] as List<String>),
      lastMessageTimeStamp: map['lastMessageTimeStamp'],
      users: List<UserModel>.from(
        (map['users'] as List<dynamic>).map<UserModel>(
          (x) => UserModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}
