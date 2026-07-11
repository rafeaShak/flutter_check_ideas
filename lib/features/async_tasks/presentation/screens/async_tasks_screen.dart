import 'dart:async';

import 'package:flutter/material.dart';
import 'package:future_project/features/async_tasks/presentation/viewModels/async_tasks_view_model.dart';
import 'package:future_project/features/widgets/profile_future_card.dart';

class AsyncTasksScreen extends StatefulWidget {
  final AsyncTasksViewModel viewModel;

  //TODO:What is this?
  const AsyncTasksScreen({required this.viewModel, super.key});

  @override
  State<AsyncTasksScreen> createState() => _AsyncTasksScreenState();
}

//TODO:What is this?
class _AsyncTasksScreenState extends State<AsyncTasksScreen> {
  //TODO:What is this?
  final TextEditingController _textController = TextEditingController();

  //TODO:What is this?
  AsyncTasksViewModel get viewModel => widget.viewModel;

  //TODO:What is this?
  @override
  void initState() {
    super.initState();

    viewModel.addListener(_onViewModelChanged);
    viewModel.loadInitialData();
    viewModel.startWatchingTasks();
  }

  void _onViewModelChanged() {
    //TODO:What is this?
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _addTask() async {
    final title = _textController.text;
    await viewModel.addTask(title);
    if (viewModel.errorMessage == null) {
      _textController.clear();
    }
  }

  @override
  void dispose() {
    viewModel.removeListener(_onViewModelChanged);
    viewModel.stopWatchingTasks();
    _textController.dispose();
    viewModel.dispose();
    //TODO: Should it be called at the end?
    super.dispose();
  }

  //TODO:What is this?
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Async Interview Lab')),
      body: SafeArea(
        child: Column(
          children: [
            ProfileFutureCard(userProfile: viewModel.userProfile),
            _buildTaskInput(),
            _buildErrorMessage(),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTaskInput() {
    return Padding(
      //TODO: What is this?
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'New Task',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _addTask(),
            ),
          ),
          const SizedBox(width: 12),
          IconButton.filled(
            //TODO: Go over it again
            onPressed: viewModel.isLoading ? null : () { unawaited(_addTask()); },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    final error = viewModel.errorMessage;

    if (error == null) {
      //TODO: What is this?
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: MaterialBanner(
        content: Text(error),
        actions: [
          TextButton(
            onPressed: viewModel.clearError,
            child: const Text('Dismiss'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (viewModel.isLoading && viewModel.tasks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.tasks.isEmpty) {
      return const Center(child: Text('No tasks available'));
    }

    return Stack(
      children: [
        ListView.separated(
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final task = viewModel.tasks[index];

            return Card(
              child: CheckboxListTile(
                value: task.completed,
                title: Text(task.title),
                onChanged: task.completed || viewModel.isLoading
                    ? null
                    : (_) => viewModel.completeTask(task.id),
              ),
            );
          },
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemCount: viewModel.tasks.length,
        ),
        //TODO: Why don't we need {} ?
        if (viewModel.isLoading)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(),
          ),
      ],
    );
  }
}
