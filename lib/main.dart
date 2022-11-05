import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:musedme/screens/auth/login_screen.dart';
import 'package:musedme/utils/constants.dart';

import 'bindings/firebase_binding.dart';
import 'firebase_options.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'utils/di_setup.dart' as di;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

  if(message.data['UserName'] != null) {
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
          fullScreenIntent: true,
          payload: {
            "UserID": message.data['UserID'],
            "FirstName": message.data['FirstName'],
            "LastName": message.data['LastName'],
            "ProfilePic": message.data['ProfilePic'],
            "UserName": message.data['UserName'],
            "RTCToken": message.data['RTCToken'],
            "RTMToken": message.data['RTMToken'],
            "Type":  message.data['Type'],
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
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.initServices(); /// AWAIT SERVICES INITIALIZATION.();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
          channelGroupKey: 'musedme_channel_group',
          channelKey: 'musedme_channel',
          channelName: 'MusedMe notifications',
          channelDescription: 'Notification channel for MusedMe',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          channelShowBadge: true,
          enableLights: true,
          importance: NotificationImportance.Max,
          criticalAlerts: true,
          defaultPrivacy: NotificationPrivacy.Public
        )
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'musedme_channel_group',
            channelGroupName: 'MusedMe group')
      ],
      debug: true
  );

  Stripe.publishableKey = Constants.stripePublishedKey;
  await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return GestureDetector(
    //   onTap: () {
    //     var currentFocus = FocusScope.of(context);
    //     if (!currentFocus.hasPrimaryFocus &&
    //         currentFocus.focusedChild != null) {
    //       FocusManager.instance.primaryFocus!.unfocus();
    //     }
    //   },
    //   child: MaterialApp(
    //     title: 'MUsedMe',
    //     debugShowCheckedModeBanner: false,
    //     theme: ThemeData(
    //         primarySwatch: Colors.red,
    //         scaffoldBackgroundColor: Colors.white,
    //         appBarTheme: const AppBarTheme(
    //             backgroundColor: Colors.white,
    //             elevation: 0,
    //             titleTextStyle: TextStyle(
    //               color: Colors.black,
    //               fontSize: 20,
    //               fontFamily: 'Larsseit',
    //               fontWeight: FontWeight.w500,
    //             )
    //         ),
    //         fontFamily: 'Larsseit'
    //     ),
    //     home: const LoginScreen(),
    //   ),
    // );
    return GetMaterialApp(
      title: 'MUsedMe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
              color: Colors.black,
            fontSize: 20,
            fontFamily: 'Larsseit',
            fontWeight: FontWeight.w500,
          )
        ),
        fontFamily: 'Larsseit'
      ),
      transitionDuration: const Duration(milliseconds: 500),
      // initialRoute: AppRoutes.LOGIN,
      initialRoute: getInitialRoute(),
      getPages: AppPages.list,
      initialBinding: FirebaseBinding(),
    );
  }

  String getInitialRoute() {
    final GetStorage box = GetStorage();
    if(box.read("token") != null) {
      return AppRoutes.ROOT;
    }
    else {
      return AppRoutes.LOGIN;
    }
  }
}