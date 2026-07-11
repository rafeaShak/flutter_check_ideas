import 'package:flutter/material.dart';
import 'async_error_content.dart';

class TaskProgressStreamCard extends StatelessWidget {
  final Stream<int> progressStream;

  const TaskProgressStreamCard({required this.progressStream, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<int>(
          stream: progressStream,
          initialData: 0,
          builder: (context, snapshot) {
            final progress = (snapshot.data ?? 0).clamp(0, 100);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Task Progress Stream',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (snapshot.hasError)
                  AsyncErrorContent(
                    title: 'Progress stream failed',
                    message: snapshot.error.toString(),
                  )
                else ...[
                  LinearProgressIndicator(value: progress / 100, minHeight: 10),
                  const SizedBox(height: 12),
                  Text(
                    '$progress%',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _statusText(snapshot.connectionState, progress),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  String _statusText(ConnectionState connectionState, int progress) {
    if (progress >= 100) {
      return 'Task completed';
    }

    return switch (connectionState) {
      ConnectionState.none => 'No progress stream',
      ConnectionState.waiting => 'Waiting for progress...',
      ConnectionState.active => 'Task is running...',
      ConnectionState.done => 'Progress stream closed',
    };
  }
}
