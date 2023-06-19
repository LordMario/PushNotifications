import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String arg =
        ModalRoute.of(context)?.settings.arguments.toString() ?? 'Sin datos';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Message'),
      ),
      body: Center(
        child: Text(arg),
      ),
    );
  }
}
