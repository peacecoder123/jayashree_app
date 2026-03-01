import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme/app_colors.dart';
import '../../core/enums/status.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
  });

  // ─── Factory constructors ─────────────────────────────────────────────────
  factory StatusBadge.fromTaskStatus(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return const StatusBadge(
            label: 'Pending', color: AppColors.statusPending);
      case TaskStatus.submitted:
        return const StatusBadge(
            label: 'Submitted', color: AppColors.statusSubmitted);
      case TaskStatus.approved:
        return const StatusBadge(
            label: 'Approved', color: AppColors.statusApproved);
      case TaskStatus.rejected:
        return const StatusBadge(
            label: 'Rejected', color: AppColors.statusRejected);
    }
  }

  factory StatusBadge.fromRequestStatus(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return const StatusBadge(
            label: 'Pending', color: AppColors.statusPending);
      case RequestStatus.approved:
        return const StatusBadge(
            label: 'Approved', color: AppColors.statusApproved);
      case RequestStatus.rejected:
        return const StatusBadge(
            label: 'Rejected', color: AppColors.statusRejected);
    }
  }

  factory StatusBadge.fromMouStatus(MouStatus status) {
    switch (status) {
      case MouStatus.pending:
        return const StatusBadge(
            label: 'Pending', color: AppColors.statusPending);
      case MouStatus.approved:
        return const StatusBadge(
            label: 'Approved', color: AppColors.statusApproved);
      case MouStatus.rejected:
        return const StatusBadge(
            label: 'Rejected', color: AppColors.statusRejected);
    }
  }

  factory StatusBadge.fromMeetingStatus(MeetingStatus status) {
    switch (status) {
      case MeetingStatus.scheduled:
        return const StatusBadge(
            label: 'Scheduled', color: AppColors.statusScheduled);
      case MeetingStatus.completed:
        return const StatusBadge(
            label: 'Completed', color: AppColors.statusCompleted);
    }
  }

  factory StatusBadge.active() =>
      const StatusBadge(label: 'Active', color: AppColors.statusActive);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
