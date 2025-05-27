// lib/features/tasks/screens/tasks_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/tasks_provider.dart';
import '../../../core/enums/task_type.dart';
import '../../../shared/widgets/error_widget.dart';
import '../../../core/utils/snackbar_utils.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksState = ref.watch(tasksProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(tasksProvider.future),
        child: tasksState.when(
          data: (tasks) {
            final mandatoryTasks = tasks
                .where((task) => task.isMandatory)
                .toList();
            final optionalTasks = tasks
                .where((task) => !task.isMandatory)
                .toList();

            final allMandatoryCompleted = mandatoryTasks.every(
              (task) => task.isCompleted,
            );

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: allMandatoryCompleted
                          ? Colors.green.shade100
                          : Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: allMandatoryCompleted
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          allMandatoryCompleted
                              ? Icons.check_circle
                              : Icons.warning,
                          color: allMandatoryCompleted
                              ? Colors.green
                              : Colors.orange,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            allMandatoryCompleted
                                ? 'All mandatory tasks completed! You can now withdraw funds.'
                                : 'Complete all mandatory tasks to unlock withdrawals.',
                            style: TextStyle(
                              color: allMandatoryCompleted
                                  ? Colors.green.shade800
                                  : Colors.orange.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Mandatory tasks
                  const Text(
                    'Mandatory Tasks',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (mandatoryTasks.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No mandatory tasks found.'),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: mandatoryTasks.length,
                      itemBuilder: (context, index) {
                        final task = mandatoryTasks[index];
                        return _buildTaskCard(context, task, ref);
                      },
                    ),

                  const SizedBox(height: 24),

                  // Optional tasks
                  const Text(
                    'Optional Tasks',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (optionalTasks.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No optional tasks found.'),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: optionalTasks.length,
                      itemBuilder: (context, index) {
                        final task = optionalTasks[index];
                        return _buildTaskCard(context, task, ref);
                      },
                    ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => CustomErrorWidget(
            error: error.toString(),
            onRetry: () => ref.refresh(tasksProvider.future),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, task, WidgetRef ref) {
    final taskIcon = _getTaskIcon(task.taskType);

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
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    taskIcon,
                    color: Theme.of(context).colorScheme.primary,
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
                  onChanged: task.isCompleted
                      ? null
                      : (_) => _completeTask(context, task, ref),
                ),
              ],
            ),
            if (task.taskUrl != null && !task.isCompleted) ...[
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => _openTaskUrl(context, task.taskUrl!),
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

  String _getActionText(TaskType type) {
    switch (type) {
      case TaskType.follow:
        return 'Go to Follow';
      case TaskType.like:
        return 'Go to Like';
      case TaskType.install:
        return 'Go to Install';
      default:
        return 'Complete Task';
    }
  }

  Future<void> _openTaskUrl(BuildContext context, String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      SnackbarUtils.showErrorSnackbar(context, 'Error opening URL: $e');
    }
  }

  Future<void> _completeTask(BuildContext context, task, WidgetRef ref) async {
    try {
      await ref.read(tasksProvider.notifier).completeTask(task.id);

      if (context.mounted) {
        SnackbarUtils.showSuccessSnackbar(
          context,
          'Task completed successfully!',
        );
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarUtils.showErrorSnackbar(context, e.toString());
      }
    }
  }
}
