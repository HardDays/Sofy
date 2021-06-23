import 'package:flutter/foundation.dart';


class User extends ChangeNotifier {

  bool isAuth = false;

  void updateIsAuth({bool flag, bool notify = true}) {
    isAuth = flag;
    if (notify) notifyListeners();
  }

}