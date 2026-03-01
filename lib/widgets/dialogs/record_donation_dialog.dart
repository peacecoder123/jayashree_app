import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme/app_colors.dart';
import '../../models/donation_model.dart';

class RecordDonationDialog extends StatefulWidget {
  final void Function(DonationModel)? onRecord;

  const RecordDonationDialog({super.key, this.onRecord});

  static Future<void> show(
    BuildContext context, {
    void Function(DonationModel)? onRecord,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => RecordDonationDialog(onRecord: onRecord),
    );
  }

  @override
  State<RecordDonationDialog> createState() => _RecordDonationDialogState();
}

class _RecordDonationDialogState extends State<RecordDonationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _purposeController = TextEditingController();
  String _paymentMode = 'Cash';
  bool _is80GEligible = false;

  static const _paymentModes = ['Cash', 'Online', 'Cheque'];

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  void _handleRecord() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final donation = DonationModel(
      id: 'don_${DateTime.now().millisecondsSinceEpoch}',
      donorName: _nameController.text.trim(),
      purpose: _purposeController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      paymentMode: _paymentMode,
      date: DateTime.now(),
      is80GEligible: _is80GEligible,
      receiptGenerated: false,
    );

    widget.onRecord?.call(donation);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.darkCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal.withAlpha(25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.volunteer_activism,
                        color: AppColors.primaryTeal, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Record Donation',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Donor name
              _buildLabel('Donor Name'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                decoration: _inputDecoration('Enter donor name'),
                validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? 'Donor name is required' : null,
              ),
              const SizedBox(height: 16),

              // Amount
              _buildLabel('Amount (₹)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                decoration: _inputDecoration('e.g., 5000').copyWith(
                  prefixText: '₹ ',
                  prefixStyle: GoogleFonts.poppins(
                    color: AppColors.primaryTeal,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Amount is required';
                  if (double.tryParse(v.trim()) == null) return 'Enter a valid amount';
                  if (double.parse(v.trim()) <= 0) return 'Amount must be greater than 0';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Payment mode
              _buildLabel('Payment Mode'),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.darkBackground,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.darkDivider),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _paymentMode,
                    dropdownColor: AppColors.darkCard,
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontSize: 13),
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: AppColors.darkTextSecondary),
                    onChanged: (v) => setState(() => _paymentMode = v!),
                    items: _paymentModes
                        .map((m) => DropdownMenuItem(
                              value: m,
                              child: Text(m),
                            ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Purpose
              _buildLabel('Purpose'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _purposeController,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                decoration: _inputDecoration('e.g., Food Drive 2024'),
                validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? 'Purpose is required' : null,
              ),
              const SizedBox(height: 16),

              // 80G eligible checkbox
              Row(
                children: [
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: Checkbox(
                      value: _is80GEligible,
                      onChanged: (v) =>
                          setState(() => _is80GEligible = v ?? false),
                      activeColor: AppColors.primaryTeal,
                      side: const BorderSide(
                          color: AppColors.darkTextSecondary, width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () =>
                        setState(() => _is80GEligible = !_is80GEligible),
                    child: Text(
                      '80G Eligible Donation',
                      style: GoogleFonts.poppins(
                        color: AppColors.darkTextSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.darkDivider),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(
                          color: AppColors.darkTextSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleRecord,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        'Record Donation',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
        text,
        style: GoogleFonts.poppins(
          color: AppColors.darkTextSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      );

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle:
            GoogleFonts.poppins(color: AppColors.darkTextHint, fontSize: 12),
        filled: true,
        fillColor: AppColors.darkBackground,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
          borderSide:
              const BorderSide(color: AppColors.primaryTeal, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        errorStyle: GoogleFonts.poppins(color: AppColors.error, fontSize: 10),
      );
}
