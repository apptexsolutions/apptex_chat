import 'package:apptex_chat/apptex_chat.dart';
import 'package:apptex_chat/src/Controllers/messages_controller.dart';
import 'package:apptex_chat/src/Models/ChatModel.dart';
import 'package:apptex_chat/src/Models/UserModel.dart';
import 'package:apptex_chat/src/Screens/chat_screen.dart';
import 'package:flutter/material.dart';

import '../Controllers/contants.dart';

// ignore: must_be_immutable
class MyChats extends StatelessWidget {
  MessagesController controler;
  MyChats(this.controler, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kWhite,
      appBar: myappbar(size, context),
      body: Column(
        children: [
          typingArea(size),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
                itemCount: controler.messags.length,
                reverse: false,
                itemBuilder: (context, index) {
                  if (controler.messags
                      .where((p0) => p0.lastMessage != null)
                      .isEmpty) {
                    return Center(
                        child: Text(
                      "No messages yet!",
                      style: myStyle(15, true, color: Colors.grey),
                    ));
                  } else {
                    ChatModel model = controler.messags[index];
                    UserModel other = model.users.firstWhere(
                        (element) => element.uid != controler.myuuid);
                    return model.lastMessage == null
                        ? Container()
                        : chat_tile(context, other, size, model);
                  }
                }),
          )
        ],
      ),
    );
  }

  Widget chat_tile(
      BuildContext context, UserModel other, Size size, ChatModel model) {
    return InkWell(
      onTap: () {
        AppTexChat.Start_Chat_With(context,
            receiver_name: other.name,
            receiver_id: other.uid,
            receiver_profileUrl: other.profileUrl);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        width: 70,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ProfilePic(
                other.profileUrl,
                size: 55,
                radius: 15,
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 1),
                    child: Text(
                      other.name,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade900),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    child: Text(
                      model.lastMessage!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade500),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 1),
                      child: Text(
                        "",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade900),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  typingArea(Size size) {
    return Container(
      width: size.width,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(50)),
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  cursorColor: kprimary1,
                  onChanged: (val) {},
                  maxLines: 1,
                  minLines: 1,
                  // scrollController: chatController.textFieldScrollController,
                  //controller: chatController.txtMsg,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: TextStyle(
                          color: Colors.grey.shade600.withOpacity(0.7)),
                      border: InputBorder.none),
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade400,
                ),
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            )
          ],
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
          mainAxisAlignment: MainAxisAlignment.start,
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
                      Icons.arrow_back_ios_new_sharp,
                      color: Colors.grey.shade800,
                      size: 20,
                    ))),
            Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Text("Messages",
                    style: TextStyle(
                        color: kprimary5,
                        fontSize: 24,
                        fontWeight: FontWeight.w700))),
          ],
        ),
      ),
    );
  }
}
