import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme/app_colors.dart';

class DonationTrendChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  final double changePercent;

  /// [values] - donation amounts for each period
  /// [labels] - period labels (e.g., ['Oct', 'Nov', 'Dec', 'Jan', 'Feb'])
  /// [changePercent] - percentage change vs last period (positive = growth)
  const DonationTrendChart({
    super.key,
    this.values = const [42000, 55000, 38000, 72000, 89000],
    this.labels = const ['Oct', 'Nov', 'Dec', 'Jan', 'Feb'],
    this.changePercent = 23.0,
  });

  @override
  Widget build(BuildContext context) {
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
          _buildHeader(),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: LineChart(_buildLineChartData()),
          ),
          const SizedBox(height: 16),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final isPositive = changePercent >= 0;
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Donation Trend',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Oct – Feb',
              style: GoogleFonts.poppins(
                color: AppColors.darkTextSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: (isPositive ? AppColors.statusApproved : AppColors.error)
                .withAlpha(25),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: (isPositive ? AppColors.statusApproved : AppColors.error)
                  .withAlpha(80),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: isPositive ? AppColors.statusApproved : AppColors.error,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                '${isPositive ? '+' : ''}${changePercent.toStringAsFixed(0)}% vs last period',
                style: GoogleFonts.poppins(
                  color:
                      isPositive ? AppColors.statusApproved : AppColors.error,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(
        labels.length,
        (i) => Column(
          children: [
            Text(
              '₹${_formatAmount(values[i])}',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              labels[i],
              style: GoogleFonts.poppins(
                color: AppColors.darkTextSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 100000) return '${(amount / 100000).toStringAsFixed(1)}L';
    if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(0)}K';
    return amount.toStringAsFixed(0);
  }

  LineChartData _buildLineChartData() {
    final maxY = values.reduce((a, b) => a > b ? a : b) * 1.2;
    final spots = values
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: maxY / 4,
        getDrawingHorizontalLine: (_) => FlLine(
          color: AppColors.darkDivider,
          strokeWidth: 1,
          dashArray: [4, 4],
        ),
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 24,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= labels.length) {
                return const SizedBox.shrink();
              }
              return Text(
                labels[index],
                style: GoogleFonts.poppins(
                  color: AppColors.darkTextSecondary,
                  fontSize: 10,
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 44,
            getTitlesWidget: (value, meta) {
              return Text(
                '₹${_formatAmount(value)}',
                style: GoogleFonts.poppins(
                  color: AppColors.darkTextHint,
                  fontSize: 9,
                ),
              );
            },
          ),
        ),
        topTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (values.length - 1).toDouble(),
      minY: 0,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: const LinearGradient(
            colors: [AppColors.primaryTeal, AppColors.primaryTealLight],
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, bar, index) =>
                FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.primaryTeal,
                  strokeWidth: 2,
                  strokeColor: AppColors.darkCard,
                ),
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                AppColors.primaryTeal.withAlpha(50),
                AppColors.primaryTeal.withAlpha(0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }
}
