import 'dart:async';
import '../../models/conversation_model.dart';
import '../../models/message_model.dart';
import 'db_services.dart';

class ChatServices {
  ChatServices._();
  static final ChatServices _instance = ChatServices._();
  static ChatServices get instance => _instance;
  final _dbServices = ChatDBServices.instance;
  ConversationModel? conversationModel;
  List<MessageModel> messages = [];

  StreamController<List<MessageModel>>? messagesStreamController;
  StreamSubscription<List<MessageModel>>? _messagesStreamSubscription;

  void init(ConversationModel model) {
    conversationModel = model;
    messagesStreamController = StreamController.broadcast();
    messagesStreamController?.addStream(_streamMessages(model.chatRoomId));
    _messagesStreamSubscription =
        messagesStreamController?.stream.listen((List<MessageModel> list) {
      messages = list;
    });
  }

  Stream<List<MessageModel>> _streamMessages(String chatRoomId) {
    return _dbServices.streamChat(chatRoomId).map((event) {
      final temp = event.map((e) => MessageModel.fromMap(e.data())).toList();
      temp.sort((b, a) => a.createdOn.millisecondsSinceEpoch
          .compareTo(b.createdOn.millisecondsSinceEpoch));
      return temp;
    });
  }

  void dispose() {
    messages.clear();
    _messagesStreamSubscription?.cancel();
    messagesStreamController = null;
  }
}
