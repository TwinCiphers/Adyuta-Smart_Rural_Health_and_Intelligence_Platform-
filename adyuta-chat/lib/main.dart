import 'package:flutter/material.dart';

import 'ui/chat_screen.dart';

void main() {
  runApp(const AdyutaChatApp());
}

/// A deliberately small test client for the ADYUTA API: text and voice chat,
/// saved conversations, and the honesty metadata the backend sends with every
/// answer. It is a dev tool, not the product frontend.
class AdyutaChatApp extends StatelessWidget {
  const AdyutaChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ADYUTA chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1F6FEB)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1F6FEB),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const ChatScreen(),
    );
  }
}
