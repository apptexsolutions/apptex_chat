import 'package:apptex_chat/apptex_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationModel {
  String chatRoomId;
  String lastMessage;
  List userIds;
  Timestamp lastMessageTime;
  List<ChatUserModel> users;
  String lastMessageSenderId;
  int unreadMessageCount;
  bool isRequestSent;
  ConversationModel({
    required this.chatRoomId,
    required this.lastMessage,
    required this.userIds,
    required this.lastMessageTime,
    required this.users,
    required this.lastMessageSenderId,
    required this.unreadMessageCount,
    required this.isRequestSent,
  });

  ConversationModel copyWith({
    String? chatRoomId,
    String? lastMessage,
    List? userIds,
    Timestamp? lastMessageTime,
    List<ChatUserModel>? users,
    String? lastMessageSenderId,
    int? unreadMessageCount,
    bool? isRequestSent,
  }) {
    return ConversationModel(
        chatRoomId: chatRoomId ?? this.chatRoomId,
        lastMessage: lastMessage ?? this.lastMessage,
        userIds: userIds ?? this.userIds,
        lastMessageTime: lastMessageTime ?? this.lastMessageTime,
        users: users ?? this.users,
        isRequestSent: isRequestSent ?? this.isRequestSent,
        unreadMessageCount: unreadMessageCount ?? this.unreadMessageCount,
        lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatRoomId': chatRoomId,
      'lastMessage': lastMessage,
      'userIds': userIds,
      'lastMessageTime': lastMessageTime,
      'users': users.map((x) => x.toMap()).toList(),
      'lastMessageSenderId': lastMessageSenderId,
      'isRequestSent': isRequestSent,
    };
  }

  ChatUserModel get getOtherUser {
    return users.firstWhere(
        (element) => element.uid != AppTexChat.instance.currentUser.uid);
  }

  ChatUserModel get getCurrentUser {
    return users.firstWhere(
        (element) => element.uid == AppTexChat.instance.currentUser.uid);
  }

  factory ConversationModel.fromMap(Map<String, dynamic> map) {
    return ConversationModel(
      chatRoomId: map['chatRoomId'] as String,
      lastMessage: map['lastMessage'] as String,
      isRequestSent: map['isRequestSent'] ?? false,
      userIds: List.from(map['userIds'] ?? []),
      lastMessageTime: map['lastMessageTime'] ?? Timestamp.now(),
      lastMessageSenderId: map['lastMessageSenderId'],
      unreadMessageCount: map['unreadMessageCount'] ?? 0,
      users: List<ChatUserModel>.from(
        (map['users'] ?? []).map<ChatUserModel>(
          (x) => ChatUserModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}

class ChatUserModel {
  String uid;
  String? profileUrl;
  String name;
  String? fcmToken;

  ChatUserModel({
    required this.uid,
    required this.profileUrl,
    required this.name,
    required this.fcmToken,
  });

  ChatUserModel copyWith({
    String? uid,
    String? profileUrl,
    String? name,
    String? fcmToken,
  }) {
    return ChatUserModel(
      uid: uid ?? this.uid,
      profileUrl: profileUrl ?? this.profileUrl,
      name: name ?? this.name,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'profileUrl': profileUrl,
      'name': name,
      'fcmToken': fcmToken,
    };
  }

  factory ChatUserModel.fromMap(Map<String, dynamic> map) {
    return ChatUserModel(
      uid: map['uid'] as String,
      profileUrl:
          map['profileUrl'] != null ? map['profileUrl'] as String : null,
      name: map['name'] as String,
      fcmToken: map['fcmToken'] != null ? map['fcmToken'] as String : null,
    );
  }
}
