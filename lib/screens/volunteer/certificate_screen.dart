import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme/app_colors.dart';
import '../../core/enums/status.dart';
import '../../models/certificate_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_data_provider.dart';
import '../../widgets/common/status_badge.dart';
import '../../widgets/dialogs/request_certificate_dialog.dart';

class VolunteerCertificateScreen extends StatelessWidget {
  const VolunteerCertificateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final data = context.watch<AppDataProvider>();
    final userId = auth.currentUser?.id ?? '';
    final myCerts = data.certificates
        .where((c) => c.requestedById == userId)
        .toList()
      ..sort(
          (a, b) => b.requestedDate.compareTo(a.requestedDate));

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text('Certificate of Completion',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Text(
                              'Request completion certificates for your volunteer work',
                              style: GoogleFonts.poppins(
                                  color:
                                      AppColors.darkTextSecondary,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryTeal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10)),
                        ),
                        onPressed: () =>
                            RequestCertificateDialog.show(
                          context,
                          requestedById: userId,
                          onSubmit: (cert) =>
                              data.addCertificate(cert),
                        ),
                        icon: const Icon(Icons.add,
                            size: 16, color: Colors.white),
                        label: Text('Request',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Info card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal.withAlpha(15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.primaryTeal
                              .withAlpha(60)),
                    ),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline,
                            color: AppColors.primaryTeal,
                            size: 16),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Your certificate request goes to the Admin you are assigned to and to the Super Admin for approval',
                            style: GoogleFonts.poppins(
                                color:
                                    AppColors.darkTextSecondary,
                                fontSize: 12,
                                height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('My Requests',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          if (myCerts.isEmpty)
            SliverFillRemaining(
              child: _EmptyCertState(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) =>
                      _CertListItem(cert: myCerts[i]),
                  childCount: myCerts.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CertListItem extends StatelessWidget {
  final CertificateModel cert;
  const _CertListItem({required this.cert});

  @override
  Widget build(BuildContext context) {
    final isApproved = cert.status == RequestStatus.approved;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkDivider),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryTeal.withAlpha(25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.workspace_premium,
                color: AppColors.primaryTeal, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(cert.certificateType,
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                    ),
                    StatusBadge.fromRequestStatus(cert.status),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Requested: ${DateFormat('dd MMM yyyy').format(cert.requestedDate)}',
                  style: GoogleFonts.poppins(
                      color: AppColors.darkTextHint,
                      fontSize: 11),
                ),
                if (isApproved) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        SnackBar(
                          content: Text(
                              'Downloading ${cert.certificateType}...'),
                          backgroundColor:
                              AppColors.primaryTeal,
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.download_outlined,
                            color: AppColors.primaryTeal,
                            size: 14),
                        const SizedBox(width: 4),
                        Text('Download Certificate',
                            style: GoogleFonts.poppins(
                                color: AppColors.primaryTeal,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCertState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.workspace_premium_outlined,
              color: AppColors.darkTextHint, size: 56),
          const SizedBox(height: 16),
          Text('No certificate requests yet',
              style: GoogleFonts.poppins(
                  color: AppColors.darkTextSecondary,
                  fontSize: 15)),
          const SizedBox(height: 8),
          Text('Tap "+ Request" to submit a request',
              style: GoogleFonts.poppins(
                  color: AppColors.darkTextHint, fontSize: 13)),
        ],
      ),
    );
  }
}
