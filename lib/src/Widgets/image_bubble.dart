import 'package:flutter/material.dart';

import '../Controllers/contants.dart';
import '../Screens/chat_screen.dart';
import '../Screens/full_screen_image.dart';
import 'profile.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageBubble extends StatelessWidget {
  final bool isMine;
  final String message;
  final String profileUrl;
  final DateTime msgDate;
  const ImageBubble(
      {Key? key,
      required this.isMine,
      required this.message,
      required this.profileUrl,
      required this.msgDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMine) Container(width: 3),
          if (!isMine) ProfilePic(profileUrl, size: 30),
          if (isMine) getdate(msgDate),
          IntrinsicWidth(
              child: Hero(
            tag: message,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FullScreenImage(
                              imgUrl: message,
                            )));
              },
              child: Container(
                // height: boxSize,
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.width * 0.7,
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                decoration: BoxDecoration(
                  color: isMine ? kprimary1 : kprimary2,
                  borderRadius: _borderRaduis(),
                ),
                child: message.isEmpty
                    ? Center(
                        child: SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: isMine ? Colors.white : kprimary1,
                            )),
                      )
                    : ClipRRect(
                        borderRadius: _borderRaduis(),
                        child: CachedNetworkImage(
                          imageUrl: message,
                          fit: BoxFit.cover,
                        )),
              ),
            ),
          )),
          if (!isMine) getdate(msgDate),
        ]);
  }

  BorderRadius _borderRaduis() {
    return BorderRadius.only(
      topLeft: isMine ? const Radius.circular(20) : const Radius.circular(0),
      bottomLeft:
          isMine ? const Radius.circular(20) : const Radius.circular(10),
      bottomRight:
          isMine ? const Radius.circular(10) : const Radius.circular(20),
      topRight: isMine ? const Radius.circular(0) : const Radius.circular(20),
    );
  }
}
