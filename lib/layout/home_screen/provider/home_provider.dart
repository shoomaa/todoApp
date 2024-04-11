import 'package:flutter/material.dart';

import '../../../model/task.dart';

class HomeProvider extends ChangeNotifier {
  int currentNavIndex=0;

  changeTab(int newIndex){
    if(currentNavIndex==newIndex)return;
    currentNavIndex=newIndex;
    notifyListeners();
  }
  DateTime? selectedDate;

 void selectedNewDate(   DateTime?  NewSelected){
    selectedDate=NewSelected;
    notifyListeners();
 }

  String? TaskID;
  void changetaskID(   String?  NewTask){
    TaskID=NewTask;
    notifyListeners();
  }


}