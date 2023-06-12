import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUserModel {
  String uid;
  String? profileUrl;
  String name;
  String? fcmToken;
  Timestamp? deletedAt;

  ChatUserModel({
    required this.uid,
    required this.profileUrl,
    required this.name,
    required this.fcmToken,
    this.deletedAt,
  });

  ChatUserModel copyWith({
    String? uid,
    String? profileUrl,
    String? name,
    String? fcmToken,
    Timestamp? deletedAt,
  }) {
    return ChatUserModel(
      uid: uid ?? this.uid,
      profileUrl: profileUrl ?? this.profileUrl,
      name: name ?? this.name,
      fcmToken: fcmToken ?? this.fcmToken,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'profileUrl': profileUrl,
      'name': name,
      'fcmToken': fcmToken,
      'deletedAt': deletedAt,
    };
  }

  factory ChatUserModel.fromMap(Map<String, dynamic> map) {
    return ChatUserModel(
      uid: map['uid'] as String,
      profileUrl:
          map['profileUrl'] != null ? map['profileUrl'] as String : null,
      name: map['name'] as String,
      fcmToken: map['fcmToken'] != null ? map['fcmToken'] as String : null,
      deletedAt: map['deletedAt'],
    );
  }
}
