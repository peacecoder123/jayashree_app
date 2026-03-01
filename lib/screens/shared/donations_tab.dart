import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:hopeconnect/config/theme/app_colors.dart';
import 'package:hopeconnect/models/donation_model.dart';
import 'package:hopeconnect/providers/app_data_provider.dart';
import 'package:hopeconnect/widgets/common/stat_card.dart';
import 'package:hopeconnect/widgets/common/status_badge.dart';

class DonationsTab extends StatefulWidget {
  const DonationsTab({super.key});

  @override
  State<DonationsTab> createState() => _DonationsTabState();
}

class _DonationsTabState extends State<DonationsTab> {
  String _search = '';
  String _typeFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppDataProvider>();
    final allDonations = data.donations;
    final fmt = NumberFormat('#,##,###', 'en_IN');

    // Stats
    final totalReceived = allDonations.fold(0.0, (s, d) => s + d.amount);
    final cashDonations =
        allDonations.where((d) => d.paymentMode == 'Cash').fold(0.0, (s, d) => s + d.amount);
    final onlineCheque = allDonations
        .where((d) => d.paymentMode == 'Online' || d.paymentMode == 'Cheque')
        .fold(0.0, (s, d) => s + d.amount);
    final receiptsPending = allDonations.where((d) => !d.receiptGenerated).length;

    // Filtered list
    final filtered = allDonations.where((d) {
      final matchSearch = _search.isEmpty ||
          d.donorName.toLowerCase().contains(_search.toLowerCase()) ||
          d.purpose.toLowerCase().contains(_search.toLowerCase());
      final matchType = _typeFilter == 'All' || d.paymentMode == _typeFilter;
      return matchSearch && matchType;
    }).toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ───────────────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Donations',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Track and manage all donations',
                            style: GoogleFonts.poppins(
                              color: AppColors.darkTextSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _showRecordDonationDialog(context, data),
                      icon: const Icon(Icons.attach_money, size: 18, color: Colors.white),
                      label: Text(
                        'Record Donation',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Summary Stat Cards ────────────────────────────────────────
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  children: [
                    StatCard(
                      icon: Icons.account_balance_wallet,
                      iconColor: AppColors.statusApproved,
                      title: 'Total Received',
                      value: '₹${fmt.format(totalReceived.toInt())}',
                      subtitle: 'All time',
                    ),
                    StatCard(
                      icon: Icons.money,
                      iconColor: AppColors.secondaryOrange,
                      title: 'Cash Donations',
                      value: '₹${fmt.format(cashDonations.toInt())}',
                      subtitle: 'Cash only',
                    ),
                    StatCard(
                      icon: Icons.credit_card,
                      iconColor: AppColors.secondaryBlue,
                      title: 'Online / Cheque',
                      value: '₹${fmt.format(onlineCheque.toInt())}',
                      subtitle: 'Digital + cheque',
                    ),
                    StatCard(
                      icon: Icons.receipt_long,
                      iconColor: AppColors.secondaryRed,
                      title: 'Receipts Pending',
                      value: '$receiptsPending',
                      subtitle: 'To be generated',
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Monthly Bar Chart ─────────────────────────────────────────
                _MonthlyDonationBarChart(donations: allDonations),
                const SizedBox(height: 20),

                // ── Search & Filter ───────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (v) => setState(() => _search = v),
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Search donations...',
                          hintStyle: GoogleFonts.poppins(
                              color: AppColors.darkTextHint, fontSize: 13),
                          prefixIcon: const Icon(Icons.search,
                              color: AppColors.darkTextHint, size: 20),
                          filled: true,
                          fillColor: AppColors.darkCard,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.darkDivider),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.darkDivider),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.primaryTeal),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.darkCard,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.darkDivider),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _typeFilter,
                          dropdownColor: AppColors.darkCard,
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                          icon: const Icon(Icons.keyboard_arrow_down,
                              color: AppColors.darkTextSecondary),
                          items: ['All', 'Cash', 'Online', 'Cheque']
                              .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                              .toList(),
                          onChanged: (v) {
                            if (v != null) setState(() => _typeFilter = v);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),

