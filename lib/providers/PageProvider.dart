import 'package:flutter/cupertino.dart';

class PCProvider extends ChangeNotifier {
  final PageController _pageController = PageController(initialPage: 1);
  int _pageIndex = 1;
  int _prevPageIndex = 1;

  PageController get pageController => _pageController;

  int get pageIndex => _pageIndex;

  int get prevPageIndex => _prevPageIndex;

  void animateToPage({int index}) {
    updatePrevPageIndex(index: pageIndex);
    pageController.jumpToPage(index);
  }

  void updatePageIndex({int index}) {
//    _prevPageIndex = _pageIndex;
    _pageIndex = index;
    notifyListeners();
  }

  void updatePrevPageIndex({int index}) {
    _prevPageIndex = index;
  }
}