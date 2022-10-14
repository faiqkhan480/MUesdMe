import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:musedme/controllers/chat_controller.dart';

class FirebaseController extends GetxController {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final GetStorage _box = GetStorage();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initialize();
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

  onNotification(RemoteMessage message) {
    debugPrint('Got a message whilst in the foreground!');
    debugPrint('Message data: ${message.data}');

    if (message.notification != null) {
      if(Get.isRegistered<ChatController>()) {
        Get.find<ChatController>().getChats();
      }
      debugPrint('Message also contained a notification: ${message.notification}');
    }
  }
}