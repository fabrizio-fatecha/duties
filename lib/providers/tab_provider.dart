import 'package:flutter/foundation.dart';

class TabProvider extends ChangeNotifier {
  int currentIndex = 0;

  void setIndex(int index) {
    if (currentIndex == index) return;
    currentIndex = index;
    notifyListeners();
  }

  void goToSearch() => setIndex(0);
}
