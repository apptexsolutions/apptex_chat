import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  late String uid;
  late String Code; // IMG || MSG || AUDIO || VIDEO
  late String message;
  late String sendBy;
  late Timestamp timestamp;

  MessageModel();

  MessageModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    uid = snapshot.id;
    Code = map["CODE"];
    message = map["message"];
    sendBy = map["sendBy"];
    timestamp = map["timestamp"];
  }
}
