import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme/app_colors.dart';
import '../../core/enums/status.dart';
import '../../models/mou_model.dart';

class RequestMouDialog extends StatefulWidget {
  final String submittedById;
  final void Function(MouModel)? onSubmit;

  const RequestMouDialog({
    super.key,
    required this.submittedById,
    this.onSubmit,
  });

  static Future<void> show(
    BuildContext context, {
    required String submittedById,
    void Function(MouModel)? onSubmit,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => RequestMouDialog(
        submittedById: submittedById,
        onSubmit: onSubmit,
      ),
    );
  }

  @override
  State<RequestMouDialog> createState() => _RequestMouDialogState();
}

class _RequestMouDialogState extends State<RequestMouDialog> {
  final _formKey = GlobalKey<FormState>();
  final _patientNameController = TextEditingController();
  final _diseaseController = TextEditingController();
  final _hospitalController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _ageController = TextEditingController();
  String _bloodGroup = 'A+';

  static const _bloodGroups = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'
  ];

  @override
  void dispose() {
    _patientNameController.dispose();
    _diseaseController.dispose();
    _hospitalController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final mou = MouModel(
      id: 'mou_${DateTime.now().millisecondsSinceEpoch}',
      patientName: _patientNameController.text.trim(),
      disease: _diseaseController.text.trim(),
      hospitalName: _hospitalController.text.trim(),
      bloodGroup: _bloodGroup,
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      submittedById: widget.submittedById,
      patientAge: int.parse(_ageController.text.trim()),
      submittedDate: DateTime.now(),
      status: MouStatus.pending,
    );

    widget.onSubmit?.call(mou);
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
                      color: AppColors.secondaryBlue.withAlpha(25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.description_outlined,
                        color: AppColors.secondaryBlue, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Request MOU',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Fill patient details below',
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

              // Patient Name
              _buildLabel('Patient Name'),
              const SizedBox(height: 8),
              _buildTextField(_patientNameController, 'Enter patient full name',
                  required: true),
              const SizedBox(height: 16),

              // Age + Blood Group row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Age'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 13),
                          decoration: _inputDecoration('e.g., 45'),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Required';
                            final age = int.tryParse(v.trim());
                            if (age == null || age <= 0 || age > 120) {
                              return 'Invalid age';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Blood Group'),
                        const SizedBox(height: 8),
                        Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          height: 46,
                          decoration: BoxDecoration(
                            color: AppColors.darkBackground,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.darkDivider),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _bloodGroup,
                              dropdownColor: AppColors.darkCard,
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 13),
                              icon: const Icon(Icons.keyboard_arrow_down,
                                  color: AppColors.darkTextSecondary,
                                  size: 18),
                              onChanged: (v) =>
                                  setState(() => _bloodGroup = v!),
                              items: _bloodGroups
                                  .map((g) => DropdownMenuItem(
                                        value: g,
                                        child: Text(g),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Disease
              _buildLabel('Disease / Condition'),
              const SizedBox(height: 8),
              _buildTextField(_diseaseController, 'e.g., Kidney failure',
                  required: true),
              const SizedBox(height: 16),

              // Hospital
              _buildLabel('Hospital Name'),
              const SizedBox(height: 8),
              _buildTextField(_hospitalController, 'e.g., City General Hospital',
                  required: true),
              const SizedBox(height: 16),

              // Phone
              _buildLabel('Contact Phone'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                decoration: _inputDecoration('10-digit phone number'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Phone is required';
                  if (v.trim().length != 10) return 'Enter valid 10-digit number';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Address
              _buildLabel('Address'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                decoration: _inputDecoration('Enter full address...'),
                validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? 'Address is required' : null,
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
                        'Submit MOU',
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

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    bool required = false,
  }) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
      decoration: _inputDecoration(hint),
      validator: required
          ? (v) => (v?.trim().isEmpty ?? true) ? 'This field is required' : null
          : null,
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
