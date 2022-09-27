import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
String roomCollection = "Chatrooms";
String chatMessagesCollection = "Messages";

Color get kprimary1 => hexStringToColor("0B7592");
Color get kprimary2 => hexStringToColor("f69c26");
Color get kbackground => hexStringToColor("0F97BE");

Color hexStringToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  return Color(int.parse(hexColor, radix: 16));
}

TextStyle myStyle(double size, bool isBold, {Color color = Colors.black}) {
  return TextStyle(
      fontSize: size,
      fontWeight: (isBold) ? FontWeight.bold : FontWeight.normal,
      color: color);
}

String formatDate(DateTime date) {
  return "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}  ";
}

getChatDate(DateTime msgDate) {
  String date = "";

  if (msgDate.year == DateTime.now().year &&
      msgDate.month == DateTime.now().month &&
      msgDate.day == DateTime.now().day) {
    int hour = msgDate.hour > 12 ? msgDate.hour - 12 : msgDate.hour;
    String amCode = msgDate.hour > 12 ? "PM" : "AM";
    date = "$hour:${msgDate.minute} $amCode";
  } else {
    List months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    date = msgDate.day.toString() +
        "-" +
        months[msgDate.month -
            1]; //          " ${msgDate.hour}:${msgDate.minute}";
  }

  return date;
}
