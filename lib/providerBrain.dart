import 'package:flutter/material.dart';

class MyData extends ChangeNotifier {
  bool isChanged = false;

  void change(bool value) {
    isChanged = value;
    notifyListeners();
  }
}
