import 'package:flutter/material.dart';

class AsyncSuccessContent extends StatelessWidget {
  final String message;
  final VoidCallback? onAction;
  final String? actionLabel;
  final IconData icon;

  const AsyncSuccessContent({
    required this.message,
    this.onAction,
    this.actionLabel,
    this.icon = Icons.check_circle,
    super.key,
  }) : assert(
         onAction == null || actionLabel != null,
         'actionLabel must be provided when onAction is provided.',
       );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 48, color: Colors.green),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: .center,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: .bold),
        ),
        if (onAction != null) ...[
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onAction,
            icon: const Icon(Icons.refresh),
            label: Text(actionLabel!),
          ),
        ],
      ],
    );
  }
}
