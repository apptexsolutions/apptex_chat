import 'dart:async';


import '../../core/services/conversation_services.dart';
import '../../models/base_view_model.dart';
import '../../models/conversation_model.dart';

class ConversationViewModel extends BaseViewModel {
  ConversationViewModel() {
    _conversationServices.init();
    _init();
  }
  StreamSubscription<List<ConversationModel>>? _streamSubscription;
  final _conversationServices = ConversationServices.instance;
  List<ConversationModel> get conversations =>
      _conversationServices.conversations;
  bool isLoading = true;

  void _init() {
    _streamSubscription = _conversationServices
        .conversationStreamController?.stream
        .listen((event) {
      isLoading = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _conversationServices.dispose();
    super.dispose();
  }
}
