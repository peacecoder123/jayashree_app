import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme/app_colors.dart';
import '../../models/meeting_model.dart';
import '../../providers/app_data_provider.dart';
import '../../widgets/cards/meeting_card.dart';

class VolunteerMinutesOfMeetingScreen extends StatelessWidget {
  const VolunteerMinutesOfMeetingScreen({super.key});

  void _showViewSummaryDialog(
      BuildContext context, MeetingModel meeting) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: Text('MOM Summary',
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(meeting.title,
                style: GoogleFonts.poppins(
                    color: AppColors.primaryTeal,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(
              DateFormat('dd MMM yyyy, hh:mm a')
                  .format(meeting.dateTime),
              style: GoogleFonts.poppins(
                  color: AppColors.darkTextSecondary,
                  fontSize: 12),
            ),
            const SizedBox(height: 12),
            const Divider(color: AppColors.darkDivider),
            const SizedBox(height: 8),
            Text(
              meeting.momSummary ?? '',
              style: GoogleFonts.poppins(
                  color: AppColors.darkTextSecondary,
                  fontSize: 13,
                  height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Close',
                style: GoogleFonts.poppins(
                    color: AppColors.primaryTeal)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppDataProvider>();
    final upcoming = data.upcomingMeetings;
    final past = data.pastMeetings;

    return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Minutes of Meeting',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(
                    '${upcoming.length} upcoming · ${past.length} completed',
                    style: GoogleFonts.poppins(
                        color: AppColors.darkTextSecondary,
                        fontSize: 13),
                  ),
                  const SizedBox(height: 16),

                  // Info banner for view-only
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.info.withAlpha(20),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.info.withAlpha(80)),
                    ),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline,
                            color: AppColors.info, size: 16),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Meetings are visible to you in view-only mode. Meeting summaries can only be added by Members.',
                            style: GoogleFonts.poppins(
                                color:
                                    AppColors.darkTextSecondary,
                                fontSize: 12,
                                height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // ── Upcoming ──────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _SectionHeader(
                label: 'Upcoming Meetings',
                icon: Icons.calendar_today),
          ),
          if (upcoming.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: _NoItemsNote(
                    message: 'No upcoming meetings'),
              ),
            )
          else
            SliverPadding(
              padding:
                  const EdgeInsets.fromLTRB(20, 0, 20, 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => MeetingCard(
                    meeting: upcoming[i],
                    attendeeColors: const [
                      AppColors.primaryTeal,
                      AppColors.secondaryBlue,
                      AppColors.secondaryOrange,
                    ],
                  ),
                  childCount: upcoming.length,
                ),
              ),
            ),

          // ── Past ──────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _SectionHeader(
                label: 'Past Meetings', icon: Icons.history),
          ),
          if (past.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20),
                child:
                    _NoItemsNote(message: 'No past meetings'),
              ),
            )
          else
            SliverPadding(
              padding:
                  const EdgeInsets.fromLTRB(20, 0, 20, 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final meeting = past[i];
                    final hasMom =
                        meeting.momSummary != null &&
                            meeting.momSummary!.isNotEmpty;
                    return Column(
                      children: [
                        MeetingCard(
                          meeting: meeting,
                          attendeeColors: const [
                            AppColors.primaryTeal,
                            AppColors.secondaryBlue,
                          ],
                          onViewSummary: hasMom
                              ? () => _showViewSummaryDialog(
                                  context, meeting)
                              : null,
                        ),
                        if (hasMom)
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 12),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      _showViewSummaryDialog(
                                          context, meeting),
                                  child: Text(
                                    'View Summary →',
                                    style: GoogleFonts.poppins(
                                        color: AppColors
                                            .primaryTeal,
                                        fontSize: 12,
                                        fontWeight:
                                            FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                  childCount: past.length,
                ),
              ),
            ),
          ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final IconData icon;
  const _SectionHeader(
      {required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(8),
          border: const Border(
            left:
                BorderSide(color: AppColors.primaryTeal, width: 4),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryTeal, size: 16),
            const SizedBox(width: 8),
            Text(label,
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _NoItemsNote extends StatelessWidget {
  final String message;
  const _NoItemsNote({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline,
              color: AppColors.darkTextHint, size: 16),
          const SizedBox(width: 8),
          Text(message,
              style: GoogleFonts.poppins(
                  color: AppColors.darkTextSecondary,
                  fontSize: 13)),
        ],
      ),
    );
  }
}
