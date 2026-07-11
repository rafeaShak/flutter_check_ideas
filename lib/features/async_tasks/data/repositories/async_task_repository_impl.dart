import '../../../async_tasks/data/datasources/fake_task_remote_data_source.dart';
import '../../domain/entities/async_task.dart';
import '../../domain/repositories/async_task_repository.dart';
import '../../domain/entities/user_profile.dart';

class AsyncTaskRepositoryImpl implements AsyncTaskRepository {
  final FakeTaskRemoteDataSource remoteDataSource;

  //TODO: Ask about this.
  AsyncTaskRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addTask(String title) {
    return remoteDataSource.addTask(title);
  }

  @override
  Future<void> completeTask(String id) {
    return remoteDataSource.completeTask(id);
  }

  @override
  Future<List<AsyncTask>> fetchTasks() {
    return remoteDataSource.fetchTasks();
  }

  @override
  Future<UserProfile> fetchUser() {
    return remoteDataSource.fetchUser();
  }

  @override
  //TODO: What is this?
  Stream<List<AsyncTask>> watchTasks()  async* {
    while(true) {
      final tasks = await remoteDataSource.fetchTasks();
      //TODO: What is this?
      yield tasks;
      await Future.delayed(const Duration(seconds: 3));
    }
  }
}
