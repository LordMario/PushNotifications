import 'package:flutter/material.dart';
import 'package:push_notifications/services/push_notifications_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final token = PushNotificationService.token;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: TextFormField(
          initialValue: token,
          maxLines: 5,
        ),
      ),
    );
  }
}
