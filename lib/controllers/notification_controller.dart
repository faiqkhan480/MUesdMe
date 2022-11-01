import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:musedme/utils/constants.dart';

import '../models/args.dart';
import '../models/auths/user_model.dart';
import '../routes/app_routes.dart';
import '../utils/network.dart';
import 'call_controller.dart';
import 'chat_controller.dart';
import 'feed_controller.dart';

class PushNotification extends GetxController {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final GetStorage _box = GetStorage();

  AwesomeNotifications localNotification = AwesomeNotifications();

  @override
  void onInit() {
    // Only after at least the action method is set, the notification events are delivered
    localNotification.setListeners(
        onActionReceivedMethod:         NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:    NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:  NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:  NotificationController.onDismissActionReceivedMethod
    );
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
      criticalAlert: true,
      provisional: true,
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
      if(Get.isRegistered<FeedController>()) {
        Get.find<FeedController>().getActiveUsers();
      }

      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: message.notification?.hashCode ?? 0,
              channelKey: 'musedme_channel',
              title: message.notification?.title ?? "",
              body: message.notification?.body ?? "",
              actionType: ActionType.Default,
              payload: {
                "UserID": message.data['UserID'],
                "FirstName": message.data['FirstName'],
                "LastName": message.data['LastName'],
                "ProfilePic": message.data['ProfilePic'],
                "UserName": message.data['UserName'],
                "RTCToken": message.data['RTCToken'],
                "RTMToken": message.data['RTMToken']
              }
          )
      );
    }
  }

  // SAVE BUY REQUEST
  Future sndFCMNotification(String? token, User u, String type) async {
    try {
      var payload = {
        "to": token,
        "notification": {
          "title": u.userName ?? "",
          "body": "Calling...",
          "android": {
            "ttl": "86400s",
            "notification": {
              "notification_priority": "high"
            }
          }
        },
        "data": {
          "UserID": u.userId,
          "FirstName": u.firstName,
          "LastName": u.lastName,
          "ProfilePic": u.profilePic,
          "UserName": u.userName,
          "RTCToken": u.rtcToken,
          "RTMToken": u.rtmToken,
          "Type": type
        }
      };
      var header = {"Authorization": "key=AAAAsS0BE0Q:APA91bHXwg8lkauiV7GOntohpV0u2cjyDlzmq8Dv9VgQ3ZlNve1K035tsMtICHFxBpvpADyQ1HHwwyHnuBvD7KNh48PhGKP9w6rvvKLvhlw_R1ycZL70-6XFO5I2rJNiFzbKDG47JqI-"};
      final json = await Network.post(url: "https://fcm.googleapis.com/fcm/send", headers: header, payload: payload);
      debugPrint("FCM RES::::::$json");
      return null;
    } catch (e) {
      debugPrint("FCM ERROR >>>>>>>>>> $e");
      return null;
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

    if(receivedAction.buttonKeyPressed == "accept") {
      debugPrint("ActionReceivedMethod: ${receivedAction.payload}");
      Get.toNamed(
          AppRoutes.CALL,
          arguments: Args(
              broadcaster: User().copyWith(
                userId: int.tryParse((receivedAction.payload?['UserID'] ?? "")),
                firstName: receivedAction.payload?['FirstName'],
                lastName: receivedAction.payload?['LastName'],
                profilePic: receivedAction.payload?['ProfilePic'],
                userName: receivedAction.payload?['UserName'],
                rtcToken: receivedAction.payload?['RTCToken'],
                rtmToken: receivedAction.payload?['RTMToken'],
              ),
              callType: CallType.notification,
              callMode: receivedAction.payload?['Type'] == "Video" ? CallType.video : CallType.audio));
      AwesomeNotifications().cancelAll();
    }
    else {
      AwesomeNotifications().dismiss(receivedAction.id!);
    }
  }
}