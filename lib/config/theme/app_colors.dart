import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ─── Dark theme backgrounds ───────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF1A1A2E);
  static const Color darkCard = Color(0xFF16213E);
  static const Color darkSurface = Color(0xFF0F3460);
  static const Color darkDivider = Color(0xFF2A2A4A);

  // ─── Light theme backgrounds ──────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF5F5F5);
  static const Color lightSurface = Color(0xFFE8EAF6);
  static const Color lightDivider = Color(0xFFE0E0E0);

  // ─── Accent / Brand ───────────────────────────────────────────────────────
  static const Color primaryTeal = Color(0xFF00BFA6);
  static const Color primaryTealLight = Color(0xFF4DD0C4);
  static const Color primaryTealDark = Color(0xFF008C7A);

  static const Color secondaryOrange = Color(0xFFFF6B35);
  static const Color secondaryRed = Color(0xFFE53935);
  static const Color secondaryPurple = Color(0xFF7C4DFF);
  static const Color secondaryBlue = Color(0xFF1565C0);
  static const Color secondaryGold = Color(0xFFFFB300);

  // ─── Text colours ────────────────────────────────────────────────────────
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0BEC5);
  static const Color darkTextHint = Color(0xFF607D8B);

  static const Color lightTextPrimary = Color(0xFF1A1A2E);
  static const Color lightTextSecondary = Color(0xFF546E7A);
  static const Color lightTextHint = Color(0xFF90A4AE);

  // ─── Status ───────────────────────────────────────────────────────────────
  static const Color statusActive = Color(0xFF43A047);
  static const Color statusPending = Color(0xFFFF6B35);
  static const Color statusSubmitted = Color(0xFF1565C0);
  static const Color statusApproved = Color(0xFF43A047);
  static const Color statusRejected = Color(0xFFE53935);
  static const Color statusScheduled = Color(0xFF7C4DFF);
  static const Color statusCompleted = Color(0xFF00BFA6);

  // ─── Utility ──────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFFFB300);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF1565C0);
  static const Color transparent = Colors.transparent;
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // ─── Gradient helpers ────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryTeal, primaryTealDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [darkCard, darkSurface],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return statusActive;
      case 'pending':
        return statusPending;
      case 'submitted':
        return statusSubmitted;
      case 'approved':
        return statusApproved;
      case 'rejected':
        return statusRejected;
      case 'scheduled':
        return statusScheduled;
      case 'completed':
        return statusCompleted;
      default:
        return statusPending;
    }
  }
}
