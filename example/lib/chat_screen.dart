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
      // typingWidget: Padding(
      //   padding: EdgeInsets.symmetric(horizontal: 20),
      //   //margin: EdgeInsets.only(bottom: 32, left: 32),
      //   child: Row(
      //     children: [
      //       Expanded(
      //         child: Container(
      //           padding: EdgeInsets.symmetric(horizontal: 20),
      //           decoration: BoxDecoration(
      //             color: Colors.grey.withOpacity(0.2),
      //             borderRadius: BorderRadius.circular(40),
      //           ),
      //           child: Row(
      //             children: [
      //               Icon(Icons.sentiment_satisfied_alt_outlined),
      //               SizedBox(width: 10),
      //               Expanded(
      //                 child: TextField(
      //                   controller: _controller,
      //                   decoration: InputDecoration(
      //                     border: InputBorder.none,
      //                     hintText: "Type a message",
      //                   ),
      //                   onChanged: (value) {
      //                     if (value.isNotEmpty)
      //                       setState(() {
      //                         showSendButton = true;
      //                       });
      //                     else
      //                       setState(
      //                         () {
      //                           showSendButton = false;
      //                         },
      //                       );
      //                   },
      //                 ),
      //               ),
      //               Icon(Icons.attach_file),
      //               SizedBox(width: 10),
      //               Icon(Icons.camera_alt),
      //             ],
      //           ),
      //         ),
      //       ),
      //       SizedBox(width: 10),
      //       Visibility(
      //         visible: showSendButton,
      //         child: InkWell(
      //           onTap: () {
      //             apptexChat.sendTextMessage(_controller.text);
      //             _controller.clear();
      //             setState(() {
      //               showSendButton = false;
      //             });
      //           },
      //           child: Container(
      //             padding: EdgeInsets.all(15),
      //             decoration: BoxDecoration(
      //               color: Colors.blue,
      //               shape: BoxShape.circle,
      //             ),
      //             child: Icon(
      //               Icons.send,
      //               color: Colors.white,
      //             ),
      //           ),
      //         ),
      //         replacement: Container(
      //           padding: EdgeInsets.all(15),
      //           decoration: BoxDecoration(
      //             color: Colors.blue,
      //             shape: BoxShape.circle,
      //           ),
      //           child: Icon(
      //             Icons.mic,
      //             color: Colors.white,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      bubbleBuilder: (model, currentUser, otherUser, isMine) {
        final code = model.code;
        if (code == 'TXT') {
          return MessageBubble(
            model: model,
          );
        } else if (code == 'IMG') {
          return ImageBubble(
            model: model,
          );
        } else if (code == 'MP3') {
          return AudioBubble(
            model: model,
          );
        } else {
          return Container();
        }
      },
    );
  }
}
