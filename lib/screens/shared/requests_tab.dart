import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:jayshree_foundation/config/theme/app_colors.dart';
import 'package:jayshree_foundation/core/enums/status.dart';
import 'package:jayshree_foundation/providers/app_data_provider.dart';
import 'package:jayshree_foundation/widgets/common/status_badge.dart';

// Unified request item model
class _RequestItem {
  final String id;
  final String requesterName;
  final String requestType;
  final DateTime date;
  final String statusLabel;
  final Color statusColor;
  final bool isPending;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const _RequestItem({
    required this.id,
    required this.requesterName,
    required this.requestType,
    required this.date,
    required this.statusLabel,
    required this.statusColor,
    required this.isPending,
    this.onApprove,
    this.onReject,
  });
}

class RequestsTab extends StatefulWidget {
  const RequestsTab({super.key});

  @override
  State<RequestsTab> createState() => _RequestsTabState();
}

class _RequestsTabState extends State<RequestsTab> {
  // 0=All, 1=Joining Letters, 2=Certificates, 3=MOU Requests
  int _filterIndex = 0;

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppDataProvider>();

    final pendingJL = data.joiningLetters.where((l) => l.status == RequestStatus.pending).length;
    final pendingCerts = data.certificates.where((c) => c.status == RequestStatus.pending).length;
    final pendingMou = data.mouRequests.where((m) => m.status == MouStatus.pending).length;
    final totalPending = pendingJL + pendingCerts + pendingMou;

    final requests = _buildRequests(context, data);

    final filtered = requests.where((r) {
      if (_filterIndex == 0) return true;
      if (_filterIndex == 1) return r.requestType == 'Joining Letter';
      if (_filterIndex == 2) return r.requestType == 'Certificate';
      if (_filterIndex == 3) return r.requestType == 'MOU Request';
      return true;
    }).toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ────────────────────────────────────────────────────
                Row(
                  children: [
                    Text(
                      'Requests',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (totalPending > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryRed,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$totalPending pending',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // ── Filter tabs ───────────────────────────────────────────────
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _filterTab('All', 0, totalPending),
                      const SizedBox(width: 8),
                      _filterTab('Joining Letters', 1, pendingJL),
                      const SizedBox(width: 8),
                      _filterTab('Certificates', 2, pendingCerts),
                      const SizedBox(width: 8),
                      _filterTab('MOU Requests', 3, pendingMou),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),

        // ── List ──────────────────────────────────────────────────────────────
        filtered.isEmpty
            ? SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Center(
                    child: Text(
                      'No requests found',
                      style: GoogleFonts.poppins(color: AppColors.darkTextSecondary),
                    ),
                  ),
                ),
              )
            : SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _RequestCard(item: filtered[index]),
                    ),
                    childCount: filtered.length,
                  ),
                ),
              ),
      ],
    );
  }

  Widget _filterTab(String label, int index, int badgeCount) {
    final isSelected = _filterIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _filterIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryTeal : AppColors.darkCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primaryTeal : AppColors.darkDivider,
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                color: isSelected ? Colors.white : AppColors.darkTextSecondary,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            if (badgeCount > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withAlpha(50)
                      : AppColors.secondaryRed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$badgeCount',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<_RequestItem> _buildRequests(BuildContext context, AppDataProvider data) {
    final items = <_RequestItem>[];

    // ── Joining letters ───────────────────────────────────────────────────────
    for (final letter in data.joiningLetters) {
      final user = data.getUserById(letter.requestedById);
      items.add(_RequestItem(
        id: letter.id,
        requesterName: user?.name ?? 'Unknown',
        requestType: 'Joining Letter',
        date: letter.requestedDate,
        statusLabel: letter.statusLabel,
        statusColor: _statusColor(letter.status.name),
        isPending: letter.status == RequestStatus.pending,
        onApprove: letter.status == RequestStatus.pending
            ? () => data.updateJoiningLetter(
                letter.copyWith(status: RequestStatus.approved))
            : null,
        onReject: letter.status == RequestStatus.pending
            ? () => data.updateJoiningLetter(
                letter.copyWith(status: RequestStatus.rejected))
            : null,
      ));
    }

    // ── Certificates ──────────────────────────────────────────────────────────
    for (final cert in data.certificates) {
      final user = data.getUserById(cert.requestedById);
      items.add(_RequestItem(
        id: cert.id,
        requesterName: user?.name ?? 'Unknown',
        requestType: 'Certificate',
        date: cert.requestedDate,
        statusLabel: cert.statusLabel,
        statusColor: _statusColor(cert.status.name),
        isPending: cert.status == RequestStatus.pending,
        onApprove: cert.status == RequestStatus.pending
            ? () => data.updateCertificate(cert.copyWith(status: RequestStatus.approved))
            : null,
        onReject: cert.status == RequestStatus.pending
            ? () => data.updateCertificate(cert.copyWith(status: RequestStatus.rejected))
            : null,
      ));
    }

    // ── MOU Requests ──────────────────────────────────────────────────────────
    for (final mou in data.mouRequests) {
      final user = data.getUserById(mou.submittedById);
      items.add(_RequestItem(
        id: mou.id,
        requesterName: user?.name ?? mou.patientName,
        requestType: 'MOU Request',
        date: mou.submittedDate,
        statusLabel: mou.statusLabel,
        statusColor: _statusColor(mou.status.name),
        isPending: mou.status == MouStatus.pending,
        onApprove: mou.status == MouStatus.pending
            ? () => data.updateMouRequest(mou.copyWith(status: MouStatus.approved))
            : null,
        onReject: mou.status == MouStatus.pending
            ? () => data.updateMouRequest(mou.copyWith(status: MouStatus.rejected))
            : null,
      ));
    }

    // Sort: pending first, then by date descending
    items.sort((a, b) {
      if (a.isPending && !b.isPending) return -1;
      if (!a.isPending && b.isPending) return 1;
      return b.date.compareTo(a.date);
    });
    return items;
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.statusPending;
      case 'approved':
        return AppColors.statusApproved;
      case 'rejected':
        return AppColors.statusRejected;
      default:
        return AppColors.darkTextSecondary;
    }
  }
}

