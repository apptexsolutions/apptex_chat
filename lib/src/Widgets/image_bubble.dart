import 'package:flutter/material.dart';

import '../Controllers/contants.dart';
import '../Screens/chat_screen.dart';
import '../Screens/full_screen_image.dart';
import 'profile.dart';

class ImageBubble extends StatelessWidget {
  final bool isMine;
  final String message;
  final String profileUrl;
  final DateTime msgDate;
  const ImageBubble({Key? key, required this.isMine, required this.message, required this.profileUrl, required this.msgDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double boxSize = 180;
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
                height: boxSize,
                width: boxSize,
                constraints: BoxConstraints(
                    minWidth: 50,
                    maxWidth: MediaQuery.of(context).size.width / 1.3),
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(message), fit: BoxFit.cover),
                  color: isMine ? kprimary1 : kprimary2,
                  borderRadius: BorderRadius.only(
                    topLeft: isMine
                        ? const Radius.circular(20)
                        : const Radius.circular(0),
                    bottomLeft: isMine
                        ? const Radius.circular(20)
                        : const Radius.circular(10),
                    bottomRight: isMine
                        ? const Radius.circular(10)
                        : const Radius.circular(20),
                    topRight: isMine
                        ? const Radius.circular(0)
                        : const Radius.circular(20),
                  ),
                ),
              ),
            ),
          )),
          if (!isMine) getdate(msgDate),
        ]);
  }
}
