import 'package:flutter/material.dart';
import 'package:push_notifications/screens/screens.dart';
import 'package:push_notifications/services/push_notifications_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PushNotificationService.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home',
      routes: {
        'home': (_) => const HomeScreen(),
        'message': (_) => const MessageScreen(),
      },
    );
  }
}
