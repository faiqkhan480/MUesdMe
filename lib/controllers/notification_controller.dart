import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'chat_controller.dart';

class PushNotification extends GetxController {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final GetStorage _box = GetStorage();

  AwesomeNotifications localNotification = AwesomeNotifications();

  @override
  void onInit() {
    // // Only after at least the action method is set, the notification events are delivered
    // localNotification.setListeners(
    //     onActionReceivedMethod:         NotificationController.onActionReceivedMethod,
    //     onNotificationCreatedMethod:    NotificationController.onNotificationCreatedMethod,
    //     onNotificationDisplayedMethod:  NotificationController.onNotificationDisplayedMethod,
    //     onDismissActionReceivedMethod:  NotificationController.onDismissActionReceivedMethod
    // );
    // TODO: implement onInit
    super.onInit();
    initialize();
    initLocalNotification();
  }

  Future<void> initialize() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // use the returned token to send messages to users from your custom server
    String? token = await _messaging.getToken();
    debugPrint("FCM: $token");
    _box.write("fcm", token);

    FirebaseMessaging.onMessage.listen(onNotification);
  }

  Future<void> initLocalNotification() async {
    localNotification.isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  onNotification(RemoteMessage message) {
    debugPrint('Got a message whilst in the foreground!');
    debugPrint('Message data: ${message.data}');

    if (message.notification != null) {
      if(Get.isRegistered<ChatController>()) {
        Get.find<ChatController>().getChats();
      }
      debugPrint('Message also contained a notification: ${message.notification}');

      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: message.notification?.hashCode ?? 0,
              channelKey: 'musedme_channel',
              title: message.notification?.title ?? "",
              body: message.notification?.body ?? "",
              actionType: ActionType.Default
          )
      );
    }
  }
}

class NotificationController {

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future <void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future <void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future <void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future <void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here

    // Navigate into pages, avoiding to open the notification details page over another details page already opened

    // MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil('/notification-page',
    //         (route) => (route.settings.name != '/notification-page') || route.isFirst,
    //     arguments: receivedAction);
  }
}