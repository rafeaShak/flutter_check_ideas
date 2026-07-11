import 'package:flutter/material.dart';
import 'package:future_project/features/async_tasks/domain/entities/user_profile.dart';

class ProfileFutureCard extends StatelessWidget {
  final UserProfile? userProfile;

  const ProfileFutureCard({required this.userProfile, super.key});

  @override
  Widget build(BuildContext context) {
    final user = userProfile;
    if (user == null) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.person),
        ),
        title: Text(user.name),
        subtitle: Text('Completed tasks: ${user.completedTasks}'),
      ),
    );
  }
}