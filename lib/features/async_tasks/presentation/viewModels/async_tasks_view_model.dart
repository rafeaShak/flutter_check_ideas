import 'dart:async';

import 'package:flutter/foundation.dart';
import '../../domain/entities/async_task.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/async_task_repository.dart';

class AsyncTasksViewModel extends ChangeNotifier {
  final AsyncTaskRepository repository;

  AsyncTasksViewModel({required this.repository});

  List<AsyncTask> _tasks = [];
  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _errorMessage;

  //TODO: What is this?
  StreamSubscription<List<AsyncTask>>? _tasksSubscription;
  //TODO: What is this?
  List<AsyncTask> get tasks => List.unmodifiable(_tasks);
  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadInitialData() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      //TODO: What is this?
      final results = await Future.wait([
        repository.fetchTasks(),
        repository.fetchUser()
      ]);

      _tasks = results[0] as List<AsyncTask>;
      _userProfile = results[1] as UserProfile;
    } catch(error) {
      _errorMessage = error.toString();
      //TODO: What is this?
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addTask(String title) async {
    final trimmedTitle = title.trim();

    if(trimmedTitle.isEmpty) {
      //TODO: What is the difference between ' and "
      _errorMessage = 'Task title cannot be empty';
      notifyListeners();
      return;
    }
    _setLoading(true);
    _errorMessage = null;

    try {
      await repository.addTask(trimmedTitle);
      _tasks = await repository.fetchTasks();
      _userProfile = await repository.fetchUser();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> completeTask(String id) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await repository.completeTask(id);
      _tasks = await repository.fetchTasks();
      _userProfile = await repository.fetchUser();
    } catch(error) {
      _errorMessage = error.toString();
    } finally {
      _setLoading(false);
    }
  }

  void startWatchingTasks() {
    _tasksSubscription?.cancel();

    _tasksSubscription = repository.watchTasks().listen(
          (tasks) {
        _tasks = tasks;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (Object error) {
        _errorMessage = error.toString();
        notifyListeners();
      },
    );
  }

  Future<void> stopWatchingTasks() async {
    await _tasksSubscription?.cancel();
    _tasksSubscription = null;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    //TODO: What is this?
    notifyListeners();
  }

  @override
  void dispose() {
    _tasksSubscription?.cancel();
    super.dispose();
  }
}