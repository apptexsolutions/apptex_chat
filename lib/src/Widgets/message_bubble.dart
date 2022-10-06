import 'package:flutter/material.dart';
import '../Controllers/chat_conrtroller.dart';
import '../Controllers/contants.dart';
import '../Models/MessageModel.dart';
import '../Screens/chat_screen.dart';
import 'profile.dart';
import 'replied_to.dart';

class MessageBubble extends StatelessWidget {
  final bool isMine;
  final MessageModel model;
  final String profileUrl;
  final DateTime msgDate;
  final ChatController chatController;
  final String myID;
  final String title;

  const MessageBubble(
      {required this.isMine,
      required this.model,
      required this.profileUrl,
      required this.msgDate,
      required this.chatController,
      Key? key,
      required this.myID,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double radius = 16;
    return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMine) Container(width: 3),
          if (isMine) getdate(msgDate),
          if (!isMine) ProfilePic(profileUrl, size: 26),
          IntrinsicWidth(
              child: Container(
            constraints: BoxConstraints(
                minWidth: 50,
                maxWidth: MediaQuery.of(context).size.width * 0.6),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            // padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: isMine ? kprimary1 : kprimary2,
              borderRadius: BorderRadius.only(
                topLeft:
                    isMine ? Radius.circular(radius) : Radius.circular(radius),
                bottomLeft:
                    isMine ? Radius.circular(radius) : const Radius.circular(0),
                bottomRight:
                    isMine ? const Radius.circular(0) : Radius.circular(radius),
                topRight:
                    isMine ? Radius.circular(radius) : Radius.circular(radius),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                model.repliedTo != null
                    ? RepliedToWidget(
                        myID: myID,
                        title: title,
                        messegedByMe: isMine,
                        messageId: model.repliedTo!,
                        showCloseButton: false,
                        chatController: chatController)
                    : const SizedBox(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    model.message,
                    style: TextStyle(
                        color: isMine ? kWhite : Colors.grey.shade800,
                        fontWeight: FontWeight.w500,
                        fontSize: 13),
                  ),
                ),
              ],
            ),
          )),
          //  if (isMine) ProfilePic(profileUrl, size: 30),
          //if (isMine) Container(width: 3),
          if (!isMine) getdate(msgDate),
        ]);
  }
}
