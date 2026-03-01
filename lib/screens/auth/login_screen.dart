import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../config/router/app_router.dart';
import '../../config/theme/app_colors.dart';
import '../../core/enums/user_role.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_data_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final authProvider = context.read<AuthProvider>();
    final dataProvider = context.read<AppDataProvider>();

    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
      dataProvider,
    );

    if (!mounted) return;

    if (success) {
      final role = authProvider.currentUser?.role;
      switch (role) {
        case UserRole.superAdmin:
          context.go(AppRoutes.superAdmin);
          break;
        case UserRole.admin:
          context.go(AppRoutes.admin);
          break;
        case UserRole.member:
          context.go(AppRoutes.member);
          break;
        case UserRole.volunteer:
          context.go(AppRoutes.volunteer);
          break;
        default:
          context.go(AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: _buildBranding(),
                ),
                const SizedBox(height: 40),
                _buildLoginCard(authProvider),
                const SizedBox(height: 24),
                _buildDemoCredentials(),
                const SizedBox(height: 24),
                _buildPublicPageLink(context),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Branding ─────────────────────────────────────────────────────────────
  Widget _buildBranding() {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryTeal.withAlpha(100),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.favorite, color: Colors.white, size: 36),
        ),
        const SizedBox(height: 16),
        Text(
          'Jayshree Foundation',
          style: GoogleFonts.poppins(
            color: AppColors.primaryTeal,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          'NGO Management Platform',
          style: GoogleFonts.poppins(
            color: AppColors.darkTextSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  // ─── Login Card ──────────────────────────────────────────────────────────
  Widget _buildLoginCard(AuthProvider authProvider) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.darkDivider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(60),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Sign in to your account',
              style: GoogleFonts.poppins(
                color: AppColors.darkTextSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 28),

            // Error message
            if (authProvider.error != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.error.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.error.withAlpha(80)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.error, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        authProvider.error!,
                        style: GoogleFonts.poppins(
                          color: AppColors.error,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Email field
            _buildInputLabel('Email Address'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
              decoration: _inputDecoration(
                hint: 'Enter your email',
                prefixIcon: Icons.email_outlined,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email is required';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Password field
            _buildInputLabel('Password'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passwordController,
              obscureText: !_passwordVisible,
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
              decoration: _inputDecoration(
                hint: 'Enter your password',
                prefixIcon: Icons.lock_outline,
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.darkTextHint,
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _passwordVisible = !_passwordVisible),
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password is required';
                if (v.length < 6) return 'Password must be at least 6 characters';
                return null;
              },
            ),
            const SizedBox(height: 32),

            // Sign In button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: authProvider.isLoading
                  ? Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        ),
                      ),
                    )
                  : DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryTeal.withAlpha(80),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Sign In',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        color: AppColors.darkTextSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(
        color: AppColors.darkTextHint,
        fontSize: 13,
      ),
      prefixIcon: Icon(prefixIcon, color: AppColors.darkTextHint, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.darkBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        borderSide: const BorderSide(color: AppColors.primaryTeal, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      errorStyle: GoogleFonts.poppins(color: AppColors.error, fontSize: 11),
    );
  }

  // ─── Demo Credentials ─────────────────────────────────────────────────────
  Widget _buildDemoCredentials() {
    final creds = [
      _CredInfo('SuperAdmin', 'superadmin@jayshreefoundation.org', AppColors.secondaryPurple),
      _CredInfo('Admin', 'admin@jayshreefoundation.org', AppColors.secondaryBlue),
      _CredInfo('Member', 'anjali@jayshreefoundation.org', AppColors.primaryTeal),
      _CredInfo('Volunteer', 'amit@jayshreefoundation.org', const Color(0xFF43A047)),
    ];

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
              const Icon(Icons.info_outline, color: AppColors.primaryTeal, size: 16),
              const SizedBox(width: 8),
              Text(
                'Demo Credentials (password: password123)',
                style: GoogleFonts.poppins(
                  color: AppColors.primaryTeal,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...creds.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () {
                    _emailController.text = c.email;
                    _passwordController.text = 'password123';
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: c.color.withAlpha(15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: c.color.withAlpha(60)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: c.color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            c.role,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            c.email,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkTextSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const Icon(Icons.touch_app, color: AppColors.darkTextHint, size: 14),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  // ─── Public Page Link ─────────────────────────────────────────────────────
  Widget _buildPublicPageLink(BuildContext context) {
    return TextButton(
      onPressed: () => context.go('/'),
      child: Text(
        'Go to Public Page →',
        style: GoogleFonts.poppins(
          color: AppColors.darkTextSecondary,
          fontSize: 13,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.darkTextSecondary,
        ),
      ),
    );
  }
}

class _CredInfo {
  final String role;
  final String email;
  final Color color;
  const _CredInfo(this.role, this.email, this.color);
}
