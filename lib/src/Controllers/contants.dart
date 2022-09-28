import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
String roomCollection = "Chatrooms";
String chatMessagesCollection = "Messages";
const Map<int, String> weekdayName = {
  1: "Monday",
  2: "Tuesday",
  3: "Wednesday",
  4: "Thursday",
  5: "Friday",
  6: "Saturday",
  7: "Sunday"
};

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

//print(weekdayName[DateTime.now().weekday]);
Color get kprimary1 => hexStringToColor("dc5b5f"); // main
Color get kprimary2 => hexStringToColor("e8eaed"); // grey Bubble
Color get kprimary3 => hexStringToColor("d0d9e3"); // grey time
Color get kprimary4 => hexStringToColor("525EFF");
Color get kprimary5 => hexStringToColor("142f58"); // used for heading
Color get kWhite => hexStringToColor("ffffff");

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

String getMessageReferecneTime(DateTime date) {
  //return weekdayName[date.weekday].toString();
  var now = DateTime.now();
  int days = daysBetween(date, now);

  if (days < 1) {
    return "Today";
  } else if (days < 2) {
    return "Yesterday";
  } else if (days <= 7) {
    return weekdayName[date.weekday].toString();
  } else {
    String sdate = months[date.month - 1] +
        " " +
        date.day.toString() +
        ", " +
        date.year.toString(); //
    return sdate;
  }
}

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

getChatDate(DateTime msgDate) {
  String date = "";

  if (msgDate.year == DateTime.now().year &&
      msgDate.month == DateTime.now().month &&
      msgDate.day == DateTime.now().day) {
    int hour = msgDate.hour > 12 ? msgDate.hour - 12 : msgDate.hour;

    String amCode = msgDate.hour >= 12 ? "PM" : "AM";
    date =
        "${hour < 10 ? '0$hour' : hour}:${msgDate.minute < 10 ? "0${msgDate.minute}" : msgDate.minute} $amCode";
  } else {
    date = msgDate.day.toString() + "-" + months[msgDate.month - 1];
  }

  return date;
}
