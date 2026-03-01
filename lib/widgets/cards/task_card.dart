import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../config/theme/app_colors.dart';
import '../../core/enums/status.dart';
import '../../models/task_model.dart';
import '../common/status_badge.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;
  final VoidCallback? onMarkComplete;
  final VoidCallback? onUploadPhoto;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onMarkComplete,
    this.onUploadPhoto,
  });

  @override
  Widget build(BuildContext context) {
    final isOverdue = task.isOverdue;
    final overdueDays = isOverdue
        ? DateTime.now().difference(task.deadline).inDays
        : 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isOverdue
                ? AppColors.error.withAlpha(80)
                : AppColors.darkDivider,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: icon + title + badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: _taskColor().withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _taskIcon(),
                    color: _taskColor(),
                    size: 20,
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
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        task.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          color: AppColors.darkTextSecondary,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                StatusBadge.fromTaskStatus(task.status),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(color: AppColors.darkDivider, height: 1),
            const SizedBox(height: 12),

            // Footer row: due date + actions
            Row(
              children: [
                // Due date
                Icon(
                  Icons.calendar_today_outlined,
                  size: 13,
                  color:
                      isOverdue ? AppColors.error : AppColors.darkTextSecondary,
                ),
                const SizedBox(width: 5),
                if (isOverdue)
                  Text(
                    'Overdue by $overdueDays day${overdueDays != 1 ? 's' : ''}',
                    style: GoogleFonts.poppins(
                      color: AppColors.error,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                else
                  Text(
                    'Due: ${DateFormat('dd MMM yyyy').format(task.deadline)}',
                    style: GoogleFonts.poppins(
                      color: AppColors.darkTextSecondary,
                      fontSize: 11,
                    ),
                  ),

                const Spacer(),

                // Photo upload indicator
                if (task.requiresPhotoUpload) ...[
                  GestureDetector(
                    onTap: onUploadPhoto,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: task.photoUrl != null
                            ? AppColors.statusApproved.withAlpha(25)
                            : AppColors.secondaryOrange.withAlpha(25),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: task.photoUrl != null
                              ? AppColors.statusApproved.withAlpha(80)
                              : AppColors.secondaryOrange.withAlpha(80),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            task.photoUrl != null
                                ? Icons.check_circle_outline
                                : Icons.camera_alt_outlined,
                            size: 12,
                            color: task.photoUrl != null
                                ? AppColors.statusApproved
                                : AppColors.secondaryOrange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            task.photoUrl != null ? 'Photo ✓' : 'Photo',
                            style: GoogleFonts.poppins(
                              color: task.photoUrl != null
                                  ? AppColors.statusApproved
                                  : AppColors.secondaryOrange,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],

                // Mark complete button (only for pending)
                if (task.status == TaskStatus.pending && onMarkComplete != null)
                  GestureDetector(
                    onTap: onMarkComplete,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Mark Complete',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _taskIcon() {
    switch (task.status) {
      case TaskStatus.approved:
        return Icons.check_circle_outline;
      case TaskStatus.rejected:
        return Icons.cancel_outlined;
      case TaskStatus.submitted:
        return Icons.upload_file_outlined;
      case TaskStatus.pending:
        return Icons.assignment_outlined;
    }
  }

  Color _taskColor() {
    switch (task.status) {
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
}
