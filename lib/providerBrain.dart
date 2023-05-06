import 'package:flutter/material.dart';

class MyData extends ChangeNotifier {
  bool isChanged = false;
  bool validName = false;
  bool validCredit = false;
  bool validGrade = false;
  bool savaData = false;
  //setTheValuesOFTextFiled
  bool setValues = true;
  void change(bool value) {
    isChanged = value;
    notifyListeners();
  }

// to save data
  void changeSaveData(bool value) {
    savaData = value;
    notifyListeners();
  }

  void changeSetValues(bool value) {
    setValues = value;
    notifyListeners();
  }

  void stateOfName(bool nameState) {
    validName = nameState;
    notifyListeners();
  }

  void stateOfCredit(bool creditState) {
    validCredit = creditState;
    notifyListeners();
  }

  void stateOfGrade(bool gradeState) {
    validGrade = gradeState;
    notifyListeners();
  }
}
