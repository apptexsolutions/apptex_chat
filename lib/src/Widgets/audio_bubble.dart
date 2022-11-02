import 'package:apptex_chat/src/Controllers/audiobubble_controller.dart';
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
  final AudiobubbleController audiobubbleController;

  const AudioBubble(
      {required this.isMine,
      required this.model,
      required this.profileUrl,
      required this.msgDate,
      required this.chatController,
      required this.audiobubbleController,
      Key? key,
      required this.myID,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double radius = 16;
    Size size = MediaQuery.of(context).size;

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
                  child:
                      // if (!audiobubbleController.fileExist.value) {
                      //   return Row(
                      // children: [
                      //   Container(
                      //     height: 40,
                      //     width: 40,
                      //     decoration: const BoxDecoration(
                      //         color: Colors.white, shape: BoxShape.circle),
                      //     child: audiobubbleController.isDownloading.value
                      //         ? Container(
                      //             padding: const EdgeInsets.all(10),
                      //             child: CircularProgressIndicator(
                      //               color: kprimary1,
                      //             ))
                      //         : const Icon(Icons.download),
                      //   ),
                      //       const SizedBox(width: 10),
                      //       Text(
                      //         "Audio message",
                      //         style: myStyle(15, true, color: Colors.white),
                      //       )
                      //     ],
                      //   );
                      // } else

                      Obx(() {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                            width: 40,
                            child: !audiobubbleController.fileExist.value
                                ? Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    child: audiobubbleController
                                            .isDownloading.value
                                        ? Container(
                                            height: 40,
                                            width: 40,
                                            padding: const EdgeInsets.all(10),
                                            child: CircularProgressIndicator(
                                              color: kprimary1,
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () {
                                              audiobubbleController
                                                  .downloadAudio();
                                            },
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: !audiobubbleController
                                                        .isInited.value
                                                    ? Icon(
                                                        Icons.play_arrow,
                                                        color: kprimary1,
                                                      )
                                                    : const Icon(
                                                        Icons.download)),
                                          ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      audiobubbleController.playAudio();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      child: Icon(
                                        audiobubbleController.isPlaying.value
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: kprimary1,
                                      ),
                                    ),
                                  )),
                        audiobubbleController.fileExist.value
                            ? Obx(() {
                                return SizedBox(
                                    width: size.width * 0.5,
                                    child: Slider(
                                        thumbColor: kprimary5,
                                        activeColor: kprimary3,
                                        min: 0,
                                        max: audiobubbleController.max.value,
                                        value: audiobubbleController
                                            .progress.value,
                                        onChanged: (a) {}));
                              })
                            : SizedBox(
                                width: size.width * 0.5,
                                child: Slider(
                                    thumbColor: kprimary5,
                                    activeColor: kprimary3,
                                    min: 0,
                                    max: 100,
                                    value: 0,
                                    onChanged: (a) {}))
                      ],
                    );
                  }),
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
