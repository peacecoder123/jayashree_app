import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:jayshree_foundation/config/theme/app_colors.dart';
import 'package:jayshree_foundation/core/enums/status.dart';
import 'package:jayshree_foundation/core/enums/user_role.dart';
import 'package:jayshree_foundation/models/task_model.dart';
import 'package:jayshree_foundation/models/user_model.dart';
import 'package:jayshree_foundation/providers/app_data_provider.dart';
import 'package:jayshree_foundation/providers/auth_provider.dart';
import 'package:jayshree_foundation/widgets/common/status_badge.dart';

class MembersTab extends StatefulWidget {
  const MembersTab({super.key});

  @override
  State<MembersTab> createState() => _MembersTabState();
}

class _MembersTabState extends State<MembersTab> {
  String _search = '';
  String _statusFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppDataProvider>();
    final members = data.members.where((m) {
      return _search.isEmpty || m.name.toLowerCase().contains(_search.toLowerCase());
    }).toList();

    return RefreshIndicator(
      color: AppColors.primaryTeal,
      onRefresh: () async => setState(() {}),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header row ───────────────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Members',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '${data.members.length} total members',
                              style: GoogleFonts.poppins(
                                color: AppColors.darkTextSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _showAddMemberDialog(context, data),
                        icon: const Icon(Icons.add, size: 18, color: AppColors.primaryTeal),
                        label: Text(
                          'Add Member',
                          style: GoogleFonts.poppins(
                            color: AppColors.primaryTeal,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primaryTeal),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Search & Filter ──────────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (v) => setState(() => _search = v),
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Search members...',
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
                            value: _statusFilter,
                            dropdownColor: AppColors.darkCard,
                            style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                            icon: const Icon(Icons.keyboard_arrow_down,
                                color: AppColors.darkTextSecondary),
                            items: ['All', 'Active', 'Inactive']
                                .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                                .toList(),
                            onChanged: (v) {
                              if (v != null) setState(() => _statusFilter = v);
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

          // ── List ───────────────────────────────────────────────────────────
          members.isEmpty
              ? const SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, color: AppColors.darkTextHint, size: 48),
                        SizedBox(height: 12),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final m = members[index];
                        final tasks = data.tasksForUser(m.id);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _MemberCard(
                            user: m,
                            tasks: tasks,
                            onViewProfile: () =>
                                _showProfileSheet(context, m, tasks),
                            onAddTask: () =>
                                _showAddTaskDialog(context, m, data),
                          ),
                        );
                      },
                      childCount: members.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  void _showProfileSheet(BuildContext context, UserModel user, List<TaskModel> tasks) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProfileSheet(user: user, tasks: tasks),
    );
  }

  void _showAddTaskDialog(BuildContext context, UserModel user, AppDataProvider data) {
    showDialog(
      context: context,
      builder: (_) => _AddTaskDialog(
        assignedTo: user,
        onSave: (task) => data.addTask(task),
      ),
    );
  }

  void _showAddMemberDialog(BuildContext context, AppDataProvider data) {
    showDialog(
      context: context,
      builder: (_) => _AddMemberDialog(
        onSave: (user) => data.addUser(user),
      ),
    );
  }
}

// ─── Member Card ──────────────────────────────────────────────────────────────

class _MemberCard extends StatelessWidget {
  final UserModel user;
  final List<TaskModel> tasks;
  final VoidCallback onViewProfile;
  final VoidCallback onAddTask;

  const _MemberCard({
    required this.user,
    required this.tasks,
    required this.onViewProfile,
    required this.onAddTask,
  });

