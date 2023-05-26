import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

String getChatDate(DateTime? d) {
  final msgDate = d ?? DateTime.now();
  String date = "";

  if (msgDate.year == DateTime.now().year &&
      msgDate.month == DateTime.now().month &&
      msgDate.day == DateTime.now().day) {
    int hour = msgDate.hour > 12 ? msgDate.hour - 12 : msgDate.hour;

    String amCode = msgDate.hour >= 12 ? "PM" : "AM";
    date =
        "${hour < 10 ? '0$hour' : hour}:${msgDate.minute < 10 ? "0${msgDate.minute}" : msgDate.minute} $amCode";
  } else {
    date = (msgDate.day < 10 ? '0${msgDate.day}' : msgDate.day.toString()) +
        "-" +
        months[msgDate.month - 1];
  }

  return date;
}

String dateFormat({required DateTime dateTime, required String formate}) {
  return DateFormat(formate).format(dateTime);
}

String getFormatedDayAndTime(Timestamp x) {
  final now = DateTime.now();
  final date = x.toDate();
  final diff = now.difference(date).inDays;
  if (diff < 1) {
    return 'Today, ' + dateFormat(dateTime: date, formate: 'hh:mm a');
  } else if (diff == 1) {
    return 'Yesterday, ${dateFormat(dateTime: date, formate: 'hh:mm a')}';
  } else if (diff < 7) {
    return dateFormat(dateTime: date, formate: 'EEEE, ') +
        dateFormat(dateTime: date, formate: 'hh:mm a');
  } else {
    return dateFormat(dateTime: date, formate: 'dd MMM, At ') +
        dateFormat(dateTime: date, formate: 'hh:mm a');
  }
}
