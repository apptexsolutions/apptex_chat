// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, no_logic_in_create_state, non_constant_identifier_names

import 'dart:io';

import 'package:apptex_chat/src/Models/MessageModel.dart';
import 'package:apptex_chat/src/Screens/full_screen_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../Controllers/chat_conrtroller.dart';
import '../Controllers/contants.dart';

class ChatScreen extends StatefulWidget {
  final String chatroomID;

  final String title;
  final String userProfile;
  final String otherUserURl;
  final ChatController controller;
  final String myUID;
  final String fcm;
  final String myName;
  ChatScreen(
      {required this.controller,
      required this.chatroomID,
      required this.title,
      required this.userProfile,
      required this.otherUserURl,
      required this.myUID,
      required this.fcm,
      required this.myName});

  @override
  _ChatScreenState createState() => _ChatScreenState(myUID);
}

class _ChatScreenState extends State<ChatScreen> {
  final String _MyUserUuid;

  _ChatScreenState(this._MyUserUuid);
  bool isTokenLoaded = false;
  TextEditingController txtMsg = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool isMaxScroll = false;
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels > 360 && !isMaxScroll) {
        setState(() {
          isMaxScroll = true;
        });
      }
    });
  }

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
                  Positioned(
                    bottom: 80,
                    right: 28,
                    child: scrol_button(),
                  ),
                ],
              ),
            ),
          ),
          // Positioned(top: 0, child: myappbar()),
        ],
      ),
    );
  }

  Visibility scrol_button() {
    return Visibility(
      visible: isMaxScroll,
      child: GestureDetector(
        onTap: () {
          _scrollToEnd();
        },
        child: CircleAvatar(
          backgroundColor: kprimary2,
          radius: 16,
          child: Icon(
            Icons.keyboard_double_arrow_down_sharp,
            size: 20,
            color: kprimary1,
          ),
          // width: 36,
          // height: 36,
          // padding: const EdgeInsets.all(8),
          // decoration: BoxDecoration(color: kprimary2, boxShadow: [
          //   BoxShadow(
          //       color: Colors.grey.shade300,
          //       blurRadius: 6,
          //       offset: const Offset(0, 2))
          // ]),
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
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.grey.shade800,
                      size: 22,
                    ))),
            Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Text(widget.title.toUpperCase(),
                    style: TextStyle(
                        color: kprimary5,
                        fontSize: 18,
                        fontWeight: FontWeight.w700))),
            ProfilePic(widget.otherUserURl, size: 30),
          ],
        ),
      ),
    );
  }

  double paddingAnimation = 8;
  bool showSendButton = false;
  double containerHeight = 34;
  double containerWidth = 34;

  Widget chatMessages() {
    return GetX<ChatController>(
        init: widget.controller,
        builder: (controller) {
          if (controller.chats.isEmpty) {
            return Center(
                child: Text(
              "No Chats yet!",
              style: myStyle(16, true, color: Colors.grey),
            ));
          } else {
            return AnimatedContainer(
              padding: EdgeInsets.only(
                  left: paddingAnimation, right: paddingAnimation, bottom: 15),
              duration: const Duration(seconds: 1, milliseconds: 200),
              child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.only(bottom: 60, top: 8),
                  itemCount: controller.chats.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    MessageModel model = controller.chats[index];

                    return Column(
                      children: [
                        correspondingTypeAllocation(model),
                        if (index != 0 &&
                            model.timestamp.toDate().day !=
                                controller.chats[index - 1].timestamp
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
                                    .chats[index - 1].timestamp
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

    bool isMine = (msg.sendBy == _MyUserUuid) ? true : false;

    Timestamp timestamp = msg.timestamp;
    DateTime msgDate =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);

    String url = !isMine ? widget.otherUserURl : widget.userProfile;

    if (code == "MSG") {
      return MessageBubble(isMine, msg.message, url, msgDate);
    } else if (code == "IMG") {
      return ImageBubble(isMine, msg.message, url, msgDate);
    }
    return Container(
      width: 20,
    );
  }

  addMesage(bool sendClicked) async {
    if (txtMsg.text != "") {
      String message = txtMsg.text.trim();
      var lastmsgTimeStamp = Timestamp.now();
      Map<String, dynamic> msginfoMap = {
        "message": message,
        "sendBy": _MyUserUuid,
        "CODE": "MSG",
        "timestamp": lastmsgTimeStamp,
      };
      widget.controller.addMessageSend(msginfoMap, widget.fcm, widget.myName);

      if (sendClicked) {
        setState(() {
          txtMsg.text = "";
          showSendButton = false;
          _scrollToEnd();
        });
      }
    }
  }

  _scrollToEnd() {
    scrollController
        .animateTo(scrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 600),
            curve: Curves.decelerate)
        .then((value) {
      setState(() {
        isMaxScroll = false;
      });
    });
  }

  addImage(File image) async {
    String name =
        _MyUserUuid + Timestamp.now().millisecondsSinceEpoch.toString();
    String aaddress =
        await widget.controller.uploadFile(image, "ApptexChat/$name.jpg");

    var lastmsgTimeStamp = Timestamp.now();
    Map<String, dynamic> msginfoMap = {
      "message": aaddress,
      "sendBy": _MyUserUuid,
      "CODE": "IMG",
      "timestamp": lastmsgTimeStamp,
    };
    widget.controller.addMessageSend(msginfoMap, widget.fcm, widget.myName);
  }

  ScrollController textFieldScrollController = ScrollController();
  static Future<File?> pickMedia_only() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 35,
    );
    if (pickedFile == null) return null;

    return File(pickedFile.path);
  }

  typingArea(Size size) {
    return Container(
      width: size.width,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(50)),
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.all(6),
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            GestureDetector(
              onTap: () async {
                File? ss = await pickMedia_only();
                if (ss != null) {
                  addImage(ss);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                  Icons.attach_file,
                  color: Colors.grey.shade600,
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
                  cursorColor: kprimary1,
                  onChanged: (val) {
                    setState(() {
                      if (val.trim().isEmpty) {
                        paddingAnimation = 8;
                        showSendButton = false;
                      } else {
                        paddingAnimation = 12;
                        showSendButton = true;
                      }
                    });
                  },
                  maxLines: 4,
                  minLines: 1,
                  scrollController: textFieldScrollController,
                  controller: txtMsg,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                      hintText: "Send a message..",
                      hintStyle: TextStyle(
                          color: Colors.grey.shade600.withOpacity(0.7)),
                      border: InputBorder.none),
                ),
              ),
            ),
            showSendButton
                ? GestureDetector(
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
                : GestureDetector(
                    onLongPress: () {
                      setState(() {
                        containerHeight = 50;
                        containerWidth = 50;
                      });
                    },
                    onLongPressCancel: () {
                      setState(() {
                        containerHeight = 34;
                        containerWidth = 34;
                      });
                    },
                    onLongPressEnd: (d) {
                      //TODO send message
                      setState(() {
                        containerHeight = 34;
                        containerWidth = 34;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(
                        milliseconds: 300,
                      ),
                      padding: const EdgeInsets.all(5),
                      height: containerHeight,
                      width: containerWidth,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kprimary1,
                      ),
                      child: const Icon(
                        Icons.mic,
                        color: Colors.white,
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final bool isMine;
  final String message;
  final String profileUrl;
  final DateTime msgDate;
  const MessageBubble(this.isMine, this.message, this.profileUrl, this.msgDate,
      {Key? key})
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
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
            child: Text(
              message,
              style: TextStyle(
                  color: isMine ? kWhite : Colors.grey.shade800,
                  fontWeight: FontWeight.w500,
                  fontSize: 13),
            ),
          )),
          //  if (isMine) ProfilePic(profileUrl, size: 30),
          //if (isMine) Container(width: 3),
          if (!isMine) getdate(msgDate),
        ]);
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

class ImageBubble extends StatelessWidget {
  final bool isMine;
  final String message;
  final String profileUrl;
  final DateTime msgDate;
  const ImageBubble(this.isMine, this.message, this.profileUrl, this.msgDate,
      {Key? key})
      : super(key: key);

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

// ignore: must_be_immutable
class ProfilePic extends StatelessWidget {
  ProfilePic(this.url, {this.size = 48, Key? key}) : super(key: key);
  String url;

  final double size;
  @override
  Widget build(BuildContext context) {
    url = url.length <= 7 ? "" : url;
    bool isNotUrl = url.length <= 7;

    double imsix = size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: isNotUrl
          ? Container(
              color: kprimary1,
              width: imsix,
              height: imsix,
              child: const Icon(
                Icons.person,
                size: 20,
              ))
          : Container(
              width: imsix,
              height: imsix,
              color: Colors.grey.shade300,
              child: Image(
                image: NetworkImage(
                  url,
                ),
                alignment: Alignment.center,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}
