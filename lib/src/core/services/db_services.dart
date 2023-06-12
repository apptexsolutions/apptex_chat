import 'dart:io';

import 'package:apptex_chat/apptex_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../constant/strings.dart';

class ChatDBServices {
  ChatDBServices._();
  static final ChatDBServices _instance = ChatDBServices._();
  static ChatDBServices get instance => _instance;
  final _apptex = AppTexChat.instance;
  final _firestore = FirebaseFirestore.instance;
  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      streamConversationsWithPagination() {
    return _firestore
        .collection(conversationCollection)
        .where('userIds', arrayContains: _apptex.currentUser.uid)
        .where('lastMessage', isNotEqualTo: '')
        .snapshots()
        .map((event) => event.docs);
  }

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> streamChat(
      String chatRoomId) {
    return _firestore
        .collection(conversationCollection)
        .doc(chatRoomId)
        .collection(messagesCollection)
        .orderBy('createdOn', descending: true)
        .snapshots()
        .map((event) => event.docs);
  }

  Future<void> updateConversation(
      String roomId, Map<String, dynamic> fields) async {
    await _firestore
        .collection(conversationCollection)
        .doc(roomId)
        .update(fields);
  }

  Future<void> updateUnreadMessageCount(String roomId,
      {int count = 1, bool isReset = false}) async {
    if (isReset) {
      await _firestore
          .collection(conversationCollection)
          .doc(roomId)
          .update({'unreadMessageCount': 0});
    } else {
      await _firestore.collection(conversationCollection).doc(roomId).update({
        'lastMessageSenderId': AppTexChat.instance.currentUser.uid,
        'unreadMessageCount': FieldValue.increment(count)
      });
    }
  }

  ///this [startNewChat] method witll return boolean value
  ///return [true] if conversation already exist (skip creation of document)
  ///return [false] if conversation not exit also this method will create new document of provided model
  Future<ConversationModel?> startNewChat(ConversationModel model) async {
    final doc = await _firestore
        .collection(conversationCollection)
        .doc(model.chatRoomId)
        .get();
    if (doc.exists) {
      return ConversationModel.fromMap(doc.data() ?? {});
    }
    await _firestore
        .collection(conversationCollection)
        .doc(model.chatRoomId)
        .set(model.toMap());
    return null;
  }

  Future<String> sendMessage(String roomId, MessageModel model) async {
    final ref = _firestore
        .collection(conversationCollection)
        .doc(roomId)
        .collection(messagesCollection)
        .doc();
    await ref.set(model.copyWith(id: ref.id).toMap());
    return ref.id;
  }

  Future<String> uploadFile(File file, String serverPath) async {
    Reference reference = FirebaseStorage.instance.ref().child(serverPath);
    UploadTask uploadTask = reference.putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }

  Future<void> updateExistingMessage(
      String messageId, String roomId, Map<String, dynamic> fields) async {
    await _firestore
        .collection(conversationCollection)
        .doc(roomId)
        .collection(messagesCollection)
        .doc(messageId)
        .update(fields);
  }

  Future<void> deleteMessage(String roomId, String messageId) async {
    await _firestore
        .collection(conversationCollection)
        .doc(roomId)
        .collection(messagesCollection)
        .doc(messageId)
        .delete();
  }

  Future<void> deleteConversation({required String roomId}) async {
    var conversationDoc =
        await _firestore.collection(conversationCollection).doc(roomId).get();
    ConversationModel conversationModel =
        ConversationModel.fromMap(conversationDoc.data() ?? {});
    List<ChatUserModel> users = [
      conversationModel.currentUser.copyWith(deletedAt: Timestamp.now()),
      conversationModel.otherUser,
    ];
    await _firestore
        .collection(conversationCollection)
        .doc(roomId)
        .update({'users': users.map((e) => e.toMap()).toList()});
  }
}
