import 'package:flutter/cupertino.dart';

class dataProvider extends ChangeNotifier {
  int total  = 0;

  void add(){
    total++;
    notifyListeners();
  }

  void sub(){
    total--;
    notifyListeners();
  }

  String getData(){
    return total.toString();
  }

  @override
  void notifyListeners() {
      super.notifyListeners();
  }
}