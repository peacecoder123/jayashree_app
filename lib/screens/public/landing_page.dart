import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/router/app_router.dart';
import '../../config/theme/app_colors.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  late AnimationController _gradientController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAppBar(context),
            _buildHeroSection(context),
            _buildCtaSection(context),
            _buildProjectsSection(context),
            _buildNewsSection(context),
            _buildAboutSection(context),
            _buildContactSection(context),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  // ─── App Bar ─────────────────────────────────────────────────────────────
  Widget _buildAppBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = screenWidth < 400 ? 16.0 : 20.0;
    return Container(
      color: const Color(0xFF0F0F1E),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.favorite, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jayshree Foundation',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: AppColors.primaryTeal,
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'NGO Management',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: AppColors.darkTextSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () => context.go(AppRoutes.login),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryTeal,
              side: const BorderSide(color: AppColors.primaryTeal),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Login',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Hero Section ─────────────────────────────────────────────────────────
  Widget _buildHeroSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double titleSize;
    final double subtitleSize;
    final double bodySize;
    if (screenWidth < 400) {
      titleSize = 28;
      subtitleSize = 24;
      bodySize = 13;
    } else if (screenWidth < 600) {
      titleSize = 34;
      subtitleSize = 30;
      bodySize = 14;
    } else {
      titleSize = 42;
      subtitleSize = 38;
      bodySize = 15;
    }
    return AnimatedBuilder(
      animation: _gradientController,
      builder: (context, child) {
        final t = _gradientController.value;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(const Color(0xFF0F3460), const Color(0xFF16213E), t)!,
                Color.lerp(const Color(0xFF1A1A2E), const Color(0xFF0F3460), t)!,
                Color.lerp(const Color(0xFF00BFA6).withAlpha(40), const Color(0xFF004D40).withAlpha(80), t)!,
              ],
            ),
          ),
          child: child,
        );
      },
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal.withAlpha(30),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primaryTeal.withAlpha(80)),
                ),
                child: Text(
                  '🌟 Making a Difference Together',
                  style: GoogleFonts.poppins(
                    color: AppColors.primaryTeal,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Jayshree Foundation',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: titleSize,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              Text(
                'NGO Management',
                style: GoogleFonts.poppins(
                  color: AppColors.primaryTeal,
                  fontSize: subtitleSize,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Empowering communities, connecting volunteers,\nand transforming lives through organized action.',
                style: GoogleFonts.poppins(
                  color: AppColors.darkTextSecondary,
                  fontSize: bodySize,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 20,
                runSpacing: 12,
                children: [
                  _buildHeroStat('500+', 'Volunteers'),
                  _buildHeroStat('₹12L+', 'Donations'),
                  _buildHeroStat('200+', 'Lives Helped'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            color: AppColors.primaryTeal,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: AppColors.darkTextSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // ─── CTA Section ──────────────────────────────────────────────────────────
  Widget _buildCtaSection(BuildContext context) {
    return Container(
      color: AppColors.darkCard,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        children: [
          Text(
            'Join Our Mission',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose how you want to contribute to our cause',
            style: GoogleFonts.poppins(
              color: AppColors.darkTextSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              _buildCtaButton(
                icon: Icons.card_membership,
                label: 'I want to become\na Member',
                color: AppColors.primaryTeal,
                onTap: () => context.go(AppRoutes.login),
              ),
              _buildCtaButton(
                icon: Icons.volunteer_activism,
                label: 'I want to become\na Volunteer',
                color: const Color(0xFF43A047),
                onTap: () => context.go(AppRoutes.login),
              ),
              _buildCtaButton(
                icon: Icons.favorite_rounded,
                label: 'Donate\nUs',
                color: AppColors.secondaryOrange,
                onTap: () => context.go(AppRoutes.login),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCtaButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withAlpha(180)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(80),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 36),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Projects Section ─────────────────────────────────────────────────────
  Widget _buildProjectsSection(BuildContext context) {
    final projects = [
      _ProjectData(
        title: 'Food Drive 2024',
        description: 'Providing nutritious meals to underprivileged families across the city.',
        icon: Icons.restaurant,
        color: AppColors.secondaryOrange,
        progress: 0.72,
        raised: '₹86,400',
        goal: '₹1,20,000',
      ),
      _ProjectData(
        title: 'Medical Camp',
        description: 'Free health check-ups and medicines for rural communities.',
        icon: Icons.local_hospital,
        color: const Color(0xFFE53935),
        progress: 0.55,
        raised: '₹55,000',
        goal: '₹1,00,000',
      ),
      _ProjectData(
        title: 'Education Initiative',
        description: 'Scholarship and study material support for 200+ students.',
        icon: Icons.school,
        color: AppColors.secondaryBlue,
        progress: 0.88,
        raised: '₹1,05,600',
        goal: '₹1,20,000',
      ),
    ];

    return Container(
      color: AppColors.darkBackground,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Recent Projects', 'Active campaigns making an impact'),
          const SizedBox(height: 24),
          ...projects.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildProjectCard(p),
              )),
        ],
      ),
    );
  }

  Widget _buildProjectCard(_ProjectData p) {
    return Container(
      padding: const EdgeInsets.all(20),
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
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: p.color.withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(p.icon, color: p.color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  p.title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal.withAlpha(30),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(p.progress * 100).toInt()}%',
                  style: GoogleFonts.poppins(
                    color: AppColors.primaryTeal,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            p.description,
            style: GoogleFonts.poppins(
              color: AppColors.darkTextSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: p.progress,
              backgroundColor: AppColors.darkDivider,
              valueColor: AlwaysStoppedAnimation<Color>(p.color),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Raised: ${p.raised}',
                style: GoogleFonts.poppins(
                  color: p.color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Goal: ${p.goal}',
                style: GoogleFonts.poppins(
                  color: AppColors.darkTextSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── News Section ─────────────────────────────────────────────────────────
  Widget _buildNewsSection(BuildContext context) {
    final news = [
      _NewsData(
        title: 'Jayshree Foundation Reaches 500 Volunteer Milestone',
        summary: 'We are proud to announce that our volunteer network has grown to 500 active members, making us one of the largest NGO volunteer networks in the region.',
        date: 'Jan 15, 2025',
        icon: Icons.people,
        color: AppColors.primaryTeal,
      ),
      _NewsData(
        title: 'Annual Medical Camp Serves 1,200 Patients',
        summary: 'Our recent 3-day medical camp provided free consultations, medicines, and health screenings to over 1,200 patients from underserved communities.',
        date: 'Dec 20, 2024',
        icon: Icons.medical_services,
        color: const Color(0xFFE53935),
      ),
      _NewsData(
        title: 'New Partnership with City Food Bank',
        summary: 'Jayshree Foundation has partnered with the City Food Bank to expand our food distribution program, ensuring no family goes hungry in our community.',
        date: 'Nov 30, 2024',
        icon: Icons.handshake,
        color: AppColors.secondaryOrange,
      ),
    ];

    return Container(
      color: AppColors.darkCard,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Latest News', 'Stay updated with our activities'),
          const SizedBox(height: 24),
          ...news.map((n) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildNewsCard(n),
              )),
        ],
      ),
    );
  }

  Widget _buildNewsCard(_NewsData n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkDivider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: n.color.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(n.icon, color: n.color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  n.title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  n.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: AppColors.darkTextSecondary,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  n.date,
                  style: GoogleFonts.poppins(
                    color: n.color,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── About Section ────────────────────────────────────────────────────────
  Widget _buildAboutSection(BuildContext context) {
    return Container(
      color: AppColors.darkBackground,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('About Us', 'Who we are and what we do'),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryTeal.withAlpha(20),
                  AppColors.darkCard,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primaryTeal.withAlpha(60)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jayshree Foundation NGO',
                  style: GoogleFonts.poppins(
                    color: AppColors.primaryTeal,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Founded in 2018, Jayshree Foundation is a registered NGO dedicated to empowering underprivileged communities through education, healthcare, nutrition, and livelihood programs.',
                  style: GoogleFonts.poppins(
                    color: AppColors.darkTextSecondary,
                    fontSize: 14,
                    height: 1.7,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Our platform connects passionate volunteers, dedicated members, and generous donors to create meaningful change. We believe in transparent operations, measurable impact, and community-first approach.',
                  style: GoogleFonts.poppins(
                    color: AppColors.darkTextSecondary,
                    fontSize: 14,
                    height: 1.7,
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildAboutChip(Icons.verified, 'Registered NGO', AppColors.primaryTeal),
                    _buildAboutChip(Icons.receipt_long, '80G Certified', AppColors.secondaryOrange),
                    _buildAboutChip(Icons.emoji_events, 'Award Winning', AppColors.secondaryGold),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Contact Section ──────────────────────────────────────────────────────
  Widget _buildContactSection(BuildContext context) {
    return Container(
      color: AppColors.darkCard,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Contact Us', 'Get in touch with us'),
          const SizedBox(height: 24),
          _buildContactItem(Icons.location_on, 'Address',
              '123, Hope Street, Andheri West,\nMumbai, Maharashtra – 400053'),
          const SizedBox(height: 16),
          _buildContactItem(Icons.phone, 'WhatsApp / Phone',
              '+91 98765 43210'),
          const SizedBox(height: 16),
          _buildContactItem(Icons.email, 'Email',
              'contact@jayshreefoundation.org'),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.chat, color: Colors.white),
              label: Text(
                'Chat on WhatsApp',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryTeal.withAlpha(25),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primaryTeal, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: AppColors.darkTextSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Footer ───────────────────────────────────────────────────────────────
  Widget _buildFooter(BuildContext context) {
    return Container(
      color: const Color(0xFF0A0A1A),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.favorite, color: AppColors.primaryTeal, size: 16),
              const SizedBox(width: 8),
              Text(
                'Jayshree Foundation',
                style: GoogleFonts.poppins(
                  color: AppColors.primaryTeal,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Empowering communities, one step at a time.',
            style: GoogleFonts.poppins(
              color: AppColors.darkTextSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.darkDivider),
          const SizedBox(height: 12),
          Text(
            '© ${DateTime.now().year} Jayshree Foundation NGO. All rights reserved.',
            style: GoogleFonts.poppins(
              color: AppColors.darkTextHint,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────
  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.poppins(
            color: AppColors.darkTextSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

// ─── Data Models ─────────────────────────────────────────────────────────────
class _ProjectData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final double progress;
  final String raised;
  final String goal;

  const _ProjectData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.progress,
    required this.raised,
    required this.goal,
  });
}

class _NewsData {
  final String title;
  final String summary;
  final String date;
  final IconData icon;
  final Color color;

  const _NewsData({
    required this.title,
    required this.summary,
    required this.date,
    required this.icon,
    required this.color,
  });
}
