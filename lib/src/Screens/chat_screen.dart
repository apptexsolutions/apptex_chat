// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, no_logic_in_create_state, non_constant_identifier_names

import 'dart:io';
import 'package:apptex_chat/src/Models/ChatModel.dart';
import 'package:apptex_chat/src/Models/MessageModel.dart';
import 'package:apptex_chat/src/Screens/full_screen_image.dart';
import 'package:apptex_chat/src/Widgets/custom_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/chat_conrtroller.dart';
import '../Controllers/contants.dart';

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

  scrol_button() {
    return Obx(
      () => Visibility(
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
                  padding: const EdgeInsets.only(bottom: 60, top: 8),
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
          key: UniqueKey(),
          isRightSwipe: !isMine,
          onRightSwipe: (details) {
            chatController.focusNode.requestFocus();
            chatController.replyMessage(msg.uid);
          },
          onLeftSwipe: (details) {
            chatController.focusNode.requestFocus();
            chatController.replyMessage(msg.uid);
          },
          onHold: () {},
          child: MessageBubble(
            isMine: isMine,
            model: msg,
            profileUrl: url,
            msgDate: msgDate,
            chatController: chatController,
            myID: myUID,
            title: title,
          ));
    } else if (code == "IMG") {
      return ImageBubble(isMine, msg.message, url, msgDate);
    }
    return Container(
      width: 20,
    );
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
    String name = myUID + Timestamp.now().millisecondsSinceEpoch.toString();
    String aaddress =
        await chatController.uploadFile(image, "ApptexChat/$name.jpg");

    var lastmsgTimeStamp = Timestamp.now();
    Map<String, dynamic> msginfoMap = {
      "message": aaddress,
      "sendBy": myUID,
      "CODE": "IMG",
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
                                    ? "Recording..."
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
        Obx(
          () => chatController.showSendButton.value == false
              ? Positioned(
                  right: chatController.micButtonPressed.value ? -15 : 25,
                  bottom: chatController.micButtonPressed.value ? -20 : 20,
                  child: chatController.micButtonPressed.value
                      ? GestureDetector(
                          onTap: () {
                            //TODO send voice message
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
                          onLongPress: () {
                            chatController.micButtonPressed.value = true;
                            chatController.focusNode.unfocus();
                            //TODO start recording voice message
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
              : SizedBox(),
        ),
      ],
    );
  }
}

class RepliedToWidget extends StatelessWidget {
  RepliedToWidget(
      {Key? key,
      required this.showCloseButton,
      required this.chatController,
      required this.messageId,
      required this.myID,
      required this.title,
      this.messegedByMe = true})
      : super(key: key);

  final bool showCloseButton;
  final ChatController chatController;
  final String messageId;
  final String myID;
  final String title;
  final bool messegedByMe;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print(messageId);

    MessageModel model = chatController.messages.firstWhere(
        (element) => element.uid == messageId,
        orElse: () => MessageModel());
    final bool isMine = model.sendBy == myID;

    return Container(
      width: size.width,
      margin: showCloseButton
          ? const EdgeInsets.only(top: 8.0)
          : const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: showCloseButton ? Colors.white : Colors.black26.withOpacity(0.1),
        borderRadius: showCloseButton
            ? BorderRadius.circular(12)
            : BorderRadius.circular(16),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 4,
              margin: const EdgeInsets.only(top: 4.5, bottom: 4.5, left: 4),
              decoration: BoxDecoration(
                  color: showCloseButton || !messegedByMe
                      ? kprimary1
                      : Colors.white,
                  borderRadius:
                      const BorderRadius.horizontal(left: Radius.circular(16))),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 8, top: 8, bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isMine ? 'You' : title,
                            style: TextStyle(
                                color: showCloseButton || !messegedByMe
                                    ? kprimary1
                                    : Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 13),
                          ),
                          Visibility(
                            visible: showCloseButton,
                            child: GestureDetector(
                              onTap: () {
                                chatController.replyMessage.value = null;
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.grey.shade300,
                                maxRadius: 10,
                                child: const Icon(
                                  Icons.close_rounded,
                                  size: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, bottom: 8.0),
                      child: Text(
                        model.message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: showCloseButton
                                ? Colors.grey
                                : messegedByMe
                                    ? Colors.grey.shade200
                                    : Colors.black54,
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final bool isMine;
  final MessageModel model;
  final String profileUrl;
  final DateTime msgDate;
  final ChatController chatController;
  final String myID;
  final String title;

  const MessageBubble(
      {required this.isMine,
      required this.model,
      required this.profileUrl,
      required this.msgDate,
      required this.chatController,
      Key? key,
      required this.myID,
      required this.title})
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
                  child: Text(
                    model.message,
                    style: TextStyle(
                        color: isMine ? kWhite : Colors.grey.shade800,
                        fontWeight: FontWeight.w500,
                        fontSize: 13),
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
  ProfilePic(this.url, {this.size = 48, this.radius = 100, Key? key})
      : super(key: key);
  String url;

  final double size;
  final double radius;
  @override
  Widget build(BuildContext context) {
    url = url.length <= 7 ? "" : url;
    bool isNotUrl = url.length <= 7;

    double imsix = size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
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

class SwipeToReply extends StatefulWidget {
  /// Child widget for which you want to have horizontal swipe action
  /// @required parameter
  final Widget child;

  /// Duration value to define animation duration
  /// if not passed default Duration(milliseconds: 150) will be taken
  final Duration animationDuration;

  /// Icon that will be displayed beneath child widget when swipe right
  final IconData iconOnRightSwipe;

  /// Widget that will be displayed beneath child widget when swipe right
  final Widget? rightSwipeWidget;

  /// Icon that will be displayed beneath child widget when swipe left
  final IconData iconOnLeftSwipe;

  /// Widget that will be displayed beneath child widget when swipe right
  final Widget? leftSwipeWidget;

  /// double value defining size of displayed icon beneath child widget
  /// if not specified default size 26 will be taken
  final double iconSize;

  /// color value defining color of displayed icon beneath child widget
  ///if not specified primaryColor from theme will be taken
  final Color? iconColor;

  /// Double value till which position child widget will get animate when swipe left
  /// or swipe right
  /// if not specified 0.3 default will be taken for Right Swipe &
  /// it's negative -0.3 will bve taken for Left Swipe
  final double offsetDx;

  /// bool value till which indicate whether the it is swip right or left
  /// true for right swipe while false for left
  final bool isRightSwipe;

  /// callback which will be initiated at the end of child widget animation
  /// when swiped right
  /// if not passed swipe to right will be not available
  final GestureDragEndCallback? onRightSwipe;

  /// callback which will be initiated at the end of child widget animation
  /// when swiped left
  /// if not passed swipe to left will be not available
  final GestureDragEndCallback? onLeftSwipe;

  /// callback which will be initiated when user long press or hold
  final VoidCallback? onHold;

  const SwipeToReply({
    Key? key,
    required this.child,
    required this.isRightSwipe,
    this.onRightSwipe,
    this.onLeftSwipe,
    this.onHold,
    this.iconOnRightSwipe = CupertinoIcons.arrowshape_turn_up_left_fill,
    this.rightSwipeWidget,
    this.iconOnLeftSwipe = CupertinoIcons.arrowshape_turn_up_right_fill,
    this.leftSwipeWidget,
    this.iconSize = 22.0,
    this.iconColor = Colors.grey,
    this.animationDuration = const Duration(milliseconds: 130),
    this.offsetDx = 0.2,
  }) : super(key: key);

  @override
  _SwipeToReplyState createState() => _SwipeToReplyState();
}

class _SwipeToReplyState extends State<SwipeToReply>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late Animation<double> _leftIconAnimation;
  late Animation<double> _rightIconAnimation;
  late GestureDragEndCallback _onSwipeLeft;
  late GestureDragEndCallback _onSwipeRight;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _animation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(curve: Curves.decelerate, parent: _controller),
    );
    _leftIconAnimation = _controller.drive(
      Tween<double>(begin: 0.0, end: 0.0),
    );
    _rightIconAnimation = _controller.drive(
      Tween<double>(begin: 0.0, end: 0.0),
    );
    _onSwipeLeft = widget.onLeftSwipe ??
        (details) {
          throw ("Left Swipe Not Provided");
        };

    _onSwipeRight = widget.onRightSwipe ??
        (details) {
          throw ("Left Swipe Not Provided");
        };
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  ///Run animation for child widget
  ///[onRight] value defines animation Offset direction
  void _runAnimation() {
    //set child animation

    _animation = Tween(
      begin: const Offset(0.0, 0.0),
      end:
          Offset(widget.isRightSwipe ? widget.offsetDx : -widget.offsetDx, 0.0),
    ).animate(
      CurvedAnimation(curve: Curves.decelerate, parent: _controller),
    );
    //set back left/right icon animation
    if (widget.isRightSwipe) {
      _leftIconAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(curve: Curves.decelerate, parent: _controller),
      );
      _rightIconAnimation = Tween(begin: 0.0, end: 0.0).animate(
        CurvedAnimation(curve: Curves.decelerate, parent: _controller),
      );
    } else {
      _rightIconAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(curve: Curves.decelerate, parent: _controller),
      );
      _leftIconAnimation = Tween(begin: 0.0, end: 0.0).animate(
        CurvedAnimation(curve: Curves.decelerate, parent: _controller),
      );
    }
    //Forward animation
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: widget.onHold,
      onHorizontalDragEnd: ((details) {
        _controller.reverse().whenComplete(() {
          if (widget.isRightSwipe) {
            //keep left icon visibility to 0.0 until onRightSwipe triggers again
            // _leftIconAnimation = _controller.drive(Tween(begin: 0.0, end: 0.0));
            _onSwipeRight(details);
          } else {
            //keep right icon visibility to 0.0 until onLeftSwipe triggers again
            // _rightIconAnimation = _controller.drive(Tween(begin: 0.0, end: 0.0));

            _onSwipeLeft(details);
          }
        });
      }),
      onHorizontalDragStart: (details) {
        if (widget.isRightSwipe) {
          if (details.localPosition.dx > 2) {
            _runAnimation();
          }
        } else {
          if (details.localPosition.dx > -2) {
            _runAnimation();
          }
        }
      },
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.passthrough,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              AnimatedOpacity(
                opacity: _leftIconAnimation.value,
                duration: widget.animationDuration,
                curve: Curves.decelerate,
                child: widget.rightSwipeWidget ??
                    Icon(
                      widget.iconOnRightSwipe,
                      size: widget.iconSize,
                      color:
                          widget.iconColor ?? Theme.of(context).iconTheme.color,
                    ),
              ),
              AnimatedOpacity(
                opacity: _rightIconAnimation.value,
                duration: widget.animationDuration,
                curve: Curves.decelerate,
                child: widget.leftSwipeWidget ??
                    Icon(
                      widget.iconOnLeftSwipe,
                      size: widget.iconSize,
                      color:
                          widget.iconColor ?? Theme.of(context).iconTheme.color,
                    ),
              ),
            ],
          ),
          SlideTransition(
            position: _animation,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
