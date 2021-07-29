// AppPurchase
import 'dart:async';
import 'package:bloc/bloc.dart';

class AppPurchase extends Bloc<AppPurchaseEvent, AppPurchaseState> {
  AppPurchase() : super(AppPurchaseCurrentStatus());

  bool _isAppPurchase = false;

  bool get isAppPurchase => _isAppPurchase;

  @override
  Stream<AppPurchaseState> mapEventToState(AppPurchaseEvent event) async* {
    if (event is AppPurchaseChangeStatus) _isAppPurchase = event.status;
    yield AppPurchaseCurrentStatus(status: _isAppPurchase);
    return;
  }
}

abstract class AppPurchaseState {}

class AppPurchaseCurrentStatus extends AppPurchaseState {
  AppPurchaseCurrentStatus({this.status = false});

  bool status;
}

abstract class AppPurchaseEvent {}

class AppPurchaseChangeStatus extends AppPurchaseEvent {
  AppPurchaseChangeStatus({this.status = false});

  bool status;
}
