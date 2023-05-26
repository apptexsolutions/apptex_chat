import 'package:apptex_chat/apptex_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationModel {
  String chatRoomId;
  String lastMessage;
  List _userIds;
  Timestamp lastMessageTime;
  List<ChatUserModel> _users;
  String _lastMessageSenderId;
  int _unreadMessageCount;
  bool isRequestSent;
  ConversationModel({
    required this.chatRoomId,
    required this.lastMessage,
    required List<dynamic> userIds,
    required this.lastMessageTime,
    required List<ChatUserModel> users,
    required String lastMessageSenderId,
    required int unreadMessageCount,
    required this.isRequestSent,
  })  : _lastMessageSenderId = lastMessageSenderId,
        _userIds = userIds,
        _unreadMessageCount = unreadMessageCount,
        _users = users;

  ChatUserModel get updateCurrentUser => AppTexChat.instance.currentUser;
  ChatUserModel get oldCurrentUser => _users.firstWhere(
      (element) => element.uid == AppTexChat.instance.currentUser.uid);
  ChatUserModel get otherUser => _users.firstWhere(
      (element) => element.uid != AppTexChat.instance.currentUser.uid);
  int get unreadMessageCount =>
      _lastMessageSenderId != updateCurrentUser.uid ? _unreadMessageCount : 0;
  bool get isLastMessageMine => _lastMessageSenderId == updateCurrentUser.uid;
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
        userIds: userIds ?? _userIds,
        lastMessageTime: lastMessageTime ?? this.lastMessageTime,
        users: users ?? _users,
        isRequestSent: isRequestSent ?? this.isRequestSent,
        unreadMessageCount: unreadMessageCount ?? _unreadMessageCount,
        lastMessageSenderId: lastMessageSenderId ?? _lastMessageSenderId);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatRoomId': chatRoomId,
      'lastMessage': lastMessage,
      'userIds': _userIds,
      'lastMessageTime': lastMessageTime,
      'users': _users.map((x) => x.toMap()).toList(),
      'lastMessageSenderId': _lastMessageSenderId,
      'isRequestSent': isRequestSent,
    };
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
