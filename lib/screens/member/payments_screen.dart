import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme/app_colors.dart';

class MemberPaymentsScreen extends StatelessWidget {
  const MemberPaymentsScreen({super.key});

  void _showPaymentDialog(BuildContext context, bool isRenewal) {
    showDialog(
      context: context,
      builder: (ctx) => _PaymentDialog(isRenewal: isRenewal),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Payments',
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text('Manage your membership payments',
                style: GoogleFonts.poppins(
                    color: AppColors.darkTextSecondary,
                    fontSize: 13)),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: _PaymentOptionCard(
                    icon: Icons.autorenew,
                    title: 'Renew\nMembership',
                    subtitle: 'Extend your existing membership',
                    color: AppColors.primaryTeal,
                    onTap: () =>
                        _showPaymentDialog(context, true),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _PaymentOptionCard(
                    icon: Icons.person_add_outlined,
                    title: 'New\nMembership',
                    subtitle: 'Register as a new member',
                    color: AppColors.secondaryBlue,
                    onTap: () =>
                        _showPaymentDialog(context, false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(12),
                border: const Border(
                  left: BorderSide(
                      color: AppColors.primaryTeal, width: 4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fee Structure – FY 2025-26',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  _FeeRow(
                      category: '80G Membership',
                      renew: '₹5,000',
                      newFee: '₹7,500'),
                  const Divider(
                      color: AppColors.darkDivider, height: 16),
                  _FeeRow(
                      category: 'Non-80G Membership',
                      renew: '₹3,000',
                      newFee: '₹5,000'),
                ],
              ),
            ),
          ],
        ),
    );
  }
}

class _PaymentOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _PaymentOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withAlpha(60)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withAlpha(30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 14),
            Text(title,
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 1.3)),
            const SizedBox(height: 6),
            Text(subtitle,
                style: GoogleFonts.poppins(
                    color: AppColors.darkTextSecondary,
                    fontSize: 11,
                    height: 1.3)),
          ],
        ),
      ),
    );
  }
}

class _FeeRow extends StatelessWidget {
  final String category;
  final String renew;
  final String newFee;

  const _FeeRow(
      {required this.category,
      required this.renew,
      required this.newFee});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(category,
              style: GoogleFonts.poppins(
                  color: AppColors.darkTextSecondary,
                  fontSize: 12)),
        ),
        Expanded(
          child: Text(renew,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  color: AppColors.primaryTeal,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ),
        Expanded(
          child: Text(newFee,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  color: AppColors.secondaryBlue,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

// ─── Payment Dialog ───────────────────────────────────────────────────────────
class _PaymentDialog extends StatefulWidget {
  final bool isRenewal;
  const _PaymentDialog({required this.isRenewal});

  @override
  State<_PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<_PaymentDialog> {
  bool _is80G = true;
  String _paymentMode = 'Online';
  final _upiController = TextEditingController();
  final _txnController = TextEditingController();

  static const _modes = ['Online', 'Cash', 'Cheque'];

  int get _amount {
    if (_is80G) {
      return widget.isRenewal ? 5000 : 7500;
    }
    return widget.isRenewal ? 3000 : 5000;
  }

  @override
  void dispose() {
    _upiController.dispose();
    _txnController.dispose();
    super.dispose();
  }

  void _submit() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Payment of ₹$_amount submitted successfully via $_paymentMode'),
        backgroundColor: AppColors.primaryTeal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.darkCard,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.isRenewal ? 'Renew Membership' : 'New Membership',
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text('FY 2025-26',
                style: GoogleFonts.poppins(
                    color: AppColors.primaryTeal, fontSize: 12)),
            const SizedBox(height: 20),

            // Category toggle
            Text('Membership Category',
                style: GoogleFonts.poppins(
                    color: AppColors.darkTextSecondary,
                    fontSize: 12)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  _ToggleOption(
                    label: '80G Membership',
                    active: _is80G,
                    onTap: () => setState(() => _is80G = true),
                  ),
                  _ToggleOption(
                    label: 'Non-80G',
                    active: !_is80G,
                    onTap: () => setState(() => _is80G = false),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Amount
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryTeal.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: AppColors.primaryTeal.withAlpha(60)),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text('Amount Payable',
                      style: GoogleFonts.poppins(
                          color: AppColors.darkTextSecondary,
                          fontSize: 13)),
                  Text('₹$_amount',
                      style: GoogleFonts.poppins(
                          color: AppColors.primaryTeal,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Payment mode
            Text('Payment Mode',
                style: GoogleFonts.poppins(
                    color: AppColors.darkTextSecondary,
                    fontSize: 12)),
            const SizedBox(height: 8),
            Row(
              children: _modes.map((mode) {
                final selected = _paymentMode == mode;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () =>
                        setState(() => _paymentMode = mode),
                    child: Row(
                      children: [
                        Radio<String>(
                          value: mode,
                          groupValue: _paymentMode,
                          activeColor: AppColors.primaryTeal,
                          onChanged: (v) => setState(
                              () => _paymentMode = v!),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        Text(mode,
                            style: GoogleFonts.poppins(
                                color: selected
                                    ? Colors.white
                                    : AppColors.darkTextSecondary,
                                fontSize: 13)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            // Online fields
            if (_paymentMode == 'Online') ...[
              const SizedBox(height: 12),
              _DialogTextField(
                  controller: _upiController,
                  label: 'UPI ID',
                  hint: 'e.g. name@upi'),
              const SizedBox(height: 10),
              _DialogTextField(
                  controller: _txnController,
                  label: 'Transaction ID',
                  hint: 'Enter transaction reference'),
            ] else ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.darkSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _paymentMode == 'Cash'
                      ? 'Please pay the amount in cash at the Jayshree Foundation office and submit this form.'
                      : 'Please make the cheque payable to "Jayshree Foundation NGO" and submit at the office.',
                  style: GoogleFonts.poppins(
                      color: AppColors.darkTextSecondary,
                      fontSize: 12,
                      height: 1.4),
                ),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: AppColors.darkDivider),
                      padding:
                          const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('Cancel',
                        style: GoogleFonts.poppins(
                            color:
                                AppColors.darkTextSecondary)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryTeal,
                      padding:
                          const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('Proceed to Pay',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleOption extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _ToggleOption(
      {required this.label,
      required this.active,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColors.primaryTeal : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(label,
                style: GoogleFonts.poppins(
                    color:
                        active ? Colors.white : AppColors.darkTextSecondary,
                    fontSize: 12,
                    fontWeight: active
                        ? FontWeight.w600
                        : FontWeight.w400)),
          ),
        ),
      ),
    );
  }
}

class _DialogTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  const _DialogTextField(
      {required this.controller,
      required this.label,
      required this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                color: AppColors.darkTextSecondary, fontSize: 12)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
                color: AppColors.darkTextHint, fontSize: 12),
            filled: true,
            fillColor: AppColors.darkSurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.darkDivider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primaryTeal),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }
}
