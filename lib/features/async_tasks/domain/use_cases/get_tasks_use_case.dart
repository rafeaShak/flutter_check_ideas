import 'package:future_project/features/async_tasks/domain/repositories/async_task_repository.dart';

import '../entities/async_task.dart';

class GetTasksUseCase {
  final AsyncTaskRepository repository;

  const GetTasksUseCase({required this.repository});

  Future<List<AsyncTask>> call() {
    return repository.fetchTasks();
  }
}