class AsyncTask {
  final String id;
  final String title;
  final bool completed;

  const AsyncTask({
    required this.id,
    required this.title,
    required this.completed,
  });

  AsyncTask copyWith({
    String? id,
    String? title,
    bool? completed,
  }) {
    return AsyncTask(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}