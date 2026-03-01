import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme/app_colors.dart';
import '../../core/enums/status.dart';
import '../../models/certificate_model.dart';

class RequestCertificateDialog extends StatefulWidget {
  final String requestedById;
  final void Function(CertificateModel)? onSubmit;

  const RequestCertificateDialog({
    super.key,
    required this.requestedById,
    this.onSubmit,
  });

  static Future<void> show(
    BuildContext context, {
    required String requestedById,
    void Function(CertificateModel)? onSubmit,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => RequestCertificateDialog(
        requestedById: requestedById,
        onSubmit: onSubmit,
      ),
    );
  }

  @override
  State<RequestCertificateDialog> createState() =>
      _RequestCertificateDialogState();
}

class _RequestCertificateDialogState extends State<RequestCertificateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _detailsController = TextEditingController();
  String _certificateType = 'Volunteer Certificate';

  static const _certificateTypes = [
    'Volunteer Certificate',
    'Membership Certificate',
    'Service Certificate',
    'Appreciation Certificate',
    'Participation Certificate',
  ];

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final cert = CertificateModel(
      id: 'cert_${DateTime.now().millisecondsSinceEpoch}',
      requestedById: widget.requestedById,
      certificateType: _certificateType,
      additionalDetails: _detailsController.text.trim().isEmpty
          ? null
          : _detailsController.text.trim(),
      requestedDate: DateTime.now(),
      status: RequestStatus.pending,
    );

    widget.onSubmit?.call(cert);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.darkCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
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
                      color: AppColors.secondaryGold.withAlpha(25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.workspace_premium,
                        color: AppColors.secondaryGold, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Request Certificate',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Select the type of certificate',
                          style: GoogleFonts.poppins(
                            color: AppColors.darkTextSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Certificate type
              _buildLabel('Certificate Type'),
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
                    value: _certificateType,
                    isExpanded: true,
                    dropdownColor: AppColors.darkCard,
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontSize: 13),
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: AppColors.darkTextSecondary),
                    onChanged: (v) => setState(() => _certificateType = v!),
                    items: _certificateTypes
                        .map((t) => DropdownMenuItem(
                              value: t,
                              child: Text(t),
                            ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Certificate type info chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _certificateTypes.map((type) {
                  final isSelected = type == _certificateType;
                  return GestureDetector(
                    onTap: () => setState(() => _certificateType = type),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.secondaryGold.withAlpha(25)
                            : AppColors.darkBackground,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.secondaryGold
                              : AppColors.darkDivider,
                        ),
                      ),
                      child: Text(
                        type,
                        style: GoogleFonts.poppins(
                          color: isSelected
                              ? AppColors.secondaryGold
                              : AppColors.darkTextSecondary,
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Additional details
              _buildLabel('Additional Details (Optional)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _detailsController,
                maxLines: 3,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText:
                      'Any specific details or purpose for this certificate...',
                  hintStyle: GoogleFonts.poppins(
                      color: AppColors.darkTextHint, fontSize: 12),
                  filled: true,
                  fillColor: AppColors.darkBackground,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
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
                    borderSide: const BorderSide(
                        color: AppColors.primaryTeal, width: 1.5),
                  ),
                ),
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
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        'Submit Request',
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
}
