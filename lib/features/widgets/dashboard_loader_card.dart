import 'package:flutter/material.dart';
import 'package:future_project/features/widgets/async_error_content.dart';
import 'package:future_project/features/widgets/async_loading_content.dart';
import 'package:future_project/features/widgets/async_success_content.dart';

class DashboardLoaderCard extends StatefulWidget {
  final Future<Object?> Function() loadUser;
  final Future<Object?> Function() loadTasks;

  const DashboardLoaderCard({
    required this.loadUser,
    required this.loadTasks,
    super.key
  });

  @override
  State<DashboardLoaderCard> createState() => _DashboardLoaderCardState();
}

class _DashboardLoaderCardState extends State<DashboardLoaderCard> {
  Future<List<Object?>>? _dashboardFuture;

  Future<List<Object?>> _loadDashboard() {
    return Future.wait([
      widget.loadUser(),
      widget.loadTasks(),
    ]);
  }

  void _startLoading() {
    setState(() {
      _dashboardFuture = _loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Dashboard Loader',
              style: TextStyle(
                fontSize: 18,
                fontWeight: .bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Loads the user and tasks concurrently using Future.wait.'),
            const SizedBox(height: 16),
            if(_dashboardFuture == null)
              FilledButton.icon(
                  onPressed: _startLoading,
                  icon: const Icon(Icons.dashboard),
                label: const Text('Load dashboard'),
              )
            else
              FutureBuilder<List<Object?>>(
                  future: _dashboardFuture,
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == .waiting) {
                      return const AsyncLoadingContent(message: 'Loading dashboard data...');
                    }
                    if(snapshot.hasError) {
                      return AsyncErrorContent(
                        title: 'Failed to load dashboard',
                        message: snapshot.error.toString(),
                        onRetry: _startLoading,
                      );
                    }
                    return AsyncSuccessContent(
                      message: 'Dashboard loaded successfully',
                      onAction: _startLoading,
                      actionLabel: 'Reload',
                    );
                  }
              )
          ],
        ),
      ),
    );
  }
}