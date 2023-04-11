import 'package:flutter/material.dart';


///
/// [BaseViewModel] is the base class with all
/// state related logic.
///
/// [BaseViewModel] class will be extended by all viewModels.
///
/// [setState] will be used to update the state of the screen
///
class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.idle;

  ViewState get state => _state;

  void setState(ViewState state) {
    _state = state;
    notifyListeners();
  }
}
enum ViewState {
  idle,
  busy,
  loading,
}
