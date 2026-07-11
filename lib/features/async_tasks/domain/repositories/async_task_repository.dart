import '../../../widgets/notifications_stream_card.dart';
import '../entities/user_profile.dart';

abstract class AsyncTaskRepository {
  Future<List<AsyncTask>> fetchTasks();

  Future<UserProfile> fetchUser();

  Future<void> addTask(String title);

  Future<void> completeTask(String id);

  Stream<List<AsyncTask>> watchTasks();
}