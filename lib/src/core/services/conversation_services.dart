import 'dart:async';

import '../../models/conversation_model.dart';
import 'db_services.dart';

class ConversationServices {
  ConversationServices._();
  static final ConversationServices _instance = ConversationServices._();
  static ConversationServices get instance => _instance;
  final _dbServices = ChatDBServices.instance;
  List<ConversationModel> conversations = [];

  StreamController<List<ConversationModel>>? conversationStreamController;
  StreamSubscription<List<ConversationModel>>? _conversationStreamSubscription;

  void init() {
    conversationStreamController = StreamController.broadcast();
    conversationStreamController?.addStream(_streamConversations());
    _conversationStreamSubscription = conversationStreamController?.stream
        .listen((List<ConversationModel> list) {
      conversations = list;
    });
  }

  Stream<List<ConversationModel>> _streamConversations() {
    return _dbServices.streamConversationsWithPagination().map((event) {
      final temp =
          event.map((e) => ConversationModel.fromMap(e.data())).toList();
      temp.sort((b, a) => a.lastMessageTime.millisecondsSinceEpoch
          .compareTo(b.lastMessageTime.millisecondsSinceEpoch));

      return temp
          .where((conversation) =>
              conversation.lastMessageTime.millisecondsSinceEpoch >
              conversation.currentUser.deletedAt!.millisecondsSinceEpoch)
          .toList();
    });
  }

  // void streamMore() {
  //   if (_conversationDocs.isNotEmpty) {
  //     _lastConversationDoc = _conversationDocs.last;
  //   }
  // }

  void dispose() {
    _conversationStreamSubscription?.cancel();
    conversationStreamController = null;
  }
}
