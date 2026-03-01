import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../config/theme/app_colors.dart';
import '../../core/enums/status.dart';
import '../../models/meeting_model.dart';
import '../common/status_badge.dart';

class MeetingCard extends StatelessWidget {
  final MeetingModel meeting;
  final List<Color> attendeeColors;
  final VoidCallback? onTap;
  final VoidCallback? onViewSummary;

  const MeetingCard({
    super.key,
    required this.meeting,
    this.attendeeColors = const [],
    this.onTap,
    this.onViewSummary,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = meeting.status == MeetingStatus.completed;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.darkDivider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.statusCompleted.withAlpha(25)
                        : AppColors.statusScheduled.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isCompleted
                        ? Icons.meeting_room
                        : Icons.event_available_outlined,
                    color: isCompleted
                        ? AppColors.statusCompleted
                        : AppColors.statusScheduled,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meeting.title,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 12, color: AppColors.darkTextHint),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('dd MMM yyyy, hh:mm a')
                                .format(meeting.dateTime),
                            style: GoogleFonts.poppins(
                              color: AppColors.darkTextSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                StatusBadge.fromMeetingStatus(meeting.status),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(color: AppColors.darkDivider, height: 1),
            const SizedBox(height: 12),

            Row(
              children: [
                // Attendee avatars
                _buildAttendeeAvatars(),
                const SizedBox(width: 8),
                Text(
                  '${meeting.attendeeIds.length} attendee${meeting.attendeeIds.length != 1 ? 's' : ''}',
                  style: GoogleFonts.poppins(
                    color: AppColors.darkTextSecondary,
                    fontSize: 12,
                  ),
                ),

                const Spacer(),

                // View summary button for completed meetings
                if (isCompleted && onViewSummary != null)
                  GestureDetector(
                    onTap: onViewSummary,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.statusCompleted.withAlpha(25),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: AppColors.statusCompleted.withAlpha(80)),
                      ),
                      child: Text(
                        'View Summary',
                        style: GoogleFonts.poppins(
                          color: AppColors.statusCompleted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // MOM submitted by
            if (meeting.momSubmittedBy != null && meeting.momSubmittedBy!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person_outline,
                      size: 12, color: AppColors.darkTextHint),
                  const SizedBox(width: 4),
                  Text(
                    'MOM by: ${meeting.momSubmittedBy}',
                    style: GoogleFonts.poppins(
                      color: AppColors.darkTextHint,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAttendeeAvatars() {
    const maxVisible = 3;
    final total = meeting.attendeeIds.length;
    final shown = total > maxVisible ? maxVisible : total;
    const avatarColors = [
      AppColors.primaryTeal,
      AppColors.secondaryOrange,
      AppColors.secondaryPurple,
      AppColors.secondaryBlue,
      Color(0xFF43A047),
    ];

    return SizedBox(
      width: shown * 20.0 + (total > maxVisible ? 22 : 0),
      height: 28,
      child: Stack(
        children: [
          ...List.generate(shown, (i) {
            final color = i < attendeeColors.length
                ? attendeeColors[i]
                : avatarColors[i % avatarColors.length];
            return Positioned(
              left: i * 18.0,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.darkCard, width: 1.5),
                ),
              ),
            );
          }),
          if (total > maxVisible)
            Positioned(
              left: shown * 18.0,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: _darkSurface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.darkCard, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    '+${total - maxVisible}',
                    style: GoogleFonts.poppins(
                      color: AppColors.darkTextSecondary,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Use the darkSurface color directly from AppColors
const Color _darkSurface = Color(0xFF0F3460);
