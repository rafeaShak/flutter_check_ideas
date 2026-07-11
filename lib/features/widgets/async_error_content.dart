import 'package:flutter/material.dart';

class AsyncErrorContent extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;

  const AsyncErrorContent({
    required this.title,
    required this.message,
    this.onRetry,
    this.retryLabel = 'Retry',
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //TODO: What is context?
        Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
        const SizedBox(height: 8),
        Text(
            title,
            textAlign: .center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: .bold)
        ),
        const SizedBox(height: 8),
        Text(message, textAlign: .center),
        //TODO: What are these dots?
        if(onRetry != null)...[
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(retryLabel),
          ),
        ],
      ],
    );
  }
}