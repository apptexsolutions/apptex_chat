// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, no_logic_in_create_state, non_constant_identifier_names

import 'dart:io';
import 'package:apptex_chat/src/Models/MessageModel.dart';
import 'package:apptex_chat/src/Widgets/audio_bubble.dart';
import 'package:apptex_chat/src/Widgets/custom_animation.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/chat_conrtroller.dart';
import '../Controllers/contants.dart';
import '../Widgets/image_bubble.dart';
import '../Widgets/message_bubble.dart';
import '../Widgets/profile.dart';
import '../Widgets/replied_to.dart';
import '../Widgets/swipe_to_reply.dart';

class ChatScreen extends StatelessWidget {
  final String chatroomID;
  final String title;
  final String userProfile;
  final String otherUserURl;
  final ChatController chatController;
  final String myUID;
  final String fcm;
  final String myName;
  ChatScreen(
      {required this.chatController,
      required this.chatroomID,
      required this.title,
      required this.userProfile,
      required this.otherUserURl,
      required this.myUID,
      required this.fcm,
      required this.myName});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double curve = 0;
    return Scaffold(
      backgroundColor: kWhite,
      appBar: myappbar(size, context),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(curve),
                      topRight: Radius.circular(curve))),
              height: size.height * 0.874,
              width: size.width,
              child: Stack(
                children: [
                  Positioned.fill(child: chatMessages()),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: typingArea(size),
                  ),
                  Obx(() => Positioned(
                        bottom: chatController.replyMessage.value == null
                            ? 80
                            : 148,
                        right: 28,
                        child: scrol_button(),
                      )),
                ],
              ),
            ),
          ),
          // Positioned(top: 0, child: myappbar()),
        ],
      ),
    );
  }

  scrol_button() {
    return Visibility(
      visible: chatController.isMaxScroll.value,
      child: GestureDetector(
        onTap: () {
          chatController.scrollToEnd();
        },
        child: CircleAvatar(
          backgroundColor: kprimary2,
          radius: 16,
          child: Icon(
            Icons.keyboard_double_arrow_down_sharp,
            size: 20,
            color: kprimary1,
          ),
        ),
      ),
    );
  }

  AppBar myappbar(Size size, BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: kWhite,
      centerTitle: false,
      automaticallyImplyLeading: false,
      title: SizedBox(
        width: size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    margin: const EdgeInsets.all(10),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.grey.shade800,
                      size: 22,
                    ))),
            Text(title.toUpperCase(),
                style: TextStyle(
                    color: kprimary5,
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            ProfilePic(otherUserURl, size: 30),
          ],
        ),
      ),
    );
  }

  Widget chatMessages() {
    return GetX<ChatController>(
        init: chatController,
        builder: (controller) {
          if (controller.messages.isEmpty) {
            return !controller.isChatReady.value
                ? Center(
                    child: CircularProgressIndicator(
                    color: kprimary1,
                  ))
                : Center(
                    child: Text(
                    "No Chats yet!",
                    style: myStyle(16, true, color: Colors.grey),
                  ));
          } else {
            return AnimatedContainer(
              padding: EdgeInsets.only(
                  left: chatController.showPadding.value ? 15 : 8,
                  right: chatController.showPadding.value ? 15 : 8,
                  bottom: 15),
              duration: const Duration(seconds: 1, milliseconds: 200),
              child: ListView.builder(
                  controller: chatController.scrollController,
                  padding: EdgeInsets.only(
                      bottom:
                          chatController.replyMessage.value != null ? 130 : 60,
                      top: 8),
                  itemCount: controller.messages.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    MessageModel model = controller.messages[index];

                    return Column(
                      children: [
                        correspondingTypeAllocation(model),
                        if (index != 0 &&
                            model.timestamp.toDate().day !=
                                controller.messages[index - 1].timestamp
                                    .toDate()
                                    .day)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 4),
                            margin: const EdgeInsets.only(top: 20, bottom: 10),
                            decoration: BoxDecoration(
                                color: kWhite,
                                borderRadius: BorderRadius.circular(60),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 6,
                                      offset: const Offset(0, 2))
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                getMessageReferecneTime(controller
                                    .messages[index - 1].timestamp
                                    .toDate()),
                                style: TextStyle(
                                    color: kprimary1,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
            );
          }
        });
  }

  Widget correspondingTypeAllocation(MessageModel msg) {
    String code = msg.code;

    bool isMine = msg.sendBy == myUID;

    Timestamp timestamp = msg.timestamp;
    DateTime msgDate =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);

    String url = !isMine ? otherUserURl : userProfile;

    if (code == "MSG") {
      return SwipeToReply(
        callback: (details) {
          if (details.progress > 0.26) {
            chatController.replyMessage(msg.uid);
          }
        },
        isMine: isMine,
        child: MessageBubble(
          isMine: isMine,
          model: msg,
          profileUrl: url,
          msgDate: msgDate,
          chatController: chatController,
          myID: myUID,
          title: title,
        ),
      );
    } else if (code == "IMG") {
      return SwipeToReply(
          callback: (details) {
            if (details.progress > 0.26) {
              chatController.replyMessage(msg.uid);
            }
          },
          isMine: isMine,
          child: ImageBubble(
              isMine: isMine,
              message: msg.message,
              profileUrl: url,
              msgDate: msgDate));
    } else if (code == "MP3") {
      //TODO design a container for Audio
      return AudioBubble(
        isMine: isMine,
        model: msg,
        profileUrl: url,
        msgDate: msgDate,
        chatController: chatController,
        myID: myUID,
        title: title,
      );
    } else {
      return Container();
    }
  }

  addMesage(bool sendClicked) async {
    if (chatController.txtMsg.text != "") {
      String message = chatController.txtMsg.text.trim();
      var lastmsgTimeStamp = Timestamp.now();
      Map<String, dynamic> msginfoMap = {
        "message": message,
        "sendBy": myUID,
        "CODE": "MSG",
        "timestamp": lastmsgTimeStamp,
        "repliedTo": chatController.replyMessage.value
      };

      chatController.addMessageSend(msginfoMap, fcm, myName);

      if (sendClicked) {
        chatController.txtMsg.text = "";
        chatController.showSendButton.value = false;
        chatController.scrollToEnd();
      }
    }
  }

  addImage(File image) async {
    var lastmsgTimeStamp = Timestamp.now();
    Map<String, dynamic> msginfoMap = {
      "message": '',
      "sendBy": myUID,
      "CODE": "IMG",
      "timestamp": lastmsgTimeStamp,
    };
    final id = await chatController.addMessageSend(msginfoMap, fcm, myName);
    String name = myUID + Timestamp.now().millisecondsSinceEpoch.toString();
    String aaddress =
        await chatController.uploadFile(image, "ApptexChat/$name.jpg");
    chatController.updateExistingMessage(id, {'message': aaddress});
  }

  addVoice(File audio, String name) async {
    String aaddress =
        await chatController.uploadFile(audio, "ApptexChat/$name");
    var lastmsgTimeStamp = Timestamp.now();
    Map<String, dynamic> msginfoMap = {
      "message": aaddress,
      "sendBy": myUID,
      "CODE": "MP3",
      "timestamp": lastmsgTimeStamp,
    };
    chatController.addMessageSend(msginfoMap, fcm, myName);
  }

  typingArea(Size size) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: size.width,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(24)),
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.all(6),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Obx(
              () => Column(
                children: [
                  chatController.replyMessage.value != null
                      ? RepliedToWidget(
                          title: title,
                          myID: myUID,
                          showCloseButton: true,
                          messageId: chatController.replyMessage.value!,
                          chatController: chatController)
                      : const SizedBox(),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (chatController.micButtonPressed.value) {
                            chatController.micButtonPressed(false);
                            await chatController.recorderController.stop(false);
                            chatController.recorderController.reset();
                          } else {
                            File? ss = await chatController.pickMedia_only();
                            if (ss != null) {
                              addImage(ss);
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Icon(
                            chatController.micButtonPressed.value
                                ? Icons.delete
                                : Icons.attach_file,
                            color: chatController.micButtonPressed.value
                                ? kprimary1
                                : Colors.grey.shade600,
                            size: 27,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            readOnly: chatController.micButtonPressed.value,
                            focusNode: chatController.focusNode,
                            cursorColor: kprimary1,
                            onChanged: (val) {
                              if (val.trim().isEmpty) {
                                chatController.showPadding.value = false;
                                chatController.showSendButton.value = false;
                              } else {
                                chatController.showPadding.value = true;
                                chatController.showSendButton.value = true;
                              }
                            },
                            maxLines: 4,
                            minLines: 1,
                            scrollController:
                                chatController.textFieldScrollController,
                            controller: chatController.txtMsg,
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                                hintText: chatController.micButtonPressed.value
                                    ? null
                                    : "Send a message..",
                                hintStyle: TextStyle(
                                    color:
                                        Colors.grey.shade600.withOpacity(0.7)),
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      if (chatController.showSendButton.value)
                        GestureDetector(
                          onTap: () {
                            addMesage(true);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: kprimary1,
                            ),
                            child: const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Obx(() => chatController.micButtonPressed.value
            ? Positioned(
                bottom: 20,
                //right: 0,
                child: AudioWaveforms(
                    waveStyle: WaveStyle(
                      //showDurationLabel: true,
                      extendWaveform: true,
                      backgroundColor: Colors.black,
                      middleLineColor: Colors.transparent,
                      durationLinesColor: kprimary1,
                    ),
                    //backgroundColor: Colors.yellow,

                    //decoration: BoxDecoration(border: Border.all(width: 0)),
                    size: Size(Get.width * 0.55, 40),
                    recorderController: chatController.recorderController),
              )
            : const SizedBox()),
        Obx(
          () => chatController.showSendButton.value == false
              ? Positioned(
                  right: chatController.micButtonPressed.value ? -15 : 25,
                  bottom: chatController.micButtonPressed.value ? -20 : 20,
                  child: chatController.micButtonPressed.value
                      ? GestureDetector(
                          onTap: () async {
                            chatController.micButtonPressed.value = false;
                            await chatController.recorderController
                                .stop(false)
                                .then((path) {
                              chatController.recorderController.reset();
                              chatController.playerController
                                  .preparePlayer(path!)
                                  .then((value) => {
                                        chatController.playerController
                                            .startPlayer()
                                            .then((value) => chatController
                                                .playerController
                                                .stopPlayer())
                                      });

                              // addVoice(File(path), path.split('/').last);
                            });
                          },
                          child: CustomAnimation(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: kprimary1,
                              ),
                              child: const Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onLongPress: () async {
                            if (!chatController
                                .recorderController.hasPermission) {
                              chatController.recorderController
                                  .checkPermission();
                            }
                            chatController.micButtonPressed.value = true;
                            chatController.focusNode.unfocus();

                            String name = myUID +
                                Timestamp.now()
                                    .millisecondsSinceEpoch
                                    .toString();
                            await chatController.recorderController
                                .record(dir.path + '/$name');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: kprimary1,
                            ),
                            child: const Icon(
                              Icons.mic,
                              color: Colors.white,
                            ),
                          ),
                        ),
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}

getdate(var msgDate) {
  String date = getChatDate(msgDate);

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      date,
      style: myStyle(9, false, color: Colors.grey.shade600),
    ),
  );
}
