import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme/app_colors.dart';
import '../../core/enums/status.dart';
import '../../models/meeting_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_data_provider.dart';
import '../../widgets/cards/meeting_card.dart';
import '../../widgets/common/status_badge.dart';

class MemberMinutesOfMeetingScreen extends StatelessWidget {
  const MemberMinutesOfMeetingScreen({super.key});

  Future<void> _showAddMomDialog(
      BuildContext context, MeetingModel meeting, AppDataProvider data,
      String userId) async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.darkCard,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add MOM Summary',
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(meeting.title,
                  style: GoogleFonts.poppins(
                      color: AppColors.darkTextSecondary, fontSize: 12)),
            ],
          ),
          content: TextField(
            controller: controller,
            maxLines: 6,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText:
                  'Write the minutes of the meeting here...',
              hintStyle: GoogleFonts.poppins(
                  color: AppColors.darkTextHint, fontSize: 12),
              filled: true,
              fillColor: AppColors.darkSurface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: AppColors.darkDivider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: AppColors.primaryTeal),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel',
                  style: GoogleFonts.poppins(
                      color: AppColors.darkTextSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal),
              onPressed: () {
                if (controller.text.trim().isEmpty) return;
                data.updateMeeting(meeting.copyWith(
                  momSummary: controller.text.trim(),
                  momSubmittedBy: userId,
                  status: MeetingStatus.completed,
                ));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('MOM summary submitted'),
                    backgroundColor: AppColors.primaryTeal,
                  ),
                );
              },
              child: Text('Submit',
                  style: GoogleFonts.poppins(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showViewSummaryDialog(BuildContext context, MeetingModel meeting) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('MOM Summary',
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w600)),
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
              DateFormat('dd MMM yyyy, hh:mm a').format(meeting.dateTime),
              style: GoogleFonts.poppins(
                  color: AppColors.darkTextSecondary, fontSize: 12),
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
    final auth = context.watch<AuthProvider>();
    final data = context.watch<AppDataProvider>();
    final userId = auth.currentUser?.id ?? '';
    final upcoming = data.upcomingMeetings;
    final past = data.pastMeetings;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: CustomScrollView(
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
                        color: AppColors.darkTextSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // ── Upcoming Meetings ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _SectionHeader(
                label: 'Upcoming Meetings', icon: Icons.calendar_today),
          ),
          if (upcoming.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: _NoItemsNote(message: 'No upcoming meetings'),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
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

          // ── Past Meetings ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _SectionHeader(
                label: 'Past Meetings', icon: Icons.history),
          ),
          if (past.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: _NoItemsNote(message: 'No past meetings'),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final meeting = past[i];
                    final hasMom = meeting.momSummary != null &&
                        meeting.momSummary!.isNotEmpty;
                    final submittedByMe =
                        meeting.momSubmittedBy == userId;

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
                        if (!hasMom)
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 12),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.end,
                              children: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppColors.primaryTeal,
                                    padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                                8)),
                                  ),
                                  onPressed: () =>
                                      _showAddMomDialog(
                                          context,
                                          meeting,
                                          data,
                                          userId),
                                  icon: const Icon(Icons.add,
                                      size: 16, color: Colors.white),
                                  label: Text('Add MOM Summary',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight:
                                              FontWeight.w600)),
                                ),
                              ],
                            ),
                          ),
                        if (hasMom)
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 12),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => _showViewSummaryDialog(
                                      context, meeting),
                                  child: Text(
                                    'View Summary →',
                                    style: GoogleFonts.poppins(
                                        color: AppColors.primaryTeal,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (submittedByMe)
                                  Text('(You submitted)',
                                      style: GoogleFonts.poppins(
                                          color:
                                              AppColors.darkTextHint,
                                          fontSize: 11))
                                else if (meeting.momSubmittedBy !=
                                    null)
                                  Text('(Submitted by member)',
                                      style: GoogleFonts.poppins(
                                          color:
                                              AppColors.darkTextHint,
                                          fontSize: 11)),
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
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final IconData icon;

  const _SectionHeader({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(8),
          border: const Border(
            left: BorderSide(color: AppColors.primaryTeal, width: 4),
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
                  color: AppColors.darkTextSecondary, fontSize: 13)),
        ],
      ),
    );
  }
}
