import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../config/theme/app_colors.dart';
import '../../models/task_model.dart';
import '../../core/enums/status.dart';

class AddTaskDialog extends StatefulWidget {
  final String userName;
  final String? assignedToId;
  final String? assignedById;
  final void Function(TaskModel)? onAssign;

  const AddTaskDialog({
    super.key,
    required this.userName,
    this.assignedToId,
    this.assignedById,
    this.onAssign,
  });

  static Future<void> show(
    BuildContext context, {
    required String userName,
    String? assignedToId,
    String? assignedById,
    void Function(TaskModel)? onAssign,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AddTaskDialog(
        userName: userName,
        assignedToId: assignedToId,
        assignedById: assignedById,
        onAssign: onAssign,
      ),
    );
  }

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? _selectedDeadline;
  bool _requiresPhoto = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primaryTeal,
            surface: AppColors.darkCard,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDeadline = picked);
  }

  void _handleAssign() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedDeadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a deadline.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final task = TaskModel(
      id: 'task_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      assignedToId: widget.assignedToId ?? '',
      assignedById: widget.assignedById ?? '',
      deadline: _selectedDeadline!,
      createdAt: DateTime.now(),
      status: TaskStatus.pending,
      requiresPhotoUpload: _requiresPhoto,
    );

    widget.onAssign?.call(task);
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
              // Title
              Text(
                'Add Task for',
                style: GoogleFonts.poppins(
                  color: AppColors.darkTextSecondary,
                  fontSize: 13,
                ),
              ),
              Text(
                widget.userName,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),

              // Task title
              _buildLabel('Task Title'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                decoration: _inputDecoration('e.g., Distribute pamphlets'),
                validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),

              // Description
              _buildLabel('Description'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                decoration: _inputDecoration('Describe the task in detail...'),
                validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? 'Description is required' : null,
              ),
              const SizedBox(height: 16),

              // Deadline
              _buildLabel('Deadline'),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 13),
                  decoration: BoxDecoration(
                    color: AppColors.darkBackground,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _selectedDeadline != null
                          ? AppColors.primaryTeal
                          : AppColors.darkDivider,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          color: AppColors.darkTextHint, size: 18),
                      const SizedBox(width: 10),
                      Text(
                        _selectedDeadline != null
                            ? DateFormat('dd-MM-yyyy').format(_selectedDeadline!)
                            : 'Select deadline (dd-mm-yyyy)',
                        style: GoogleFonts.poppins(
                          color: _selectedDeadline != null
                              ? Colors.white
                              : AppColors.darkTextHint,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Requires photo upload checkbox
              Row(
                children: [
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: Checkbox(
                      value: _requiresPhoto,
                      onChanged: (v) =>
                          setState(() => _requiresPhoto = v ?? false),
                      activeColor: AppColors.primaryTeal,
                      side: const BorderSide(
                          color: AppColors.darkTextSecondary, width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => setState(() => _requiresPhoto = !_requiresPhoto),
                    child: Text(
                      'Requires photo upload',
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
                      onPressed: _handleAssign,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        'Assign Task',
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
