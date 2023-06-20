import 'package:flutter/material.dart';
import 'package:push_notifications/screens/screens.dart';
import 'package:push_notifications/services/push_notifications_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PushNotificationService.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    PushNotificationService.messagesStream.listen((message) {
      navigationKey.currentState!
          .pushReplacementNamed('message', arguments: message);

      final SnackBar snack = SnackBar(
        content: Text(message),
      );

      messengerKey.currentState?.showSnackBar(snack);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigationKey,
      scaffoldMessengerKey: messengerKey,
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
