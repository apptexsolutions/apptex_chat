import 'package:apptex_chat/apptex_chat.dart';
import 'package:example/custom_button_square.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    AppTexChat.instance.initChat(
        currentUser: ChatUserModel(
            uid: 'cuid', profileUrl: '', name: 'Current User', fcmToken: ''));

    return Scaffold(
      body: SizedBox(
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomButtonSquare(
                buttonColor: Colors.blue,
                buttonName: "Login as User A",
                textColor: Colors.white,
                onTap: () async {
                  final model = await AppTexChat.instance
                      .startNewConversationWith(ChatUserModel(
                          uid: 'otherid',
                          profileUrl: '',
                          name: 'Other User',
                          fcmToken: ''));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomeChatScreen(model)));
                }),
            SizedBox(height: 50),
            CustomButtonSquare(
                buttonColor: Colors.blue,
                buttonName: "Open Inbox",
                textColor: Colors.white,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => InboxScreen()));
                }),
          ],
        ),
      ),
    );
  }
}

class CustomeChatScreen extends StatelessWidget {
  final ConversationModel model;
  const CustomeChatScreen(this.model);

  @override
  Widget build(BuildContext context) {
    return ChatScreen(
      conversationModel: model,
      appBarBuilder: ((currentUser, otherUser) => AppBar()),
      typingWidget: InkWell(
        onTap: () {
          AppTexChat.instance.sendTextMessage(
              DateTime.now().microsecondsSinceEpoch.toString());
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 32, left: 32),
          child: Text('Add Test Message'),
        ),
      ),
      bubbleBuilder: (model, currentUser, otherUser, isMine) {
        final code = model.code;
        if (code == 'TXT')
          return MessageBubble(
              isMine: isMine,
              model: model,
              currentUser: currentUser,
              otherUSer: otherUser);
        else if (code == 'IMG')
          return ImageBubble(
              isMine: isMine,
              model: model,
              currentUser: currentUser,
              otherUSer: otherUser);
        else
          return Container();
      },
    );
  }
}

class InboxScreen extends StatelessWidget {
  const InboxScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            InkWell(
                onTap: () async {
                  AppTexChat.instance.sendTextMessage("asda");
                },
                child: Container(
                  child: Text(
                    "Button",
                  ),
                  color: Colors.red,
                  padding: EdgeInsets.all(10),
                )),
            Expanded(
              child: ConversationsScreen(
                builder: (conversations, isLoading) => ListView.builder(
                    shrinkWrap: true,
                    itemCount: conversations.length,
                    itemBuilder: (context, index) => Container(
                        child: Text(conversations[index].getOtherUser.name))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
