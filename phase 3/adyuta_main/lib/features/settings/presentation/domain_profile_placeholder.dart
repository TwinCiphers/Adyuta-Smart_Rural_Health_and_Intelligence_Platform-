import 'package:flutter/material.dart';

class DomainProfilePlaceholderScreen extends StatelessWidget {
  final String title;

  const DomainProfilePlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text('$title Data Module', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('This module is under construction.\nFuture updates will allow you to edit your domain-specific data here.', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
