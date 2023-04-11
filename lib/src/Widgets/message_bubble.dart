// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';


import '../core/utils/utils.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final bool isMine;
  final MessageModel model;
  final ChatUserModel currentUser;
  final ChatUserModel otherUSer;
  const MessageBubble({
    Key? key,
    required this.isMine,
    required this.model,
    required this.currentUser,
    required this.otherUSer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double radius = 10;

    return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          IntrinsicWidth(
              child: Container(
            constraints: BoxConstraints(
                minHeight: 42,
                maxWidth: MediaQuery.of(context).size.width * 0.6,
                minWidth: MediaQuery.of(context).size.width * 0.4),
            margin: const EdgeInsets.only(left: 12, right: 12, bottom: 10),
            // padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: isMine
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.only(
                topLeft: isMine ? Radius.circular(radius) : Radius.circular(0),
                bottomLeft:
                    isMine ? Radius.circular(radius) : Radius.circular(radius),
                bottomRight:
                    isMine ? const Radius.circular(0) : Radius.circular(radius),
                topRight:
                    isMine ? Radius.circular(radius) : Radius.circular(radius),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // model.repliedTo != null
                //     ? RepliedToWidget(
                //         myID: myID,
                //         title: title,
                //         messegedByMe: isMine,
                //         messageId: model.repliedTo!,
                //         showCloseButton: false,
                //         chatController: chatController)
                //     : const SizedBox(),

                Padding(
                  padding: const EdgeInsets.only(
                      left: 12, right: 12, top: 8, bottom: 4),
                  child: Text(
                    model.content,
                    style: TextStyle(
                        fontFamily: 'Helvetica Neue',
                        color: isMine ? Colors.white : Colors.grey.shade800,
                        fontWeight: FontWeight.w500),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 12, bottom: 4),
                  child: Text(
                    getChatDate(model.createdOn.toDate()),
                    style: TextStyle(
                        fontFamily: 'Helvetica Neue',
                        fontSize: 10,
                        color: isMine ? Colors.white54 : Colors.grey,
                        fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
          )),
        ]);
  }
}
