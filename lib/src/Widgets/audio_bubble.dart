import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import '../Controllers/chat_conrtroller.dart';
import '../Controllers/contants.dart';
import '../Models/MessageModel.dart';
import '../Screens/chat_screen.dart';
import 'profile.dart';
import 'replied_to.dart';

class AudioBubble extends StatelessWidget {
  final bool isMine;
  final MessageModel model;
  final String profileUrl;
  final DateTime msgDate;
  final ChatController chatController;
  final String myID;
  final String title;

  AudioBubble(
      {required this.isMine,
      required this.model,
      required this.profileUrl,
      required this.msgDate,
      required this.chatController,
      Key? key,
      required this.myID,
      required this.title})
      : super(key: key);
  RxBool fileExist = false.obs;

  @override
  Widget build(BuildContext context) {
    final name = FirebaseStorage.instance.refFromURL(model.message).name;
    isFileExist(name);
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
                maxWidth: MediaQuery.of(context).size.width * 0.7),
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {
                          // chatController.playerController
                          //     .preparePlayer(dir.path + '/' + name);
                        },
                        icon: Obx(() {
                          return Icon(
                              fileExist.value ? Icons.play_arrow : Icons.stop);
                        }),
                        color: Colors.white,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      AudioFileWaveforms(
                        size: Size(MediaQuery.of(context).size.width / 2, 70),
                        playerController: chatController.playerController,
                        density: 1.5,
                        playerWaveStyle: const PlayerWaveStyle(
                          scaleFactor: 0.8,
                          fixedWaveColor: Colors.white30,
                          liveWaveColor: Colors.white,
                          waveCap: StrokeCap.butt,
                        ),
                      ),
                    ],
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

  isFileExist(String name) async {
    fileExist(await File(dir.path + '/' + name).exists());
  }
}
