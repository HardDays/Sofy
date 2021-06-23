import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sofy_new/screens/bloc/notifications_bloc.dart';

class LocalNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool _started = false;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  LocalNotificationService._internal();

  static final LocalNotificationService instance =
      LocalNotificationService._internal();


  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    print("Handling a background message: ${message.messageId}");
    showNotification(
        10001, message.notification.title, message.notification.body, '');
    NotificationsBloc.instance
        .newNotification(LocalNotification("notification", message.data));
  }

  void start() {
    if (!_started) {
      _start();
      _started = true;
      refreshToken();

      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      var initializationSettingsAndroid =
          new AndroidInitializationSettings('@drawable/ic_notification');
      var initializationSettingsIOS = new IOSInitializationSettings();
      var initializationSettings = new InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS);

      flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin.initialize(initializationSettings);


      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print('Message also contained a notification: ${message.notification}');
          showNotification(
              10001, message.notification.title, message.notification.body, '');
          NotificationsBloc.instance
              .newNotification(LocalNotification("notification", message.data));
        }
      });
    }
  }

  void refreshToken() {
    _firebaseMessaging
        .getToken()
        .then(_tokenRefresh, onError: _tokenRefreshFailure);
  }

  void deleteToken() {
    _firebaseMessaging.deleteToken();
  }

  Future<void> _start() async {

    _firebaseMessaging.onTokenRefresh
        .listen(_tokenRefresh, onError: _tokenRefreshFailure);

  }

  Future<bool> permission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    _firebaseMessaging.onTokenRefresh
        .listen(_tokenRefresh, onError: _tokenRefreshFailure);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      return true;
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
      return false;
    } else {
      print('User declined or has not accepted permission');
      return false;
    }
  }

  void _tokenRefresh(String newToken) async {
    print("::::::======> New FCM Token $newToken");
  }

  void _tokenRefreshFailure(error) {
    print("::::::======> FCM token refresh failed with error $error");
  }

  Future<void> showNotification(
    int notificationId,
    String notificationTitle,
    String notificationContent,
    String payload, {
    String channelId = '1001',
    String channelTitle = 'Sofy Channel',
    String channelDescription = 'Default Sofy Channel for notifications',
    Priority notificationPriority = Priority.high,
    Importance notificationImportance = Importance.max,
  }) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      channelId,
      channelTitle,
      channelDescription,
      playSound: true,
      importance: notificationImportance,
      priority: notificationPriority,
    );
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(presentSound: true);
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      notificationId,
      notificationTitle,
      notificationContent,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}
