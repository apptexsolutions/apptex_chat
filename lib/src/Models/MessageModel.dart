// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  late String uid;
  late String code; // IMG || MSG || AUDIO || VIDEO
  late String message;
  late String sendBy;
  late Timestamp timestamp;
  late String? repliedTo;

  MessageModel();

  MessageModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    uid = snapshot.id;
    code = map["CODE"];
    message = map["message"];
    sendBy = map["sendBy"];
    timestamp = map["timestamp"];
    repliedTo = map['repliedTo'];
  }
  // Map<String, dynamic> toJson() => {
  //   'CODE':code,
  //   'message':message,
  //   'sendBy':sendBy,
  //   'timestamp':timestamp,
  //   'repliedTo':null
  // };
}
