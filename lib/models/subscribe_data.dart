import 'package:flutter/foundation.dart';

class SubscribeData extends ChangeNotifier {

  bool _isAppPurchase = false;

  bool get isAppPurchase => _isAppPurchase;

  void updateStatus({bool status}) {
    _isAppPurchase = status;
    notifyListeners();
  }

}
