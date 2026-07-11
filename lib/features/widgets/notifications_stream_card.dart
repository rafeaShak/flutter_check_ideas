import 'package:flutter/material.dart';
import 'async_empty_content.dart';
import 'async_error_content.dart';

class NotificationsStreamCard extends StatefulWidget {
  final Stream<String> notificationsStream;

  const NotificationsStreamCard({required this.notificationsStream, super.key});

  @override
  State<NotificationsStreamCard> createState() =>
      _NotificationsStreamCardState();
}

class _NotificationsStreamCardState extends State<NotificationsStreamCard> {
  final List<String> _notifications = [];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<String>(
          stream: widget.notificationsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _addNotification(snapshot.data!);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Live Notifications',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (_notifications.isNotEmpty)
                      IconButton(
                        onPressed: _clearNotifications,
                        tooltip: 'Clear notifications',
                        icon: const Icon(Icons.delete_outline),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                if (snapshot.hasError)
                  AsyncErrorContent(
                    title: 'Notification stream failed',
                    message: snapshot.error.toString(),
                  )
                else if (_notifications.isEmpty)
                  const AsyncEmptyContent(
                    message: 'Waiting for notifications...',
                    icon: Icons.notifications_none,
                  )
                else
                  _NotificationsList(notifications: _notifications),
                const SizedBox(height: 12),
                _ConnectionStatus(connectionState: snapshot.connectionState),
              ],
            );
          },
        ),
      ),
    );
  }

  void _addNotification(String notification) {
    if (_notifications.isNotEmpty && _notifications.last == notification) {
      return;
    }

    _notifications.add(notification);
  }

  void _clearNotifications() {
    setState(_notifications.clear);
  }
}

class _NotificationsList extends StatelessWidget {
  final List<String> notifications;

  const _NotificationsList({required this.notifications});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notifications.length,
      separatorBuilder: (_, _) => const Divider(),
      itemBuilder: (context, index) {
        final reversedIndex = notifications.length - 1 - index;
        final notification = notifications[reversedIndex];

        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const CircleAvatar(child: Icon(Icons.notifications)),
          title: Text(notification),
        );
      },
    );
  }
}

class _ConnectionStatus extends StatelessWidget {
  final ConnectionState connectionState;

  const _ConnectionStatus({required this.connectionState});

  @override
  Widget build(BuildContext context) {
    final (icon, text) = switch (connectionState) {
      ConnectionState.none => (Icons.cloud_off, 'Not connected'),
      ConnectionState.waiting => (Icons.hourglass_empty, 'Connecting...'),
      ConnectionState.active => (Icons.wifi, 'Listening for updates'),
      ConnectionState.done => (Icons.check, 'Notification stream closed'),
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Icon(icon, size: 18), const SizedBox(width: 8), Text(text)],
    );
  }
}
