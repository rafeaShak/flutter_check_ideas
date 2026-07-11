import 'package:flutter/material.dart';
import '../features/async_tasks/data/datasources/fake_task_remote_data_source.dart';
import '../features/async_tasks/data/repositories/async_task_repository_impl.dart';
import '../features/async_tasks/presentation/screens/async_tasks_screen.dart';
import '../features/async_tasks/presentation/viewModels/async_tasks_view_model.dart';

class AsyncInterviewApp extends StatelessWidget {
  const AsyncInterviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    final remoteDataSource = FakeTaskRemoteDataSource();

    final repository = AsyncTaskRepositoryImpl(
        remoteDataSource: remoteDataSource
    );

    final viewModel = AsyncTasksViewModel(
        repository: repository
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Async Interview Lab',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo
        ),
        useMaterial3: true,
      ),
      home: AsyncTasksScreen(
          viewModel: viewModel
      ),
    );
  }
}