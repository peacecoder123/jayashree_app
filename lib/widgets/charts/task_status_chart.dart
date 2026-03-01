import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme/app_colors.dart';

class TaskStatusChart extends StatefulWidget {
  final int pending;
  final int submitted;
  final int approved;
  final int rejected;

  const TaskStatusChart({
    super.key,
    this.pending = 0,
    this.submitted = 0,
    this.approved = 0,
    this.rejected = 0,
  });

  @override
  State<TaskStatusChart> createState() => _TaskStatusChartState();
}

class _TaskStatusChartState extends State<TaskStatusChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final total =
        widget.pending + widget.submitted + widget.approved + widget.rejected;

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
            'Task Status',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$total total tasks',
            style: GoogleFonts.poppins(
              color: AppColors.darkTextSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              // Donut chart
              SizedBox(
                width: 140,
                height: 140,
                child: total == 0
                    ? Center(
                        child: Text(
                          'No tasks',
                          style: GoogleFonts.poppins(
                            color: AppColors.darkTextHint,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback: (event, response) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    response == null ||
                                    response.touchedSection == null) {
                                  _touchedIndex = -1;
                                  return;
                                }
                                _touchedIndex = response
                                    .touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 3,
                          centerSpaceRadius: 40,
                          sections: _buildSections(total),
                        ),
                      ),
              ),
              const SizedBox(width: 24),
              // Legend
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendItem(
                        'Pending', widget.pending, AppColors.statusPending, total),
                    const SizedBox(height: 12),
                    _buildLegendItem(
                        'Submitted', widget.submitted, AppColors.statusSubmitted, total),
                    const SizedBox(height: 12),
                    _buildLegendItem(
                        'Approved', widget.approved, AppColors.statusApproved, total),
                    const SizedBox(height: 12),
                    _buildLegendItem(
                        'Rejected', widget.rejected, AppColors.statusRejected, total),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections(int total) {
    final data = [
      (widget.pending, AppColors.statusPending, 'Pending'),
      (widget.submitted, AppColors.statusSubmitted, 'Submitted'),
      (widget.approved, AppColors.statusApproved, 'Approved'),
      (widget.rejected, AppColors.statusRejected, 'Rejected'),
    ];

    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final (count, color, label) = entry.value;
      final isTouched = _touchedIndex == index;
      final radius = isTouched ? 30.0 : 22.0;

      if (count == 0) {
        return PieChartSectionData(
          value: 0,
          color: Colors.transparent,
          radius: 0,
          showTitle: false,
        );
      }

      return PieChartSectionData(
        value: count.toDouble(),
        color: color,
        radius: radius,
        showTitle: false,
      );
    }).toList();
  }

  Widget _buildLegendItem(
      String label, int count, Color color, int total) {
    final pct = total > 0 ? (count / total * 100).toStringAsFixed(0) : '0';
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: AppColors.darkTextSecondary,
              fontSize: 12,
            ),
          ),
        ),
        Text(
          '$count ($pct%)',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