// ─── Request Card ─────────────────────────────────────────────────────────────

class _RequestCard extends StatelessWidget {
  final _RequestItem item;
  const _RequestCard({required this.item});

  IconData get _typeIcon {
    switch (item.requestType) {
      case 'Joining Letter':
        return Icons.mail_outline;
      case 'Certificate':
        return Icons.workspace_premium_outlined;
      case 'MOU Request':
        return Icons.handshake_outlined;
      default:
        return Icons.description_outlined;
    }
  }

  Color get _typeColor {
    switch (item.requestType) {
      case 'Joining Letter':
        return AppColors.primaryTeal;
      case 'Certificate':
        return AppColors.secondaryPurple;
      case 'MOU Request':
        return AppColors.secondaryOrange;
      default:
        return AppColors.darkTextSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item.isPending ? AppColors.statusPending.withAlpha(60) : AppColors.darkDivider,
        ),
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
                  color: _typeColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(_typeIcon, color: _typeColor, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.requesterName,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: _typeColor.withAlpha(20),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: _typeColor.withAlpha(60)),
                          ),
                          child: Text(
                            item.requestType,
                            style: GoogleFonts.poppins(
                                color: _typeColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              StatusBadge(label: item.statusLabel, color: item.statusColor),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.access_time, size: 13, color: AppColors.darkTextHint),
              const SizedBox(width: 4),
              Text(
                DateFormat('dd MMM yyyy').format(item.date),
                style: GoogleFonts.poppins(color: AppColors.darkTextSecondary, fontSize: 12),
              ),
            ],
          ),

          // Action buttons
          if (item.isPending) ...[
            const SizedBox(height: 12),
            const Divider(color: AppColors.darkDivider, height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      item.onApprove?.call();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Request approved'),
                          backgroundColor: AppColors.statusApproved,
                        ),
                      );
                    },
                    icon: const Icon(Icons.check, size: 16, color: Colors.white),
                    label: Text('Approve',
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.statusApproved,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      item.onReject?.call();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Request rejected'),
                          backgroundColor: AppColors.secondaryRed,
                        ),
                      );
                    },
                    icon: const Icon(Icons.close, size: 16, color: AppColors.secondaryRed),
                    label: Text('Reject',
                        style: GoogleFonts.poppins(
                            color: AppColors.secondaryRed, fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.secondaryRed),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
