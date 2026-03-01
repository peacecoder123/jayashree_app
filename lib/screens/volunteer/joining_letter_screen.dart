import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme/app_colors.dart';
import '../../core/enums/status.dart';
import '../../models/joining_letter_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_data_provider.dart';
import '../../widgets/common/status_badge.dart';

class VolunteerJoiningLetterScreen extends StatelessWidget {
  const VolunteerJoiningLetterScreen({super.key});

  static const _months = [
    'January', 'February', 'March', 'April',
    'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December',
  ];

  static const _years = ['2024', '2025', '2026'];

  void _showRequestDialog(
      BuildContext context, String userId, AppDataProvider data) {
    showDialog(
      context: context,
      builder: (ctx) => _RequestLetterDialog(
        userId: userId,
        onSubmit: (letter) => data.addJoiningLetter(letter),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final data = context.watch<AppDataProvider>();
    final userId = auth.currentUser?.id ?? '';
    final myLetters = data.joiningLetters
        .where((l) => l.requestedById == userId)
        .toList()
      ..sort(
          (a, b) => b.requestedDate.compareTo(a.requestedDate));

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
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text('Joining Letter',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Text(
                              'Request a monthly tenure letter for your volunteer work',
                              style: GoogleFonts.poppins(
                                  color:
                                      AppColors.darkTextSecondary,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryTeal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10)),
                        ),
                        onPressed: () => _showRequestDialog(
                            context, userId, data),
                        icon: const Icon(Icons.add,
                            size: 16, color: Colors.white),
                        label: Text('Request Letter',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Explanation card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.darkCard,
                      borderRadius: BorderRadius.circular(12),
                      border: const Border(
                        left: BorderSide(
                            color: AppColors.primaryTeal,
                            width: 4),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.description,
                                color: AppColors.primaryTeal,
                                size: 16),
                            const SizedBox(width: 8),
                            Text('Volunteer Tenure Letter',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'A monthly joining letter confirming your volunteer tenure at Jayshree Foundation. This document can be used for personal records, resume building, and other official purposes.',
                          style: GoogleFonts.poppins(
                              color: AppColors.darkTextSecondary,
                              fontSize: 12,
                              height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('My Letters',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          if (myLetters.isEmpty)
            SliverFillRemaining(
              child: _EmptyLetterState(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => _LetterListItem(
                      letter: myLetters[i], data: data),
                  childCount: myLetters.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RequestLetterDialog extends StatefulWidget {
  final String userId;
  final void Function(JoiningLetterModel) onSubmit;

  const _RequestLetterDialog(
      {required this.userId, required this.onSubmit});

  @override
  State<_RequestLetterDialog> createState() =>
      _RequestLetterDialogState();
}

class _RequestLetterDialogState
    extends State<_RequestLetterDialog> {
  String _selectedMonth = 'January';
  String _selectedYear = '2025';

  static const _months = [
    'January', 'February', 'March', 'April',
    'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December',
  ];
  static const _years = ['2024', '2025', '2026'];

  void _submit() {
    final letter = JoiningLetterModel(
      id: 'jl_${DateTime.now().millisecondsSinceEpoch}',
      requestedById: widget.userId,
      tenureType: 'Monthly',
      requestedDate: DateTime.now(),
      month: _selectedMonth,
      year: _selectedYear,
      status: RequestStatus.pending,
    );
    widget.onSubmit(letter);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Joining letter request submitted'),
        backgroundColor: AppColors.primaryTeal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.darkCard,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      title: Text('Request Joining Letter',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w600)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Month',
              style: GoogleFonts.poppins(
                  color: AppColors.darkTextSecondary,
                  fontSize: 12)),
          const SizedBox(height: 6),
          _DropdownField<String>(
            value: _selectedMonth,
            items: _months,
            onChanged: (v) => setState(() => _selectedMonth = v!),
          ),
          const SizedBox(height: 14),
          Text('Year',
              style: GoogleFonts.poppins(
                  color: AppColors.darkTextSecondary,
                  fontSize: 12)),
          const SizedBox(height: 6),
          _DropdownField<String>(
            value: _selectedYear,
            items: _years,
            onChanged: (v) => setState(() => _selectedYear = v!),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel',
              style: GoogleFonts.poppins(
                  color: AppColors.darkTextSecondary)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryTeal),
          onPressed: _submit,
          child: Text('Request Letter',
              style:
                  GoogleFonts.poppins(color: Colors.white)),
        ),
      ],
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final ValueChanged<T?> onChanged;

  const _DropdownField(
      {required this.value,
      required this.items,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: AppColors.darkDivider),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: AppColors.darkCard,
          style: GoogleFonts.poppins(
              color: Colors.white, fontSize: 13),
          iconEnabledColor: AppColors.darkTextSecondary,
          items: items
              .map((item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(item.toString(),
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 13)),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _LetterListItem extends StatelessWidget {
  final JoiningLetterModel letter;
  final AppDataProvider data;

  const _LetterListItem(
      {required this.letter, required this.data});

  @override
  Widget build(BuildContext context) {
    final isApproved = letter.status == RequestStatus.approved;
    final month = letter.month ?? '';
    final year = letter.year ?? '';
    final title = 'Joining Letter – $month $year';
    final generatedBy = letter.generatedById != null
        ? data.getUserById(letter.generatedById!)?.name
        : null;

    return Container(
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
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(title,
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
              ),
              StatusBadge.fromRequestStatus(letter.status),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Tenure Type: ${letter.tenureType}',
            style: GoogleFonts.poppins(
                color: AppColors.darkTextSecondary,
                fontSize: 12),
          ),
          const SizedBox(height: 2),
          Text(
            'Requested: ${DateFormat('dd MMM yyyy').format(letter.requestedDate)}',
            style: GoogleFonts.poppins(
                color: AppColors.darkTextHint, fontSize: 11),
          ),
          if (isApproved) ...[
            const SizedBox(height: 10),
            if (generatedBy != null)
              Text(
                'Generated by: $generatedBy',
                style: GoogleFonts.poppins(
                    color: AppColors.darkTextSecondary,
                    fontSize: 12),
              ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Downloading $title...'),
                    backgroundColor: AppColors.primaryTeal,
                  ),
                );
              },
              child: Row(
                children: [
                  const Icon(Icons.download_outlined,
                      color: AppColors.primaryTeal, size: 14),
                  const SizedBox(width: 4),
                  Text('Download Letter',
                      style: GoogleFonts.poppins(
                          color: AppColors.primaryTeal,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyLetterState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.description_outlined,
              color: AppColors.darkTextHint, size: 56),
          const SizedBox(height: 16),
          Text('No joining letters yet',
              style: GoogleFonts.poppins(
                  color: AppColors.darkTextSecondary,
                  fontSize: 15)),
          const SizedBox(height: 8),
          Text('Tap "+ Request Letter" to submit a request',
              style: GoogleFonts.poppins(
                  color: AppColors.darkTextHint, fontSize: 13)),
        ],
      ),
    );
  }
}
