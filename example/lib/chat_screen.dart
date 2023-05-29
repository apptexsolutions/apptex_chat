import 'package:apptex_chat/apptex_chat.dart';
import 'package:flutter/material.dart';

class CustomChatScreen extends StatefulWidget {
  final ConversationModel model;
  CustomChatScreen(this.model);

  @override
  State<CustomChatScreen> createState() => _CustomChatScreenState();
}

class _CustomChatScreenState extends State<CustomChatScreen> {
  late TextEditingController _controller;
  bool showSendButton = false;
  var apptexChat = AppTexChat.instance;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChatScreen(
      conversationModel: widget.model,
      showMicButton: true,
      appBarBuilder: ((currentUser, otherUser) => AppBar()),
      bubbleBuilder: (model, currentUser, otherUser, isMine) {
        final code = model.code;
        if (code == 'TXT') {
          return MessageBubble(model: model);
        } else if (code == 'IMG') {
          return ImageBubble(model: model);
        } else if (code == 'MP3') {
          return AudioBubble(model: model);
        } else {
          return Container();
        }
      },
    );
  }
}
