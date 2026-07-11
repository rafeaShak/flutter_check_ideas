import '../../domain/entities/user_profile.dart';

import '../../../widgets/notifications_stream_card.dart';

class FakeTaskRemoteDataSource {
  final List<AsyncTask> _tasks = [
    const AsyncTask(id: '1', title: 'Learn Future', completed: false),
    const AsyncTask(id: '2', title: 'Learn async / await', completed: false),
    const AsyncTask(id: '3', title: 'Learn Stream', completed: false)
  ];

  Future<List<AsyncTask>> fetchTasks() async {
    //TODO: Why const?
    await Future.delayed(const Duration(seconds: 2));
    //TODO: What is this?
    return List.unmodifiable(_tasks);
  }

  Future<UserProfile> fetchUser() async {
    await Future.delayed(const Duration(seconds: 1));
    final completedTasks = _tasks.where((task) => task.completed).length;
    return UserProfile(
        id: 'user_1',
        name: 'Rafea',
        completedTasks: completedTasks
    );
  }

  Future<void> addTask(String title) async {
    await Future.delayed(const Duration(seconds: 1));

    final task = AsyncTask(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        completed: false
    );

    _tasks.add(task);
  }

  Future<void> completeTask(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index  == -1) {
      //TODO: Should we have throws at the declaration of the function?
      throw Exception('Task not found');
    }

    _tasks[index] = _tasks[index].copyWith(completed: true);
  }
}