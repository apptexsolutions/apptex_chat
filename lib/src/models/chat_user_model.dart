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