        // ── Donation List ─────────────────────────────────────────────────────
        filtered.isEmpty
            ? SliverFillRemaining(
                child: Center(
                  child: Text(
                    'No donations found',
                    style: GoogleFonts.poppins(color: AppColors.darkTextSecondary),
                  ),
                ),
              )
            : SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _DonationCard(
                          donation: filtered[index],
                          onGenerateReceipt: () {
                            data.updateDonation(
                              filtered[index].copyWith(receiptGenerated: true),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Receipt generated successfully'),
                                backgroundColor: AppColors.primaryTeal,
                              ),
                            );
                          },
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

  void _showRecordDonationDialog(BuildContext context, AppDataProvider data) {
    showDialog(
      context: context,
      builder: (_) => _RecordDonationDialog(
        onSave: (d) => data.addDonation(d),
      ),
    );
  }
}

// ─── Monthly Bar Chart ────────────────────────────────────────────────────────

class _MonthlyDonationBarChart extends StatelessWidget {
  final List<DonationModel> donations;
  const _MonthlyDonationBarChart({required this.donations});

  @override
  Widget build(BuildContext context) {
    // Aggregate by month (last 6 months)
    final now = DateTime.now();
    final months = List.generate(6, (i) {
      final m = DateTime(now.year, now.month - 5 + i, 1);
      return m;
    });

    final monthlyTotals = months.map((m) {
      return donations
          .where((d) => d.date.year == m.year && d.date.month == m.month)
          .fold(0.0, (s, d) => s + d.amount);
    }).toList();

    final monthLabels = months
        .map((m) => DateFormat('MMM').format(m))
        .toList();

    // Calculate max Y with 20% headroom, falling back to a sensible default
    final maxMonthlyTotal = monthlyTotals.isEmpty
        ? 0.0
        : monthlyTotals.reduce((a, b) => a > b ? a : b);
    final maxY = maxMonthlyTotal == 0
        ? 100000.0
        : (maxMonthlyTotal * 1.2).clamp(1.0, double.infinity);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Donation Trend',
            style: GoogleFonts.poppins(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            'Last 6 months',
            style: GoogleFonts.poppins(color: AppColors.darkTextSecondary, fontSize: 12),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i < 0 || i >= monthLabels.length) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          monthLabels[i],
                          style: GoogleFonts.poppins(
                              color: AppColors.darkTextSecondary, fontSize: 10),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: AppColors.darkDivider,
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(
                  monthlyTotals.length,
                  (i) => BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: monthlyTotals[i],
                        gradient: const LinearGradient(
                          colors: [AppColors.primaryTeal, AppColors.primaryTealLight],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        width: 20,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
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

// ─── Donation Card ────────────────────────────────────────────────────────────

class _DonationCard extends StatelessWidget {
  final DonationModel donation;
  final VoidCallback onGenerateReceipt;

  const _DonationCard({required this.donation, required this.onGenerateReceipt});

  Color get _modeColor {
    switch (donation.paymentMode) {
      case 'Cash':
        return AppColors.secondaryOrange;
      case 'Online':
        return AppColors.secondaryBlue;
      case 'Cheque':
        return AppColors.secondaryPurple;
      default:
        return AppColors.primaryTeal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##,###', 'en_IN');
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
                child: Text(
                  donation.donorName,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '₹${fmt.format(donation.amount.toInt())}',
                style: GoogleFonts.poppins(
                  color: AppColors.primaryTeal,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            donation.purpose,
            style: GoogleFonts.poppins(color: AppColors.darkTextSecondary, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              // Payment mode badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _modeColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: _modeColor.withAlpha(70)),
                ),
                child: Text(
                  donation.paymentMode,
                  style: GoogleFonts.poppins(
                    color: _modeColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // 80G badge
              if (donation.is80GEligible)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.statusApproved.withAlpha(25),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.statusApproved.withAlpha(70)),
                  ),
                  child: Text(
                    '80G Eligible',
                    style: GoogleFonts.poppins(
                      color: AppColors.statusApproved,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const Spacer(),
              // Date
              Text(
                DateFormat('dd MMM yyyy').format(donation.date),
                style: GoogleFonts.poppins(color: AppColors.darkTextHint, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: AppColors.darkDivider, height: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              donation.receiptGenerated
                  ? StatusBadge(label: 'Receipt Generated', color: AppColors.statusApproved)
                  : StatusBadge(label: 'Receipt Pending', color: AppColors.statusPending),
              const Spacer(),
              if (!donation.receiptGenerated)
                TextButton.icon(
                  onPressed: onGenerateReceipt,
                  icon: const Icon(Icons.receipt, size: 16, color: AppColors.primaryTeal),
                  label: Text(
                    'Generate Receipt',
                    style: GoogleFonts.poppins(color: AppColors.primaryTeal, fontSize: 12),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Record Donation Dialog ───────────────────────────────────────────────────

class _RecordDonationDialog extends StatefulWidget {
  final ValueChanged<DonationModel> onSave;
  const _RecordDonationDialog({required this.onSave});

  @override
  State<_RecordDonationDialog> createState() => _RecordDonationDialogState();
}

class _RecordDonationDialogState extends State<_RecordDonationDialog> {
  final _donorCtrl = TextEditingController();
  final _purposeCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  String _paymentMode = 'Online';
  bool _is80G = true;
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _donorCtrl.dispose();
    _purposeCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.darkCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Record Donation',
        style: GoogleFonts.poppins(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _tf('Donor Name', _donorCtrl),
            const SizedBox(height: 10),
            _tf('Purpose', _purposeCtrl),
            const SizedBox(height: 10),
            _tf('Amount (₹)', _amountCtrl, inputType: TextInputType.number),
            const SizedBox(height: 10),
            // Payment mode
            DropdownButtonFormField<String>(
              value: _paymentMode,
              dropdownColor: AppColors.darkCard,
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                labelText: 'Payment Mode',
                labelStyle: GoogleFonts.poppins(
                    color: AppColors.darkTextSecondary, fontSize: 13),
                filled: true,
                fillColor: AppColors.darkSurface,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.darkDivider)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.darkDivider)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primaryTeal)),
              ),
              items: ['Cash', 'Online', 'Cheque']
                  .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                  .toList(),
              onChanged: (v) => setState(() => _paymentMode = v ?? 'Online'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: _is80G,
                  onChanged: (v) => setState(() => _is80G = v ?? true),
                  activeColor: AppColors.primaryTeal,
                ),
                Text(
                  '80G Eligible',
                  style: GoogleFonts.poppins(
                      color: AppColors.darkTextSecondary, fontSize: 13),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _date,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) setState(() => _date = picked);
                  },
                  child: Text(
                    '${_date.day}/${_date.month}/${_date.year}',
                    style:
                        GoogleFonts.poppins(color: AppColors.primaryTeal, fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel',
              style: GoogleFonts.poppins(color: AppColors.darkTextSecondary)),
        ),
        ElevatedButton(
          onPressed: () {
            final amount = double.tryParse(_amountCtrl.text.trim()) ?? 0;
            if (_donorCtrl.text.trim().isEmpty || amount <= 0) return;
            widget.onSave(DonationModel(
              id: 'd_${DateTime.now().millisecondsSinceEpoch}',
              donorName: _donorCtrl.text.trim(),
              purpose: _purposeCtrl.text.trim(),
              amount: amount,
              paymentMode: _paymentMode,
              date: _date,
              is80GEligible: _is80G,
              receiptGenerated: false,
            ));
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Donation recorded successfully'),
                backgroundColor: AppColors.primaryTeal,
              ),
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal),
          child: Text('Record', style: GoogleFonts.poppins(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _tf(String hint, TextEditingController ctrl,
      {TextInputType inputType = TextInputType.text}) {
    return TextField(
      controller: ctrl,
      keyboardType: inputType,
      style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: AppColors.darkTextHint, fontSize: 13),
        filled: true,
        fillColor: AppColors.darkSurface,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.darkDivider)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.darkDivider)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primaryTeal)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}
