class UserProfile {
  final String id;
  final String name;
  final int completedTasks;

  const UserProfile({
    required this.id,
    required this.name,
    required this.completedTasks,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    int? completedTasks,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      completedTasks: completedTasks ?? this.completedTasks,
    );
  }
}