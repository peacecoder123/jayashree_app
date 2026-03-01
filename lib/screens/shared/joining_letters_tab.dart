import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:hopeconnect/config/theme/app_colors.dart';
import 'package:hopeconnect/core/enums/status.dart';
import 'package:hopeconnect/core/enums/user_role.dart';
import 'package:hopeconnect/models/joining_letter_model.dart';
import 'package:hopeconnect/providers/app_data_provider.dart';
import 'package:hopeconnect/providers/auth_provider.dart';
import 'package:hopeconnect/widgets/common/status_badge.dart';

class JoiningLettersTab extends StatefulWidget {
  const JoiningLettersTab({super.key});

  @override
  State<JoiningLettersTab> createState() => _JoiningLettersTabState();
}

class _JoiningLettersTabState extends State<JoiningLettersTab> {
  // 0 = All, 1 = Volunteer (Monthly), 2 = Member (Annual)
  int _filterIndex = 0;

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppDataProvider>();
    final auth = context.watch<AuthProvider>();

    final allLetters = data.joiningLetters;
    final pendingCount =
        allLetters.where((l) => l.status == RequestStatus.pending).length;

    // Apply filter
    final filtered = allLetters.where((l) {
      if (_filterIndex == 0) return true;
      if (_filterIndex == 1) return l.tenureType == 'Monthly';
      if (_filterIndex == 2) return l.tenureType == 'Annual';
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
                      'Joining Letters',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (pendingCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryRed,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$pendingCount pending',
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
                Row(
                  children: [
                    _FilterTab(
                        label: 'All',
                        isSelected: _filterIndex == 0,
                        onTap: () => setState(() => _filterIndex = 0)),
                    const SizedBox(width: 8),
                    _FilterTab(
                        label: 'Volunteer (Monthly)',
                        isSelected: _filterIndex == 1,
                        onTap: () => setState(() => _filterIndex = 1)),
                    const SizedBox(width: 8),
                    _FilterTab(
                        label: 'Member (Annual)',
                        isSelected: _filterIndex == 2,
                        onTap: () => setState(() => _filterIndex = 2)),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),

        // ── List ──────────────────────────────────────────────────────────────
        filtered.isEmpty
            ? SliverFillRemaining(
                child: Center(
                  child: Text(
                    'No joining letters found',
                    style: GoogleFonts.poppins(color: AppColors.darkTextSecondary),
                  ),
                ),
              )
            : SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final letter = filtered[index];
                      final requester = data.getUserById(letter.requestedById);
                      final generatedByUser = letter.generatedById != null
                          ? data.getUserById(letter.generatedById!)
                          : null;
                      final isGeneratedByOther = letter.generatedById != null &&
                          letter.generatedById != auth.currentUser?.id;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _JoiningLetterCard(
                          letter: letter,
                          requesterName: requester?.name ?? 'Unknown',
                          requesterRole: requester?.role ?? UserRole.volunteer,
                          generatedByName: generatedByUser?.name,
                          isGeneratedByOther: isGeneratedByOther,
                          onGenerate: letter.status == RequestStatus.pending
                              ? () => _showGenerateDialog(
                                  context, letter, data, auth)
                              : null,
                          onReject: letter.status == RequestStatus.pending
                              ? () => _rejectLetter(context, letter, data)
                              : null,
                        ),
                      );
                    },
                    childCount: filtered.length,
                  ),
                ),
              ),
      ],
    );
  }

  void _showGenerateDialog(
    BuildContext context,
    JoiningLetterModel letter,
    AppDataProvider data,
    AuthProvider auth,
  ) {
    final requester = data.getUserById(letter.requestedById);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Generate Joining Letter',
          style: GoogleFonts.poppins(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
        ),
        content: Text(
          _generateDialogContent(requester?.name, letter),
          style: GoogleFonts.poppins(color: AppColors.darkTextSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel',
                style: GoogleFonts.poppins(color: AppColors.darkTextSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              data.updateJoiningLetter(
                letter.copyWith(
                  status: RequestStatus.approved,
                  generatedById: auth.currentUser?.id,
                ),
              );
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Joining letter generated successfully'),
                  backgroundColor: AppColors.primaryTeal,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal),
            child: Text('Generate', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _rejectLetter(
    BuildContext context,
    JoiningLetterModel letter,
    AppDataProvider data,
  ) {
    data.updateJoiningLetter(letter.copyWith(status: RequestStatus.rejected));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Joining letter rejected'),
        backgroundColor: AppColors.secondaryRed,
      ),
    );
  }

  String _generateDialogContent(String? name, JoiningLetterModel letter) {
    final userName = name ?? 'this user';
    final tenureLine = 'Tenure: ${letter.tenureType}';
    String periodLine;
    if (letter.tenureType == 'Monthly') {
      final month = letter.month ?? '';
      final year = letter.year ?? '';
      periodLine = 'Month: $month $year';
    } else {
      periodLine = 'Year: ${letter.year ?? ''}';
    }
    return 'Generate joining letter for $userName?\n\n$tenureLine\n$periodLine';
  }
}

// ─── Filter Tab ───────────────────────────────────────────────────────────────

class _FilterTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryTeal : AppColors.darkCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primaryTeal : AppColors.darkDivider,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.white : AppColors.darkTextSecondary,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

// ─── Joining Letter Card ──────────────────────────────────────────────────────

class _JoiningLetterCard extends StatelessWidget {
  final JoiningLetterModel letter;
  final String requesterName;
  final UserRole requesterRole;
  final String? generatedByName;
  final bool isGeneratedByOther;
  final VoidCallback? onGenerate;
  final VoidCallback? onReject;

  const _JoiningLetterCard({
    required this.letter,
    required this.requesterName,
    required this.requesterRole,
    this.generatedByName,
    required this.isGeneratedByOther,
    this.onGenerate,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      requesterName,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _RoleBadge(role: requesterRole),
                        const SizedBox(width: 8),
                        _TenureBadge(tenureType: letter.tenureType),
                      ],
                    ),
                  ],
                ),
              ),
              StatusBadge.fromRequestStatus(letter.status),
            ],
          ),
          const SizedBox(height: 10),

          // Tenure details
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: AppColors.darkTextHint),
              const SizedBox(width: 6),
              Text(
                letter.tenureType == 'Monthly'
                    ? '${letter.month ?? ''} ${letter.year ?? ''}'
                    : 'Year: ${letter.year ?? ''}',
                style: GoogleFonts.poppins(
                    color: AppColors.darkTextSecondary, fontSize: 12),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, size: 14, color: AppColors.darkTextHint),
              const SizedBox(width: 6),
              Text(
                'Requested: ${DateFormat('dd MMM yyyy').format(letter.requestedDate)}',
                style: GoogleFonts.poppins(
                    color: AppColors.darkTextSecondary, fontSize: 12),
              ),
            ],
          ),

          // If generated by another admin
          if (isGeneratedByOther && generatedByName != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      size: 14, color: AppColors.darkTextSecondary),
                  const SizedBox(width: 6),
                  Text(
                    'Generated by $generatedByName',
                    style: GoogleFonts.poppins(
                        color: AppColors.darkTextSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],

          // Action buttons for pending
          if (letter.status == RequestStatus.pending && !isGeneratedByOther) ...[
            const SizedBox(height: 12),
            const Divider(color: AppColors.darkDivider, height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onGenerate,
                    icon: const Icon(Icons.edit_document, size: 16, color: Colors.white),
                    label: Text(
                      'Generate Letter',
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryTeal,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onReject,
                    icon: const Icon(Icons.close, size: 16, color: AppColors.secondaryRed),
                    label: Text(
                      'Reject',
                      style: GoogleFonts.poppins(
                          color: AppColors.secondaryRed, fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.secondaryRed),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
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

// ─── Role Badge ───────────────────────────────────────────────────────────────

class _RoleBadge extends StatelessWidget {
  final UserRole role;
  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (role) {
      UserRole.superAdmin => (AppColors.secondaryPurple, 'Super Admin'),
      UserRole.admin => (AppColors.secondaryBlue, 'Admin'),
      UserRole.member => (AppColors.primaryTeal, 'Member'),
      UserRole.volunteer => (const Color(0xFF43A047), 'Volunteer'),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withAlpha(70)),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(color: color, fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ─── Tenure Badge ─────────────────────────────────────────────────────────────

class _TenureBadge extends StatelessWidget {
  final String tenureType;
  const _TenureBadge({required this.tenureType});

  @override
  Widget build(BuildContext context) {
    final color = tenureType == 'Monthly'
        ? AppColors.secondaryOrange
        : AppColors.secondaryBlue;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withAlpha(70)),
      ),
      child: Text(
        tenureType,
        style: GoogleFonts.poppins(
            color: color, fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }
}
