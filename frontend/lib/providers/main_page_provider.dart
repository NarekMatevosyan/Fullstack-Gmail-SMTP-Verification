import 'package:flutter/cupertino.dart';

class MainPageProvider extends ChangeNotifier {
  int selectedPage = 0;
  int otherPage = 0;


  changeTab(int index) {
    if (index > 3) {
     otherPage = index;
    } else {
      otherPage = 0;
      selectedPage = index;
    }
    notifyListeners();
  }
}
