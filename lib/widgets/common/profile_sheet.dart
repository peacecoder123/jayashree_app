import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../config/theme/app_colors.dart';
import '../../core/enums/status.dart';
import '../../models/task_model.dart';
import '../../models/user_model.dart';
import '../common/status_badge.dart';
import '../dialogs/add_task_dialog.dart';

class ProfileSheet extends StatelessWidget {
  final UserModel user;
  final List<TaskModel> tasks;
  final String? assignedAdminName;
  final void Function(TaskModel)? onAddTask;

  const ProfileSheet({
    super.key,
    required this.user,
    required this.tasks,
    this.assignedAdminName,
    this.onAddTask,
  });

  static void show(
    BuildContext context, {
    required UserModel user,
    required List<TaskModel> tasks,
    String? assignedAdminName,
    void Function(TaskModel)? onAddTask,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProfileSheet(
        user: user,
        tasks: tasks,
        assignedAdminName: assignedAdminName,
        onAddTask: onAddTask,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.darkDivider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                  children: [
                    _buildProfileHeader(context),
                    const SizedBox(height: 20),
                    _buildInfoSection(),
                    const SizedBox(height: 16),
                    _buildSkillsSection(),
                    const SizedBox(height: 16),
                    _buildTasksSection(context),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final color = _avatarColor(user.name);
    final tenure = _tenureString(user.joinedDate);
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primaryTeal, width: 3),
          ),
          child: Center(
            child: Text(
              user.initials,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          user.name,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        StatusBadge.active(),
        const SizedBox(height: 8),
        if (assignedAdminName != null)
          Text(
            'Assigned to: $assignedAdminName',
            style: GoogleFonts.poppins(
              color: AppColors.darkTextSecondary,
              fontSize: 12,
            ),
          ),
        Text(
          tenure,
          style: GoogleFonts.poppins(
            color: AppColors.primaryTeal,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.email_outlined, user.email),
          const Divider(color: AppColors.darkDivider, height: 20),
          _buildInfoRow(Icons.phone_outlined, user.phone),
          const Divider(color: AppColors.darkDivider, height: 20),
          _buildInfoRow(Icons.location_on_outlined, user.location),
          const Divider(color: AppColors.darkDivider, height: 20),
          _buildInfoRow(
            Icons.calendar_today_outlined,
            'Joined ${DateFormat('dd MMM yyyy').format(user.joinedDate)}',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryTeal, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: AppColors.darkTextSecondary,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsSection() {
    if (user.skills.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Skills',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: user.skills
              .map((skill) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal.withAlpha(20),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColors.primaryTeal.withAlpha(80)),
                    ),
                    child: Text(
                      skill,
                      style: GoogleFonts.poppins(
                        color: AppColors.primaryTeal,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildTasksSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Assigned Tasks (${tasks.length})',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            if (onAddTask != null)
              TextButton.icon(
                onPressed: () => AddTaskDialog.show(
                  context,
                  userName: user.name,
                  onAssign: (task) => onAddTask?.call(task),
                ),
                icon: const Icon(Icons.add, size: 16, color: AppColors.primaryTeal),
                label: Text(
                  'Add Task',
                  style: GoogleFonts.poppins(
                    color: AppColors.primaryTeal,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        if (tasks.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'No tasks assigned yet.',
                style: GoogleFonts.poppins(
                  color: AppColors.darkTextHint,
                  fontSize: 13,
                ),
              ),
            ),
          )
        else
          ...tasks.map((task) => _buildTaskRow(task)),
      ],
    );
  }

  Widget _buildTaskRow(TaskModel task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.darkDivider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: _taskStatusColor(task.status),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Due: ${DateFormat('dd MMM yyyy').format(task.deadline)}',
                  style: GoogleFonts.poppins(
                    color: task.isOverdue
                        ? AppColors.error
                        : AppColors.darkTextSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          StatusBadge.fromTaskStatus(task.status),
        ],
      ),
    );
  }

  Color _taskStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return AppColors.statusPending;
      case TaskStatus.submitted:
        return AppColors.statusSubmitted;
      case TaskStatus.approved:
        return AppColors.statusApproved;
      case TaskStatus.rejected:
        return AppColors.statusRejected;
    }
  }

  Color _avatarColor(String name) {
    const colors = [
      AppColors.primaryTeal,
      AppColors.secondaryOrange,
      AppColors.secondaryPurple,
      AppColors.secondaryBlue,
      Color(0xFF43A047),
    ];
    final hash = name.codeUnits.fold(0, (sum, c) => sum + c);
    return colors[hash % colors.length];
  }

  String _tenureString(DateTime joinedDate) {
    final diff = DateTime.now().difference(joinedDate);
    final months = (diff.inDays / 30).floor();
    if (months < 1) return 'Member for less than a month';
    if (months < 12) return 'Member for $months month${months > 1 ? 's' : ''}';
    final years = (months / 12).floor();
    return 'Member for $years year${years > 1 ? 's' : ''}';
  }
}
