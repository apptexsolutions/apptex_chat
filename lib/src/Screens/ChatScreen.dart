// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, no_logic_in_create_state

import 'dart:io';

import 'package:apptex_chat/src/Models/MessageModel.dart';
import 'package:apptex_chat/src/Screens/FullScreenImage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kprimary1,
      appBar: myappbar(size, context),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50))),
              height: size.height * 0.87,
              width: size.width,
              child: Stack(
                children: [
                  Positioned.fill(child: chatMessages()),
                  Positioned(
                    bottom: 0,
                    child: typingArea(size),
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

  AppBar myappbar(Size size, BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: kprimary1,
      centerTitle: false,
      automaticallyImplyLeading: false,
      title: Container(
        width: size.width,
        child: Row(
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
                ),
              ),
            ),
            ProfilePic(
              widget.myUID,
              size: 40,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Text(widget.title,
                      style: TextStyle(
                          color: kprimary2,
                          fontSize: 17,
                          fontWeight: FontWeight.w600)),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: const Text(
                    "",
                    style: TextStyle(
                        color: Color.fromARGB(255, 89, 108, 149),
                        fontSize: 13,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  double paddingAnimation = 24;
  bool showSendButton = false;

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
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Text(
                              controller.chats[index - 1].timestamp
                                  .toDate()
                                  .toString()
                                  .split(" ")[0],
                              style: TextStyle(
                                color: Colors.grey[600],
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      alignment: Alignment.bottomCenter,
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
              padding: const EdgeInsets.only(
                left: 15,
                top: 2,
                bottom: 2,
              ),
              margin: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[350],
              ),
              child: TextField(
                onChanged: (val) {
                  //  addMesage(false);

                  setState(() {
                    if (val.length == 0) {
                      paddingAnimation = 24;
                      showSendButton = false;
                    } else {
                      paddingAnimation = 15;
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
                    suffixIcon: showSendButton
                        ? GestureDetector(
                            onTap: () {
                              addMesage(true);
                            },
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: kprimary1,
                              ),
                              child: const Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 27,
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              //TODO send Audio Message
                            },
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: kprimary1,
                              ),
                              child: const Icon(
                                Icons.mic,
                                color: Colors.white,
                                size: 27,
                              ),
                            ),
                          ),
                    hintStyle:
                        TextStyle(color: Colors.grey.shade600.withOpacity(0.7)),
                    border: InputBorder.none),
              ),
            ),
          ),
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
    double radius = 34;
    return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (isMine) getdate(msgDate),
          if (!isMine) Container(width: 3),
          if (!isMine) ProfilePic(profileUrl, size: 30),
          IntrinsicWidth(
              child: Container(
            constraints: BoxConstraints(
                minWidth: 50,
                maxWidth: MediaQuery.of(context).size.width * 0.6),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            //padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),

            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isMine ? Colors.grey.shade200 : kprimary2,
              borderRadius: BorderRadius.only(
                topLeft:
                    isMine ? Radius.circular(radius) : const Radius.circular(0),
                bottomLeft:
                    isMine ? Radius.circular(radius) : Radius.circular(radius),
                bottomRight:
                    isMine ? Radius.circular(radius) : Radius.circular(radius),
                topRight:
                    isMine ? const Radius.circular(0) : Radius.circular(radius),
              ),
            ),
            child: Text(
              message,
              style: TextStyle(
                  color: Colors.grey.shade800,
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

class ProfilePic extends StatelessWidget {
  ProfilePic(this.url, {this.size = 48, Key? key}) : super(key: key);
  String url;

  final double size;
  @override
  Widget build(BuildContext context) {
    url = url.length <= 7 ? "https://skysoltech.com/test.png" : url;
    bool isNotUrl = url.length <= 7;

    double imsix = size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: !isNotUrl
          ? Container(
              color: kprimary1,
              width: imsix,
              height: imsix,
              padding: const EdgeInsets.all(7),
              child: Image(
                image: NetworkImage(
                  url,
                ),
                alignment: Alignment.center,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
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
