//sha1: 03:36:02:07:DC:2B:60:DD:4B:F0:91:1B:B4:07:A9:9F:AC:7C:73:C4

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.max,
    enableVibration: false,
    ledColor: Colors.black,
    playSound: false,
  );

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future initializeApp() async {
    //PushNotifications
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();

    //print('token  $token');

    //Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onOpenMessageOpenApp);

    //Local Notifications
  }

  static Future _backgroundHandler(RemoteMessage message) async {
    //print('Background Handler:  ${message.messageId} ');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    RemoteNotification? notification = message.notification;
    String iconName = const AndroidInitializationSettings('@mipmap/ic_launcher')
        .defaultIcon
        .toString();

    // Si `onMessage` es activado con una notificación, construimos nuestra propia
    // notificación local para mostrar a los usuarios, usando el canal creado.
    if (notification != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                icon: iconName,
                playSound: channel.playSound,
                color: channel.ledColor,
                enableVibration: channel.enableVibration),
          ));
    }
    //print('_onMessageHandler:  ${message.messageId} ');
  }

  static Future _onOpenMessageOpenApp(RemoteMessage message) async {
    //print('_onOpenMessageOpenApp:  ${message.messageId} ');
  }
}
