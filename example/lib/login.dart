import 'package:apptex_chat/apptex_chat.dart';
import 'package:example/chat_screen.dart';
import 'package:example/custom_button_square.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var appTexChat = AppTexChat.instance;

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
                  appTexChat.initChat(
                    currentUser: ChatUserModel(
                      uid: '1',
                      profileUrl:
                          'https://avatars.githubusercontent.com/u/63047096?v=4',
                      name: 'Shah Raza',
                      fcmToken: '',
                    ),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InboxScreen(),
                    ),
                  );
                }),
            SizedBox(height: 50),
            CustomButtonSquare(
              buttonColor: Colors.blue,
              buttonName: "Login as User B",
              textColor: Colors.white,
              onTap: () async {
                appTexChat.initChat(
                  currentUser: ChatUserModel(
                    uid: '2',
                    profileUrl:
                        'https://avatars.githubusercontent.com/u/38852291?v=4',
                    name: 'Idrees',
                    fcmToken: '',
                  ),
                );
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => InboxScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class InboxScreen extends StatelessWidget {
  const InboxScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Start chat with new user'),
        onPressed: () async {
          String uid = AppTexChat.instance.currentUser.uid == "1" ? "2" : "1";
          final model = await AppTexChat.instance.startNewConversationWith(
            ChatUserModel(
              uid: uid,
              profileUrl: '',
              name: 'New User Name',
              fcmToken: '',
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CustomChatScreen(model),
            ),
          );
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ConversationsScreen(
                builder: (conversations, isLoading) => ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 20),
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  itemCount: conversations.length,
                  itemBuilder: (context, index) => Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 1))
                        ]),
                    padding: EdgeInsets.all(10),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomChatScreen(
                              conversations[index],
                            ),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            conversations[index].otherUser.profileUrl ?? ''),
                      ),
                      title: Text(conversations[index].otherUser.name),
                      subtitle: Text(conversations[index].lastMessage),
                      trailing: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          conversations[index].unreadMessageCount.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
