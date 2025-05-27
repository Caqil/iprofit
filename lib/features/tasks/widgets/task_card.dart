// lib/features/tasks/widgets/task_card.dart
import 'package:flutter/material.dart';
import '../../../models/task.dart';
import '../../../core/enums/task_type.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final Function(Task) onComplete;
  final Function(String)? onActionTap;

  const TaskCard({
    super.key,
    required this.task,
    required this.onComplete,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getTaskColor(task.taskType).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getTaskIcon(task.taskType),
                    color: _getTaskColor(task.taskType),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.description,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Checkbox(
                  value: task.isCompleted,
                  onChanged: task.isCompleted ? null : (_) => onComplete(task),
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
            if (task.isMandatory)
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.orange),
                ),
                child: const Text(
                  'Mandatory',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (task.taskUrl != null && !task.isCompleted) ...[
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => onActionTap?.call(task.taskUrl!),
                icon: const Icon(Icons.open_in_new, size: 16),
                label: Text(_getActionText(task.taskType)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getTaskIcon(TaskType type) {
    switch (type) {
      case TaskType.follow:
        return Icons.person_add;
      case TaskType.like:
        return Icons.thumb_up;
      case TaskType.install:
        return Icons.get_app;
      default:
        return Icons.check_circle;
    }
  }

  Color _getTaskColor(TaskType type) {
    switch (type) {
      case TaskType.follow:
        return Colors.blue;
      case TaskType.like:
        return Colors.purple;
      case TaskType.install:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getActionText(TaskType type) {
    switch (type) {
      case TaskType.follow:
        return 'Follow Now';
      case TaskType.like:
        return 'Like Now';
      case TaskType.install:
        return 'Install Now';
      default:
        return 'Complete Task';
    }
  }
}