  Color get _avatarColor {
    const colors = [
      AppColors.primaryTeal,
      AppColors.secondaryOrange,
      AppColors.secondaryPurple,
      AppColors.secondaryBlue,
      Color(0xFF43A047),
    ];
    final hash = user.name.codeUnits.fold(0, (s, c) => s + c);
    return colors[hash % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = tasks.where((t) => t.status == TaskStatus.pending).length;

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
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(color: _avatarColor, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    user.initials,
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      user.email,
                      style: GoogleFonts.poppins(
                          color: AppColors.darkTextSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              StatusBadge.active(),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  color: AppColors.darkTextHint, size: 14),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  user.location,
                  style: GoogleFonts.poppins(
                      color: AppColors.darkTextSecondary, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.phone_outlined, color: AppColors.darkTextHint, size: 14),
              const SizedBox(width: 4),
              Text(
                user.phone,
                style:
                    GoogleFonts.poppins(color: AppColors.darkTextSecondary, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (user.skills.isNotEmpty)
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: user.skills
                  .take(3)
                  .map((s) => _SkillChip(label: s))
                  .toList(),
            ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.assignment_outlined,
                  size: 14, color: AppColors.darkTextHint),
              const SizedBox(width: 4),
              Text(
                '${tasks.length} task${tasks.length == 1 ? '' : 's'}  •  $pendingCount pending',
                style: GoogleFonts.poppins(
                    color: AppColors.darkTextSecondary, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.darkDivider, height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onViewProfile,
                  icon: const Icon(Icons.person_outline,
                      size: 16, color: AppColors.primaryTeal),
                  label: Text(
                    'View Profile',
                    style: GoogleFonts.poppins(
                        color: AppColors.primaryTeal, fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primaryTeal),
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onAddTask,
                  icon: const Icon(Icons.add_task, size: 16, color: Colors.white),
                  label: Text(
                    '+ Add Task',
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal,
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  const _SkillChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.secondaryBlue.withAlpha(20),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.secondaryBlue.withAlpha(60)),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: AppColors.secondaryBlue,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ─── Profile Bottom Sheet ─────────────────────────────────────────────────────

class _ProfileSheet extends StatelessWidget {
  final UserModel user;
  final List<TaskModel> tasks;
  const _ProfileSheet({required this.user, required this.tasks});

  Color get _avatarColor {
    const colors = [
      AppColors.primaryTeal,
      AppColors.secondaryOrange,
      AppColors.secondaryPurple,
      AppColors.secondaryBlue,
      Color(0xFF43A047),
    ];
    final hash = user.name.codeUnits.fold(0, (s, c) => s + c);
    return colors[hash % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.darkDivider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration:
                          BoxDecoration(color: _avatarColor, shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          user.initials,
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user.name,
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      user.displayRole,
                      style: GoogleFonts.poppins(
                          color: AppColors.secondaryBlue, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Divider(color: AppColors.darkDivider),
              const SizedBox(height: 16),
              _infoRow(Icons.email_outlined, 'Email', user.email),
              _infoRow(Icons.phone_outlined, 'Phone', user.phone),
              _infoRow(Icons.location_on_outlined, 'Location', user.location),
              _infoRow(
                Icons.calendar_today_outlined,
                'Joined',
                '${user.joinedDate.day}/${user.joinedDate.month}/${user.joinedDate.year}',
              ),
              const SizedBox(height: 16),
              if (user.skills.isNotEmpty) ...[
                Text(
                  'Skills',
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: user.skills.map((s) => _SkillChip(label: s)).toList(),
                ),
                const SizedBox(height: 16),
              ],
              Text(
                'Assigned Tasks (${tasks.length})',
                style: GoogleFonts.poppins(
                    color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              if (tasks.isEmpty)
                Text(
                  'No tasks assigned yet.',
                  style: GoogleFonts.poppins(
                      color: AppColors.darkTextHint, fontSize: 12),
                )
              else
                ...tasks.map(
                  (t) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            t.title,
                            style: GoogleFonts.poppins(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        StatusBadge.fromTaskStatus(t.status),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.darkTextHint, size: 18),
          const SizedBox(width: 12),
          Text('$label: ',
              style: GoogleFonts.poppins(
                  color: AppColors.darkTextSecondary, fontSize: 13)),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Add Task Dialog ──────────────────────────────────────────────────────────

class _AddTaskDialog extends StatefulWidget {
  final UserModel assignedTo;
  final ValueChanged<TaskModel> onSave;
  const _AddTaskDialog({required this.assignedTo, required this.onSave});

  @override
  State<_AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<_AddTaskDialog> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  DateTime _deadline = DateTime.now().add(const Duration(days: 7));
  bool _requiresPhoto = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    return AlertDialog(
      backgroundColor: AppColors.darkCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Add Task for ${widget.assignedTo.name}',
        style: GoogleFonts.poppins(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _tf('Task Title', _titleCtrl),
            const SizedBox(height: 10),
            _tf('Description', _descCtrl, maxLines: 3),
            const SizedBox(height: 10),
            Row(
              children: [
                Text('Deadline: ',
                    style: GoogleFonts.poppins(
                        color: AppColors.darkTextSecondary, fontSize: 13)),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _deadline,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) setState(() => _deadline = picked);
                  },
                  child: Text(
                    '${_deadline.day}/${_deadline.month}/${_deadline.year}',
                    style: GoogleFonts.poppins(
                        color: AppColors.primaryTeal, fontSize: 13),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: _requiresPhoto,
                  onChanged: (v) => setState(() => _requiresPhoto = v ?? false),
                  activeColor: AppColors.primaryTeal,
                ),
                Text(
                  'Requires photo upload',
                  style: GoogleFonts.poppins(
                      color: AppColors.darkTextSecondary, fontSize: 13),
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
            if (_titleCtrl.text.trim().isEmpty) return;
            widget.onSave(TaskModel(
              id: 'task_${DateTime.now().millisecondsSinceEpoch}',
              title: _titleCtrl.text.trim(),
              description: _descCtrl.text.trim(),
              assignedToId: widget.assignedTo.id,
              assignedById: authProvider.currentUser?.id ?? 'admin',
              deadline: _deadline,
              createdAt: DateTime.now(),
              status: TaskStatus.pending,
              requiresPhotoUpload: _requiresPhoto,
            ));
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Task assigned successfully'),
                backgroundColor: AppColors.primaryTeal,
              ),
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal),
          child: Text('Assign Task', style: GoogleFonts.poppins(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _tf(String hint, TextEditingController ctrl, {int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: AppColors.darkTextHint, fontSize: 13),
        filled: true,
        fillColor: AppColors.darkSurface,
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.darkDivider)),
        enabledBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.darkDivider)),
        focusedBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primaryTeal)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}

// ─── Add Member Dialog ────────────────────────────────────────────────────────

class _AddMemberDialog extends StatefulWidget {
  final ValueChanged<UserModel> onSave;
  const _AddMemberDialog({required this.onSave});

  @override
  State<_AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<_AddMemberDialog> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _skillsCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _locationCtrl.dispose();
    _skillsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.darkCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Add New Member',
        style: GoogleFonts.poppins(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _tf('Full Name', _nameCtrl),
            const SizedBox(height: 10),
            _tf('Email', _emailCtrl),
            const SizedBox(height: 10),
            _tf('Phone', _phoneCtrl),
            const SizedBox(height: 10),
            _tf('Location', _locationCtrl),
            const SizedBox(height: 10),
            _tf('Skills (comma separated)', _skillsCtrl),
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
            if (_nameCtrl.text.trim().isEmpty) return;
            final skills = _skillsCtrl.text
                .split(',')
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty)
                .toList();
            widget.onSave(UserModel(
              id: 'u_${DateTime.now().millisecondsSinceEpoch}',
              name: _nameCtrl.text.trim(),
              email: _emailCtrl.text.trim(),
              phone: _phoneCtrl.text.trim(),
              location: _locationCtrl.text.trim(),
              avatar: '',
              role: UserRole.member,
              skills: skills,
              joinedDate: DateTime.now(),
            ));
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Member added successfully'),
                backgroundColor: AppColors.primaryTeal,
              ),
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal),
          child: Text('Add Member', style: GoogleFonts.poppins(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _tf(String hint, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
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
