import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:hopeconnect/config/theme/app_colors.dart';
import 'package:hopeconnect/core/enums/status.dart';
import 'package:hopeconnect/models/donation_model.dart';
import 'package:hopeconnect/providers/app_data_provider.dart';
import 'package:hopeconnect/widgets/charts/donation_trend_chart.dart';
import 'package:hopeconnect/widgets/charts/task_status_chart.dart';
import 'package:hopeconnect/widgets/common/stat_card.dart';

class OverviewTab extends StatelessWidget {
  final bool isSuperAdmin;
  const OverviewTab({super.key, required this.isSuperAdmin});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppDataProvider>();

    final volunteers = data.volunteers;
    final members = data.members;
    final total = data.totalDonations;

    final pendingRequests =
        data.joiningLetters.where((l) => l.status == RequestStatus.pending).length +
            data.certificates.where((c) => c.status == RequestStatus.pending).length +
            data.mouRequests.where((m) => m.status == MouStatus.pending).length;

    final pendingTasks = data.tasks.where((t) => t.status == TaskStatus.pending).length;
    final submittedTasks = data.tasks.where((t) => t.status == TaskStatus.submitted).length;
    final approvedTasks = data.tasks.where((t) => t.status == TaskStatus.approved).length;
    final rejectedTasks = data.tasks.where((t) => t.status == TaskStatus.rejected).length;

    final fmt = NumberFormat('#,##,###', 'en_IN');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ─────────────────────────────────────────────────────────
          Text(
            isSuperAdmin ? 'Super Admin Dashboard - HopeConnect NGO' : 'Admin Dashboard - HopeConnect NGO',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Welcome back! Here\'s what\'s happening today.',
            style: GoogleFonts.poppins(color: AppColors.darkTextSecondary, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // ── Hero Banner ────────────────────────────────────────────────────
          _HeroBanner(
            activeVolunteers: volunteers.length,
            activeMembers: members.length,
            pendingRequests: pendingRequests,
          ),
          const SizedBox(height: 20),

          // ── Stat Cards (2 × 2) ─────────────────────────────────────────────
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.45,
            children: [
              StatCard(
                icon: Icons.volunteer_activism,
                iconColor: AppColors.primaryTeal,
                title: 'Active Volunteers',
                value: '${volunteers.length}',
                subtitle: '${volunteers.length} of ${volunteers.length} active',
                progressValue: 1.0,
              ),
              StatCard(
                icon: Icons.group,
                iconColor: AppColors.secondaryBlue,
                title: 'Active Members',
                value: '${members.length}',
                subtitle: 'Total enrolled',
              ),
              StatCard(
                icon: Icons.currency_rupee,
                iconColor: AppColors.secondaryOrange,
                title: 'Total Donations',
                value: '₹${fmt.format(total.toInt())}',
                subtitle: 'All time',
              ),
              StatCard(
                icon: Icons.pending_actions,
                iconColor: AppColors.secondaryRed,
                title: 'Pending Requests',
                value: '$pendingRequests',
                subtitle: 'Awaiting action',
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Donation Trend Chart ───────────────────────────────────────────
          DonationTrendChart(
            values: const [42000, 55000, 38000, 72000, 89000],
            labels: const ['Oct', 'Nov', 'Dec', 'Jan', 'Feb'],
            changePercent: 23.0,
          ),
          const SizedBox(height: 20),

          // ── Task Status Chart ──────────────────────────────────────────────
          TaskStatusChart(
            pending: pendingTasks,
            submitted: submittedTasks,
            approved: approvedTasks,
            rejected: rejectedTasks,
          ),
          const SizedBox(height: 20),

          // ── Recent Activity ────────────────────────────────────────────────
          _RecentActivitySection(data: data),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ─── Hero Banner ─────────────────────────────────────────────────────────────

class _HeroBanner extends StatelessWidget {
  final int activeVolunteers;
  final int activeMembers;
  final int pendingRequests;

  const _HeroBanner({
    required this.activeVolunteers,
    required this.activeMembers,
    required this.pendingRequests,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F3460), Color(0xFF16213E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(Icons.favorite, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'HopeConnect NGO',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Making a difference together',
                    style: GoogleFonts.poppins(
                      color: AppColors.darkTextSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MiniStat(value: '$activeVolunteers', label: 'Active\nVolunteers', color: AppColors.primaryTeal),
              _divider(),
              _MiniStat(value: '$activeMembers', label: 'Active\nMembers', color: AppColors.secondaryBlue),
              _divider(),
              _MiniStat(value: '$pendingRequests', label: 'Pending\nRequests', color: AppColors.secondaryOrange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(width: 1, height: 40, color: AppColors.darkDivider);
}

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _MiniStat({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(color: color, fontSize: 28, fontWeight: FontWeight.w800),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(color: AppColors.darkTextSecondary, fontSize: 11),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ─── Recent Activity ──────────────────────────────────────────────────────────

class _RecentActivitySection extends StatelessWidget {
  final AppDataProvider data;
  const _RecentActivitySection({required this.data});

  @override
  Widget build(BuildContext context) {
    final activities = _buildActivities();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.darkDivider),
          ),
          child: Column(
            children: activities
                .take(5)
                .map((a) => _ActivityTile(item: a))
                .toList(),
          ),
        ),
      ],
    );
  }

  List<_ActivityData> _buildActivities() {
    final list = <_ActivityData>[];

    // Submitted tasks
    for (final task in data.tasks.where((t) => t.status == TaskStatus.submitted).take(2)) {
      final user = data.getUserById(task.assignedToId);
      list.add(_ActivityData(
        icon: Icons.task_alt,
        color: AppColors.secondaryBlue,
        title: 'Task submitted: ${task.title}',
        subtitle: user?.name ?? 'Unknown',
        date: task.createdAt,
      ));
    }

    // Recent member/volunteer joins
    final sorted = [...data.members, ...data.volunteers]
      ..sort((a, b) => b.joinedDate.compareTo(a.joinedDate));
    for (final user in sorted.take(2)) {
      list.add(_ActivityData(
        icon: Icons.person_add,
        color: AppColors.primaryTeal,
        title: '${user.displayRole} joined: ${user.name}',
        subtitle: user.location,
        date: user.joinedDate,
      ));
    }

    // Recent donations
    final recentDonations = List<DonationModel>.from(data.donations)
      ..sort((a, b) => b.date.compareTo(a.date));
    for (final d in recentDonations.take(2)) {
      list.add(_ActivityData(
        icon: Icons.volunteer_activism,
        color: AppColors.secondaryOrange,
        title: 'Donation received: ${d.formattedAmount}',
        subtitle: d.donorName,
        date: d.date,
      ));
    }

    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }
}

class _ActivityData {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final DateTime date;

  const _ActivityData({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.date,
  });
}

class _ActivityTile extends StatelessWidget {
  final _ActivityData item;
  const _ActivityTile({required this.item});

  String get _timeAgo {
    final diff = DateTime.now().difference(item.date);
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()}mo ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: item.color.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, color: item.color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item.subtitle,
                  style: GoogleFonts.poppins(color: AppColors.darkTextSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _timeAgo,
            style: GoogleFonts.poppins(color: AppColors.darkTextHint, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
