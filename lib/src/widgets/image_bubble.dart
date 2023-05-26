import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../core/utils/utils.dart';
import '../models/message_model.dart';

class ImageBubble extends StatelessWidget {
  final MessageModel model;
  final bool wasPreviousMsgeMine;
  const ImageBubble({
    Key? key,
    required this.model,
    this.wasPreviousMsgeMine = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double radius = 10;

    return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            model.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          IntrinsicWidth(
              child: Container(
            margin: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: !wasPreviousMsgeMine || !model.isMine ? 4 : 10),
            decoration: BoxDecoration(
                color: model.isMine
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(model.isMine
                        ? radius
                        : wasPreviousMsgeMine
                            ? radius
                            : 0),
                    topRight: Radius.circular(
                        model.isMine && wasPreviousMsgeMine ? 0 : radius),
                    bottomLeft: Radius.circular(radius),
                    bottomRight: Radius.circular(radius))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                                  color: model.isMine
                                      ? Colors.white
                                      : Theme.of(context).colorScheme.primary)),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(radius),
                          child: CachedNetworkImage(
                            imageUrl: model.content,
                            fit: BoxFit.cover,
                            width: 240,
                            height: 260,
                            placeholder: (context, url) => Container(
                              color: Colors.grey,
                              width: 240,
                              height: 260,
                              margin: EdgeInsets.zero,
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey,
                              width: 240,
                              height: 260,
                              margin: EdgeInsets.zero,
                            ),
                          )),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8, bottom: 2),
                    child: Text(
                      getChatDate(model.createdOn.toDate()),
                      style: TextStyle(
                          fontFamily: 'Helvetica Neue',
                          fontSize: 10,
                          color: model.isMine
                              ? Colors.grey.shade200
                              : Colors.grey.shade600,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                )
              ],
            ),
          )),
        ]);
  }
}
