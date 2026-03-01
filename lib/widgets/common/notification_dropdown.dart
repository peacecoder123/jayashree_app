import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme/app_colors.dart';

class NotificationItem {
  final IconData icon;
  final Color iconColor;
  final String text;
  final String timeAgo;

  const NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.text,
    required this.timeAgo,
  });
}

class NotificationDropdown extends StatelessWidget {
  final List<NotificationItem> notifications;
  final VoidCallback? onViewAll;

  const NotificationDropdown({
    super.key,
    required this.notifications,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 320,
        constraints: const BoxConstraints(maxHeight: 400),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.darkDivider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(100),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 12, 10),
              child: Row(
                children: [
                  Text(
                    'Notifications',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  if (notifications.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTeal.withAlpha(30),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${notifications.length}',
                        style: GoogleFonts.poppins(
                          color: AppColors.primaryTeal,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const Divider(color: AppColors.darkDivider, height: 1),

            // Notification list
            if (notifications.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.notifications_none,
                        color: AppColors.darkTextHint, size: 40),
                    const SizedBox(height: 8),
                    Text(
                      'No new notifications',
                      style: GoogleFonts.poppins(
                        color: AppColors.darkTextHint,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shrinkWrap: true,
                  itemCount: notifications.length,
                  separatorBuilder: (_, __) =>
                      const Divider(color: AppColors.darkDivider, height: 1),
                  itemBuilder: (context, index) =>
                      _NotificationTile(item: notifications[index]),
                ),
              ),

            // View all button
            if (onViewAll != null && notifications.isNotEmpty) ...[
              const Divider(color: AppColors.darkDivider, height: 1),
              TextButton(
                onPressed: onViewAll,
                child: Text(
                  'View All Notifications',
                  style: GoogleFonts.poppins(
                    color: AppColors.primaryTeal,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationItem item;
  const _NotificationTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: item.iconColor.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(item.icon, color: item.iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.text,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.timeAgo,
                  style: GoogleFonts.poppins(
                    color: AppColors.darkTextHint,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
