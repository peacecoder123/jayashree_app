import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme/app_colors.dart';
import '../../models/user_model.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int notificationCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onThemeTap;
  final UserModel? user;

  const CustomAppBar({
    super.key,
    required this.title,
    this.notificationCount = 0,
    this.onNotificationTap,
    this.onSettingsTap,
    this.onThemeTap,
    this.user,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF0F0F1E),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      actions: [
        // Theme toggle
        IconButton(
          onPressed: onThemeTap,
          icon: const Icon(Icons.brightness_6_outlined,
              color: AppColors.darkTextSecondary, size: 22),
          tooltip: 'Toggle Theme',
        ),

        // Settings
        IconButton(
          onPressed: onSettingsTap,
          icon: const Icon(Icons.settings_outlined,
              color: AppColors.darkTextSecondary, size: 22),
          tooltip: 'Settings',
        ),

        // Notification bell
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              onPressed: onNotificationTap,
              icon: const Icon(Icons.notifications_outlined,
                  color: AppColors.darkTextSecondary, size: 24),
              tooltip: 'Notifications',
            ),
            if (notificationCount > 0)
              Positioned(
                top: 8,
                right: 8,
                child: IgnorePointer(
                  child: Container(
                    width: 17,
                    height: 17,
                    decoration: const BoxDecoration(
                      color: AppColors.secondaryRed,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        notificationCount > 9 ? '9+' : '$notificationCount',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),

        // User avatar
        if (user != null)
          Padding(
            padding: const EdgeInsets.only(right: 12, left: 4),
            child: _UserAvatar(user: user!),
          ),
      ],
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final UserModel user;
  const _UserAvatar({required this.user});

  Color get _avatarColor {
    const colors = [
      AppColors.primaryTeal,
      AppColors.secondaryOrange,
      AppColors.secondaryPurple,
      AppColors.secondaryBlue,
      Color(0xFF43A047),
    ];
    final hash = user.name.codeUnits.fold(0, (sum, c) => sum + c);
    return colors[hash % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: _avatarColor,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryTeal.withAlpha(120), width: 1.5),
      ),
      child: Center(
        child: Text(
          user.initials,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
