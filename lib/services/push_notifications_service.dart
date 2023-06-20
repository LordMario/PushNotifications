//sha1: 03:36:02:07:DC:2B:60:DD:4B:F0:91:1B:B4:07:A9:9F:AC:7C:73:C4
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

  static final StreamController<String> _messageStream =
      StreamController.broadcast();

  static Stream<String> get messagesStream => _messageStream.stream;

  static AndroidNotificationChannel channel =
      const AndroidNotificationChannel('Prueba', 'Prueba');

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future initializeApp() async {
    //PushNotifications
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    //Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onOpenMessageOpenApp);

    //Local Notifications
  }

  static Future _backgroundHandler(RemoteMessage message) async {
    _messageStream.add(message.data['product'] ?? 'No title');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    final String producto = message.data['product'] ?? 'Sin producto';
    final String cantidad = message.data['cantidad'] ?? 'Agotado';
    _messageStream.add('$cantidad - $producto');
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
                channelDescription: channel.description, icon: iconName),
          ));
    }
  }

  static Future _onOpenMessageOpenApp(RemoteMessage message) async {
    _messageStream.add(message.data['product'] ?? 'No title');
  }

  static closedStream() {
    _messageStream.close();
  }

  /*POST https://fcm.googleapis.com/v1/projects/myproject-b5ae1/messages:send HTTP/1.1

Content-Type: application/json
Authorization: Bearer ya29.ElqKBGN2Ri_Uz...HnS_uNreA

{
   "message":{
      "token":"token_1",
      "data":{},
      "notification":{
        "title":"FCM Message",
        "body":"This is an FCM notification message!",
      }
   }
}*/
}
