import 'package:flutter/material.dart';
import '../async_tasks/domain/entities/async_task.dart';
import 'async_empty_content.dart';
import 'async_error_content.dart';
import 'async_loading_content.dart';

import '../async_tasks/domain/use_cases/get_tasks_use_case.dart';

class TasksFutureBuilderCard extends StatefulWidget {
  final GetTasksUseCase getTasksUseCase;

  const TasksFutureBuilderCard({required this.getTasksUseCase, super.key});

  @override
  State<TasksFutureBuilderCard> createState() => _TasksFutureBuilderCardState();
}

class _TasksFutureBuilderCardState extends State<TasksFutureBuilderCard> {
  late Future<List<AsyncTask>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _tasksFuture = widget.getTasksUseCase();
  }

  void _reloadTasks() {
    //TODO: What is this?
    setState(() {
      _tasksFuture = widget.getTasksUseCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        //TODO: What is this???
        child: FutureBuilder<List<AsyncTask>>(
          future: _tasksFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == .waiting) {
              return const AsyncLoadingContent(
                message: 'Loading tasks...',
              );
            }

            if (snapshot.hasError) {
              return AsyncErrorContent(
                title: 'Failed to load tasks',
                message: snapshot.error.toString(),
                onRetry: _reloadTasks,
              );
            }

            final tasks = snapshot.data ?? [];

            if (tasks.isEmpty) {
              return AsyncEmptyContent(
                message: 'No tasks available',
                icon: Icons.task_alt,
                onAction: _reloadTasks,
                actionLabel: 'Refresh',
              );
            }

            return _TasksContent(tasks: tasks, onRefresh: _reloadTasks);
          },
        ),
      ),
    );
  }
}

class _TasksContent extends StatelessWidget {
  final List<AsyncTask> tasks;
  final VoidCallback onRefresh;

  //TODO: When should I pass a key and when not to?
  //TODO: What is the use of keys?
  const _TasksContent({required this.tasks, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final completedTasks = tasks.where((task) => task.completed).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Tasks FutureBuilder',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              onPressed: onRefresh,
              tooltip: 'Reload tasks',
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        Text('$completedTasks of ${tasks.length} tasks completed'),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tasks.length,
          separatorBuilder: (_, _) => const Divider(),
          itemBuilder: (context, index) {
            final task = tasks[index];

            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                task.completed
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  decoration: task.completed
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
