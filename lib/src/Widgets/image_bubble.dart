import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../core/utils/utils.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

class ImageBubble extends StatelessWidget {
  final bool isMine;
  final MessageModel model;
  final ChatUserModel currentUser;
  final ChatUserModel otherUSer;
  const ImageBubble({
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
                  padding: const EdgeInsets.all(4),
                  child: model.content.isEmpty
                      ? Container(
                          width: 240,
                          height: 240,
                          alignment: Alignment.center,
                          child: SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: isMine
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.primary,
                              )),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(radius),
                          child: CachedNetworkImage(
                            imageUrl: model.content,
                            width: 240,
                            height: 260,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              width: 240,
                              height: 260,
                              alignment: Alignment.center,
                              child: SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: isMine
                                        ? Colors.white
                                        : Theme.of(context).colorScheme.primary,
                                  )),
                            ),
                          )),
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
