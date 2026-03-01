import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme/app_colors.dart';
import '../../models/user_model.dart';

// ─── Sidebar Item Model ───────────────────────────────────────────────────────
class SidebarItem {
  final IconData icon;
  final String label;
  final int badgeCount;

  const SidebarItem({
    required this.icon,
    required this.label,
    this.badgeCount = 0,
  });
}

// ─── App Sidebar Widget ───────────────────────────────────────────────────────
class AppSidebar extends StatelessWidget {
  final List<SidebarItem> items;
  final int currentIndex;
  final ValueChanged<int> onItemTap;
  final UserModel user;
  final VoidCallback? onSignOut;

  const AppSidebar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onItemTap,
    required this.user,
    this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.darkCard,
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 8),
            const Divider(color: AppColors.darkDivider, height: 1),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: items.length,
                itemBuilder: (context, index) =>
                    _buildNavItem(context, items[index], index),
              ),
            ),
            const Divider(color: AppColors.darkDivider, height: 1),
            _buildSignOutButton(context),
          ],
        ),
      ),
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(
        children: [
          // Logo row
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.favorite, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 10),
              Text(
                'HopeConnect',
                style: GoogleFonts.poppins(
                  color: AppColors.primaryTeal,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // User info
          Row(
            children: [
              _buildAvatar(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.email,
                      style: GoogleFonts.poppins(
                        color: AppColors.darkTextSecondary,
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    _buildRoleBadge(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    final color = _avatarColor(user.name);
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryTeal.withAlpha(100), width: 2),
      ),
      child: Center(
        child: Text(
          user.initials,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildRoleBadge() {
    final (color, label) = _roleInfo(user.role.name);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ─── Nav Item ─────────────────────────────────────────────────────────────
  Widget _buildNavItem(BuildContext context, SidebarItem item, int index) {
    final isSelected = currentIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {
            onItemTap(index);
            Navigator.of(context).pop(); // close drawer
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryTeal.withAlpha(30)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: isSelected
                  ? Border.all(color: AppColors.primaryTeal.withAlpha(80))
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  color: isSelected
                      ? AppColors.primaryTeal
                      : AppColors.darkTextSecondary,
                  size: 20,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    item.label,
                    style: GoogleFonts.poppins(
                      color: isSelected
                          ? AppColors.primaryTeal
                          : AppColors.darkTextSecondary,
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                if (item.badgeCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryOrange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      item.badgeCount > 99
                          ? '99+'
                          : item.badgeCount.toString(),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Sign Out ─────────────────────────────────────────────────────────────
  Widget _buildSignOutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
            onSignOut?.call();
          },
          icon: const Icon(Icons.logout, size: 18, color: AppColors.secondaryRed),
          label: Text(
            'Sign Out',
            style: GoogleFonts.poppins(
              color: AppColors.secondaryRed,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.secondaryRed),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────
  Color _avatarColor(String name) {
    const colors = [
      AppColors.primaryTeal,
      AppColors.secondaryOrange,
      AppColors.secondaryPurple,
      AppColors.secondaryBlue,
      Color(0xFF43A047),
    ];
    final hash = name.codeUnits.fold(0, (sum, c) => sum + c);
    return colors[hash % colors.length];
  }

  (Color, String) _roleInfo(String roleName) {
    switch (roleName) {
      case 'superAdmin':
        return (AppColors.secondaryPurple, 'Super Admin');
      case 'admin':
        return (AppColors.secondaryBlue, 'Admin');
      case 'member':
        return (AppColors.primaryTeal, 'Member');
      case 'volunteer':
        return (const Color(0xFF43A047), 'Volunteer');
      default:
        return (AppColors.darkTextSecondary, roleName);
    }
  }
}
