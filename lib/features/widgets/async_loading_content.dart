import 'package:flutter/material.dart';

class AsyncLoadingContent extends StatelessWidget {
  final String message;

  const AsyncLoadingContent({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text(message, textAlign: TextAlign.center),
      ],
    );
  }
}