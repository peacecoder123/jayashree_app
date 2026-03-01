import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../config/theme/app_colors.dart';
import '../../models/donation_model.dart';

class DonationCard extends StatelessWidget {
  final DonationModel donation;
  final VoidCallback? onTap;

  const DonationCard({super.key, required this.donation, this.onTap});

  @override
  Widget build(BuildContext context) {
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
        child: Row(
          children: [
            // Donor avatar
            _buildDonorAvatar(),
            const SizedBox(width: 14),

            // Info
            Expanded(
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
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        donation.formattedAmount,
                        style: GoogleFonts.poppins(
                          color: AppColors.primaryTeal,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    donation.purpose,
                    style: GoogleFonts.poppins(
                      color: AppColors.darkTextSecondary,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildPaymentBadge(donation.paymentMode),
                      const SizedBox(width: 8),
                      Icon(Icons.calendar_today_outlined,
                          size: 11, color: AppColors.darkTextHint),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('dd MMM yyyy').format(donation.date),
                        style: GoogleFonts.poppins(
                          color: AppColors.darkTextSecondary,
                          fontSize: 11,
                        ),
                      ),
                      const Spacer(),
                      _buildReceiptStatus(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonorAvatar() {
    const colors = [
      AppColors.primaryTeal,
      AppColors.secondaryOrange,
      AppColors.secondaryPurple,
      AppColors.secondaryBlue,
      Color(0xFF43A047),
    ];
    final hash =
        donation.donorName.codeUnits.fold(0, (sum, c) => sum + c);
    final color = colors[hash % colors.length];
    final initials = donation.donorName.trim().isNotEmpty
        ? donation.donorName.trim()[0].toUpperCase()
        : '?';
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentBadge(String mode) {
    Color color;
    switch (mode.toLowerCase()) {
      case 'online':
        color = AppColors.secondaryBlue;
        break;
      case 'cash':
        color = const Color(0xFF43A047);
        break;
      case 'cheque':
        color = AppColors.secondaryGold;
        break;
      default:
        color = AppColors.darkTextSecondary;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(
        mode,
        style: GoogleFonts.poppins(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildReceiptStatus() {
    final generated = donation.receiptGenerated;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          generated ? Icons.receipt_long : Icons.receipt_long_outlined,
          size: 14,
          color: generated ? AppColors.statusApproved : AppColors.error,
        ),
        const SizedBox(width: 4),
        Text(
          generated ? 'Receipt' : 'Pending',
          style: GoogleFonts.poppins(
            color: generated ? AppColors.statusApproved : AppColors.error,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
