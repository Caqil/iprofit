// lib/features/home/widgets/tasks_progress_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../providers/home_provider.dart';

class TasksProgressCard extends ConsumerWidget {
  const TasksProgressCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);

    return homeState.when(
      data: (homeData) {
        final tasksProgress = homeData['tasksProgress'] as List<TaskProgress>;
        return _buildTasksCard(context, tasksProgress);
      },
      loading: () => _buildLoadingState(),
      error: (_, __) => _buildErrorState(),
    );
  }

  Widget _buildTasksCard(BuildContext context, List<TaskProgress> tasksData) {
    final completedTasks = tasksData.where((task) => task.isCompleted).length;
    final totalTasks = tasksData.length;
    final progressPercentage = totalTasks > 0
        ? (completedTasks / totalTasks) * 100
        : 0.0;
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.canvasColor, theme.primaryColor.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.disabledColor.withOpacity(0.1),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.task_alt,
                      color: Color(0xFF8B5CF6),
                      size: 12,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Today\'s Tasks',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => context.push('/tasks'),
                child: Text(
                  '$completedTasks/$totalTasks',
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Content based on tasks availability
          if (tasksData.isEmpty)
            _buildEmptyState()
          else
            _buildTasksContent(
              progressPercentage,
              tasksData,
              completedTasks,
              totalTasks,
            ),
        ],
      ),
    );
  }

  Widget _buildTasksContent(
    double progressPercentage,
    List<TaskProgress> tasksData,
    int completedTasks,
    int totalTasks,
  ) {
    return Column(
      children: [
        // Progress Circle and Tasks
        Row(
          children: [
            // Circular Progress
            SizedBox(
              width: 80,
              height: 80,
              child: Stack(
                children: [
                  // Background circle
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 6,
                      backgroundColor: const Color(0xFF3A3A3A),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF3A3A3A),
                      ),
                    ),
                  ),
                  // Progress circle
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      value: progressPercentage / 100,
                      strokeWidth: 6,
                      backgroundColor: Colors.transparent,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  // Percentage text
                  Center(
                    child: Text(
                      '${progressPercentage.toInt()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Tasks list (show first 3 tasks)
            Expanded(
              child: Column(
                children: tasksData
                    .take(3)
                    .map(
                      (task) => _TaskItem(
                        title: task.title,
                        status: task.status,
                        isCompleted: task.isCompleted,
                        isMandatory: task.isMandatory,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Bottom message
        _buildBottomMessage(completedTasks, totalTasks),
      ],
    );
  }

  Widget _buildBottomMessage(int completedTasks, int totalTasks) {
    final isAllCompleted = completedTasks == totalTasks && totalTasks > 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            isAllCompleted ? Icons.check_circle : Icons.info_outline,
            color: isAllCompleted
                ? AppTheme.primaryColor
                : AppTheme.primaryColor,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isAllCompleted
                  ? 'Great! All tasks completed'
                  : 'Keep going to unlock withdrawal',
              style: const TextStyle(color: Color(0xFF8E8E8E), fontSize: 12),
            ),
          ),
          if (!isAllCompleted)
            const Text(
              '+20% Bonus',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Center(
        child: Column(
          children: [
            Icon(Icons.task_alt_outlined, color: Color(0xFF8E8E8E), size: 48),
            SizedBox(height: 12),
            Text(
              'No tasks available',
              style: TextStyle(
                color: Color(0xFF8E8E8E),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Check back later for new tasks',
              style: TextStyle(color: Color(0xFF666666), fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3A3A3A), width: 1),
      ),
      height: 200,
      child: const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3A3A3A), width: 1),
      ),
      height: 200,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Color(0xFF8E8E8E), size: 48),
            SizedBox(height: 12),
            Text(
              'Error loading tasks',
              style: TextStyle(color: Color(0xFF8E8E8E), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskItem extends StatelessWidget {
  final String title;
  final String status;
  final bool isCompleted;
  final bool isMandatory;

  const _TaskItem({
    required this.title,
    required this.status,
    required this.isCompleted,
    required this.isMandatory,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          // Status indicator
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppTheme.primaryColor
                  : const Color(0xFF3A3A3A),
              shape: BoxShape.circle,
            ),
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 10)
                : null,
          ),
          const SizedBox(width: 8),

          // Task title with mandatory indicator
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isCompleted
                          ? const Color(0xFF8E8E8E)
                          : Colors.white,
                      fontSize: 12,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isMandatory && !isCompleted) ...[
                  const SizedBox(width: 4),
                  const Text(
                    '*',
                    style: TextStyle(
                      color: Color(0xFFFF6B6B),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Status
          Text(
            status,
            style: TextStyle(
              color: isCompleted
                  ? AppTheme.primaryColor
                  : const Color(0xFF8E8E8E),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
