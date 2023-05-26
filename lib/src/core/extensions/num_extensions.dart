extension NumExtensions on num {
  Duration get milliseconds => Duration(microseconds: (this * 1000).round());
}
