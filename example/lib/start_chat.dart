import 'package:apptex_chat/apptex_chat.dart';
import 'package:example/custom_button_square.dart';
import 'package:example/login.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';

class StartChat extends StatelessWidget {
  final UserModel myUser;

  StartChat(this.myUser);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: 200,
              width: 200,
              color: Colors.grey.shade100,
              child: Image.network(myUser.url)),
          const SizedBox(height: 29),
          Center(
            child: CustomButtonSquare(
              onTap: () {
                //this required two uuids..
                //current User uuid, and where you want to chat with.

                UserModel other =
                    users.firstWhere((element) => element.uuid != myUser.uuid);
                AppTexChat.instance.Start_Chat_With(context,
                    receiver_name: other.name,
                    receiver_id: other.uuid,
                    receiver_profileUrl: other.url);
              },
              buttonColor: Colors.green,
              buttonName: 'Initiate Chat between User A and B',
              width: size.width * 0.8,
            ),
          ),
          const SizedBox(height: 29),
          Center(
            child: CustomButtonSquare(
              onTap: () {
                AppTexChat.instance.OpenMessages(context);
              },
              buttonColor: Colors.green,
              buttonName: 'Open all of my Chats',
              width: size.width * 0.8,
            ),
          ),
          const SizedBox(height: 29),
          Center(
            child: CustomButtonSquare(
              onTap: () {
                AppTexChat.instance.OpenMessages(context);
              },
              buttonColor: Colors.green,
              buttonName: 'Return My Chats in a Widget',
              width: size.width * 0.8,
            ),
          )
        ],
      ),
    );
  }
}
