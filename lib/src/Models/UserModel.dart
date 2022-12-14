// ignore_for_file: file_names

class UserModel {
  String uid;
  String name;
  String profileUrl;
  UserModel({
    required this.uid,
    required this.name,
    required this.profileUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'profileUrl': profileUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      profileUrl: map['profileUrl'] as String,
    );
  }
}
