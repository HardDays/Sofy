import 'dart:async';
import 'package:qonversion_flutter/qonversion_flutter.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:uuid/uuid.dart';

class StoreHelperQonversion {
  static final StoreHelperQonversion instance = StoreHelperQonversion();
  QLaunchResult _qLaunchResult;

  Future<void> initPlatformState() async {
    _qLaunchResult = await Qonversion.launch(
      kQonversionSdkApiKey,
      isObserveMode: false,
    );
    Qonversion.setUserId(Uuid().v1());
  }

  Future<bool> makePurchased(String key) async {
    await initPlatformState();
    try {
      if (key == annual_purchase_key) {
        key = 'sofy.notrial.annual';
      } else {
        key = 'sofy.notrial.weekly';
      }
      await Qonversion.purchase(key);

      var annual = await isCheckSubscribed(annual_purchase_key);
      var monthly = await isCheckSubscribed(monthly_purchase_key);
      if (annual || monthly) {
        return true;
      }
    } on QPurchaseException catch (e) {
      print(e);
      var errorCode = e.message;
      /*Analytics().sendEventReports(
          event: subscription_fail,
          attr: {'code': errorCode, 'additional': errorCode});*/
    }
    return false;
  }

  Future<bool> restorePurchase(String sku) async {
    await initPlatformState();

    if (sku == annual_purchase_key) {
      sku = 'annual.permission';
    } else {
      sku = 'weekly.permission';
    }

    final Map<String, QPermission> permissions = await Qonversion.restore();

    final main = permissions[sku];
    if (main != null && main.isActive) {
      switch (main.renewState.toString()) {
        case 'QProductRenewState.willRenew':
          return true;
          break;
        case 'QProductRenewState.nonRenewable':
        case 'QProductRenewState.billingIssue':
        case 'QProductRenewState.canceled':
          return false;
          break;
        default:
          return false;
          break;
      }
    } else {
      return false;
    }
  }

  Future<Map<String, QProduct>> getProducts() async {
    await initPlatformState();
    final Map<String, QProduct> products = _qLaunchResult.products;
    return products;
  }

  Future<bool> isCheckSubscribed(String sku) async {
    await initPlatformState();

    if (sku == annual_purchase_key) {
      sku = 'annual.permission';
    } else {
      sku = 'weekly.permission';
    }

    final Map<String, QPermission> permissions =
        await Qonversion.checkPermissions();
    final main = permissions[sku];
    if (main != null && main.isActive) {
      switch (main.renewState.toString()) {
        case 'QProductRenewState.willRenew':
          return true;
          break;
        case 'QProductRenewState.nonRenewable':
        case 'QProductRenewState.billingIssue':
        case 'QProductRenewState.canceled':
          return false;
          break;
        default:
          return false;
          break;
      }
    } else {
      return false;
    }
  }
}
