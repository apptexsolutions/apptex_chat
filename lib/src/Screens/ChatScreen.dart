// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, no_logic_in_create_state

import 'dart:io';

import 'package:apptex_chat/src/Models/MessageModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/chat_conrtroller.dart';
import '../Controllers/contants.dart';

class ChatScreen extends StatefulWidget {
  final String chatroomID;
  final bool isSessionActive;
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
      required this.isSessionActive,
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Column(
            children: [
              myappbar(),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                  ),
                  child: Stack(
                    children: [
                      chatMessages(),
                      if (widget.isSessionActive) typingArea(),
                      if (!widget.isSessionActive) sessionClosedMessage(size)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Positioned sessionClosedMessage(Size size) {
    return Positioned(
      bottom: 0,
      child: SizedBox(
        height: 40,
        width: size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "This sessions has been closed!",
              style: myStyle(14, false, color: Colors.grey.shade700),
            )
          ],
        ),
      ),
    );
  }

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
            return ListView.builder(
                padding: const EdgeInsets.only(bottom: 60, top: 8),
                itemCount: controller.chats.length,
                reverse: true,
                itemBuilder: (context, index) {
                  MessageModel model = controller.chats[index];
                  return correspondingTypeAllocation(model);
                });
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
      String message = txtMsg.text;
      var lastmsgTimeStamp = Timestamp.now();
      Map<String, dynamic> msginfoMap = {
        "message": message,
        "sendBy": _MyUserUuid,
        "CODE": "MSG",
        "timestamp": lastmsgTimeStamp,
      };
      widget.controller.addMessageSend(msginfoMap, widget.fcm, widget.myName);

      if (sendClicked) {
        txtMsg.text = "";
      }
    }
  }

  addImage(File image) async {
    // AuthController authController = Get.find();
    // String name = Timestamp.now().millisecondsSinceEpoch.toString();
    // String aaddress = await authController.uploadFile(image, "Chats/$name.jpg");

    // var lastmsgTimeStamp = Timestamp.now();
    // Map<String, dynamic> msginfoMap = {
    //   "message": aaddress,
    //   "sendBy": _MyUserUuid,
    //   "CODE": "IMG",
    //   "timestamp": lastmsgTimeStamp,
    // };
    // widget.controller.addMessageSend(msginfoMap, widget.fcm, widget.myName);
  }

  myappbar() {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      color: Colors.white24,
      height: 52,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(3)),
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ),
          Center(
            child: Text(widget.title,
                style: myStyle(16, true, color: Colors.grey.shade800)),
          ),
          const SizedBox(
            width: 50,
          )
        ],
      ),
    );
  }

  typingArea() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              // File? ss = await ImageController.pickMedia_only();
              // if (ss != null) {
              //   addImage(ss);
              // }
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
              child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              color: Colors.grey[350],
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
              child: TextField(
                onChanged: (val) {
                  //  addMesage(false);
                },
                controller: txtMsg,
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                    hintText: "Send a message..",
                    hintStyle:
                        TextStyle(color: Colors.grey.shade600.withOpacity(0.7)),
                    border: InputBorder.none),
              ),
            ),
          )),
          GestureDetector(
            onTap: () {
              addMesage(true);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Icon(
                Icons.send,
                color: Colors.grey.shade600,
                size: 27,
              ),
            ),
          )
        ],
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
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMine) Container(width: 3),
          if (!isMine) ProfilePic(profileUrl, size: 30),
          IntrinsicWidth(
              child: Column(
            crossAxisAlignment:
                isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                    minWidth: 50,
                    maxWidth: MediaQuery.of(context).size.width / 1.3),
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
                decoration: BoxDecoration(
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
                child: Text(
                  message,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
              ),
              getdate()
            ],
          )),
          if (isMine) ProfilePic(profileUrl, size: 30),
          if (isMine) Container(width: 3),
        ]);
  }

  getdate() {
    String date = getChatDate(msgDate);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        date,
        style: myStyle(12, false, color: Colors.grey.shade600),
      ),
    );
  }
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
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMine) Container(width: 3),
          if (!isMine) ProfilePic(profileUrl, size: 30),
          IntrinsicWidth(
              child: Column(
            crossAxisAlignment:
                isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                  constraints: BoxConstraints(
                      minWidth: 50,
                      maxWidth: MediaQuery.of(context).size.width / 1.3),
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  padding:
                      const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
                  decoration: BoxDecoration(
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
                  child: Container(
                    color: Colors.grey.shade300,
                    child: Image(image: NetworkImage(message)),
                  )),
              getdate()
            ],
          )),
          if (isMine) ProfilePic(profileUrl, size: 30),
          if (isMine) Container(width: 3),
        ]);
  }

  getdate() {
    String date = getChatDate(msgDate);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        date,
        style: myStyle(12, false, color: Colors.grey.shade600),
      ),
    );
  }
}

class ProfilePic extends StatelessWidget {
  const ProfilePic(this.url, {this.size = 48, Key? key}) : super(key: key);
  final String url;
  final double size;
  @override
  Widget build(BuildContext context) {
    double imsix = size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Container(
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
