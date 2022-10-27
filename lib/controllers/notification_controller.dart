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
          title: "Calling...",
          body: message.notification?.body ?? "",
          actionType: ActionType.KeepOnTop,
          category: NotificationCategory.Call,
          displayOnBackground: true,
          wakeUpScreen: true,
            payload: {
              "UserID": message.data['UserID'],
              "FirstName": message.data['FirstName'],
              "LastName": message.data['LastName'],
              "ProfilePic": message.data['ProfilePic'],
              "UserName": message.data['UserName'],
              "RTCToken": message.data['RTCToken'],
              "RTMToken": message.data['RTMToken']
            }
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'accept',
            label: 'Accept',
          ),
          NotificationActionButton(
            isDangerousOption: true,
            key: 'reject',
            label: 'Reject',
          ),
        ],
      );

      // AwesomeNotifications().createNotification(
      //     content: NotificationContent(
      //         id: message.notification?.hashCode ?? 0,
      //         channelKey: 'musedme_channel',
      //         title: message.notification?.title ?? "",
      //         body: message.notification?.body ?? "",
      //         actionType: ActionType.Default,
      //         payload: {
      //           "UserID": message.data['UserID'],
      //           "FirstName": message.data['FirstName'],
      //           "LastName": message.data['LastName'],
      //           "ProfilePic": message.data['ProfilePic'],
      //           "UserName": message.data['UserName'],
      //           "RTCToken": message.data['RTCToken'],
      //           "RTMToken": message.data['RTMToken']
      //         }
      //     )
      // );
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
  }
}