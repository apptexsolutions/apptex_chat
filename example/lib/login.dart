import 'package:apptex_chat/apptex_chat.dart';
import 'package:example/custom_button_square.dart';
import 'package:example/main.dart';
import 'package:example/start_chat.dart';
import 'package:flutter/material.dart';

final List<UserModel> users = [
  UserModel(
      name: "Sayed Idrees",
      uuid: "11111111",
      url: "https://avatars.githubusercontent.com/u/38852291?v=4"),
  UserModel(
      name: "Shah Raza",
      uuid: "22222222",
      url: "https://avatars.githubusercontent.com/u/63047096?v=4"),
];

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
                onTap: () {
                  AppTexChat.instance.Login_My_User(
                      FullName: users.first.name,
                      your_uuid: users.first.uuid,
                      profileUrl: users.first.url);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StartChat(users.first)));
                }),
            SizedBox(height: 50),
            CustomButtonSquare(
                buttonColor: Colors.blue,
                buttonName: "Login as User B",
                textColor: Colors.white,
                onTap: () {
                  AppTexChat.instance.Login_My_User(
                      FullName: users.last.name,
                      your_uuid: users.last.uuid,
                      profileUrl: users.last.url);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StartChat(users.last)));
                }),
          ],
        ),
      ),
    );
  }
}
