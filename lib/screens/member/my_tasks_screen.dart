import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme/app_colors.dart';
import '../../core/enums/status.dart';
import '../../models/task_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_data_provider.dart';
import '../../widgets/cards/task_card.dart';

class MemberMyTasksScreen extends StatefulWidget {
  const MemberMyTasksScreen({super.key});

  @override
  State<MemberMyTasksScreen> createState() => _MemberMyTasksScreenState();
}

class _MemberMyTasksScreenState extends State<MemberMyTasksScreen> {
  int _filterIndex = 0; // 0=All, 1=Pending, 2=Submitted, 3=Approved

  List<TaskModel> _filtered(List<TaskModel> tasks) {
    switch (_filterIndex) {
      case 1:
        return tasks.where((t) => t.status == TaskStatus.pending).toList();
      case 2:
        return tasks.where((t) => t.status == TaskStatus.submitted).toList();
      case 3:
        return tasks.where((t) => t.status == TaskStatus.approved).toList();
      default:
        return tasks;
    }
  }

  Future<void> _handleMarkComplete(
      BuildContext context, TaskModel task, AppDataProvider data) async {
    if (task.requiresPhotoUpload) {
      await _showPhotoUploadDialog(context, task, data);
    } else {
      data.updateTask(task.copyWith(status: TaskStatus.submitted));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task marked as submitted'),
            backgroundColor: AppColors.statusSubmitted,
          ),
        );
      }
    }
  }

  Future<void> _showPhotoUploadDialog(
      BuildContext context, TaskModel task, AppDataProvider data) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Upload Photo',
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryTeal.withAlpha(80)),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt_outlined,
                        color: AppColors.primaryTeal, size: 32),
                    const SizedBox(height: 8),
                    Text('Tap to select photo',
                        style: GoogleFonts.poppins(
                            color: AppColors.darkTextSecondary, fontSize: 12)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text('A photo proof is required for this task.',
                style: GoogleFonts.poppins(
                    color: AppColors.darkTextSecondary, fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: GoogleFonts.poppins(color: AppColors.darkTextSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryTeal),
            onPressed: () {
              Navigator.pop(ctx);
              data.updateTask(task.copyWith(
                status: TaskStatus.submitted,
                photoUrl: 'https://placeholder.com/photo_${task.id}.jpg',
              ));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Task submitted with photo'),
                  backgroundColor: AppColors.statusSubmitted,
                ),
              );
            },
            child: Text('Submit with Photo',
                style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final data = context.watch<AppDataProvider>();
    final userId = auth.currentUser?.id ?? '';
    final userTasks = data.tasksForUser(userId);

    final pending = userTasks.where((t) => t.status == TaskStatus.pending).length;
    final submitted = userTasks.where((t) => t.status == TaskStatus.submitted).length;
    final approved = userTasks.where((t) => t.status == TaskStatus.approved).length;

    final filtered = _filtered(userTasks);

    return RefreshIndicator(
      color: AppColors.primaryTeal,
      backgroundColor: AppColors.darkCard,
      onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
      child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Tasks',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(
                      '$pending pending · $submitted submitted',
                      style: GoogleFonts.poppins(
                          color: AppColors.darkTextSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    _FilterTabs(
                      index: _filterIndex,
                      counts: [
                        userTasks.length,
                        pending,
                        submitted,
                        approved
                      ],
                      onTap: (i) => setState(() => _filterIndex = i),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            if (filtered.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: _EmptyState(
                      message: _filterIndex == 0
                          ? 'No tasks assigned yet'
                          : 'No ${_tabLabel(_filterIndex).toLowerCase()} tasks'),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final task = filtered[index];
                      return TaskCard(
                        task: task,
                        onMarkComplete: task.status == TaskStatus.pending
                            ? () => _handleMarkComplete(context, task, data)
                            : null,
                        onUploadPhoto: task.requiresPhotoUpload &&
                                task.status == TaskStatus.pending
                            ? () => _showPhotoUploadDialog(context, task, data)
                            : null,
                      );
                    },
                    childCount: filtered.length,
                  ),
                ),
              ),
          ],
        ),
    );
  }

  String _tabLabel(int i) {
    switch (i) {
      case 1:
        return 'Pending';
      case 2:
        return 'Submitted';
      case 3:
        return 'Approved';
      default:
        return 'All';
    }
  }
}

class _FilterTabs extends StatelessWidget {
  final int index;
  final List<int> counts;
  final ValueChanged<int> onTap;

  const _FilterTabs(
      {required this.index, required this.counts, required this.onTap});

  static const _labels = ['All', 'Pending', 'Submitted', 'Approved'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_labels.length, (i) {
          final active = i == index;
          return GestureDetector(
            onTap: () => onTap(i),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: active ? AppColors.primaryTeal : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: active
                      ? AppColors.primaryTeal
                      : AppColors.darkDivider,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    _labels[i],
                    style: GoogleFonts.poppins(
                      color:
                          active ? Colors.white : AppColors.darkTextSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (counts[i] > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: active
                            ? Colors.white.withAlpha(50)
                            : AppColors.darkSurface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${counts[i]}',
                        style: GoogleFonts.poppins(
                          color: active
                              ? Colors.white
                              : AppColors.darkTextSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.task_outlined,
              color: AppColors.darkTextHint, size: 56),
          const SizedBox(height: 16),
          Text(message,
              style: GoogleFonts.poppins(
                  color: AppColors.darkTextSecondary, fontSize: 15)),
        ],
      ),
    );
  }
}
