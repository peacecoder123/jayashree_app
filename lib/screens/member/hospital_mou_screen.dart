import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme/app_colors.dart';
import '../../core/enums/status.dart';
import '../../models/mou_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_data_provider.dart';
import '../../widgets/common/status_badge.dart';
import '../../widgets/dialogs/request_mou_dialog.dart';

class MemberHospitalMouScreen extends StatelessWidget {
  const MemberHospitalMouScreen({super.key});

  void _showMouDetail(BuildContext context, MouModel mou) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.45,
        maxChildSize: 0.92,
        expand: false,
        builder: (_, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('MOU Details',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
                StatusBadge.fromMouStatus(mou.status),
              ],
            ),
            const SizedBox(height: 20),
            _DetailRow(label: 'Patient Name', value: mou.patientName),
            _DetailRow(
                label: 'Age', value: '${mou.patientAge} years'),
            _DetailRow(label: 'Blood Group', value: mou.bloodGroup),
            _DetailRow(label: 'Disease / Condition', value: mou.disease),
            _DetailRow(label: 'Hospital', value: mou.hospitalName),
            _DetailRow(label: 'Phone', value: mou.phone),
            _DetailRow(label: 'Address', value: mou.address),
            _DetailRow(
              label: 'Submitted On',
              value: DateFormat('dd MMM yyyy').format(mou.submittedDate),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final data = context.watch<AppDataProvider>();
    final userId = auth.currentUser?.id ?? '';
    final myMous =
        data.mouRequests.where((m) => m.submittedById == userId).toList()
          ..sort((a, b) => b.submittedDate.compareTo(a.submittedDate));

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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hospital MOU',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Text(
                              'Request Medical MOU for patients in need',
                              style: GoogleFonts.poppins(
                                  color: AppColors.darkTextSecondary,
                                  fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryRed,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => RequestMouDialog.show(
                          context,
                          submittedById: userId,
                          onSubmit: (mou) => data.addMouRequest(mou),
                        ),
                        icon: const Icon(Icons.add,
                            size: 16, color: Colors.white),
                        label: Text('Request MOU',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // About card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.darkCard,
                      borderRadius: BorderRadius.circular(12),
                      border: const Border(
                        left: BorderSide(
                            color: AppColors.secondaryRed, width: 4),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.local_hospital,
                                color: AppColors.secondaryRed, size: 16),
                            const SizedBox(width: 8),
                            Text('About MOU Process',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'A Memorandum of Understanding (MOU) is a formal agreement between Jayshree Foundation and hospitals to provide medical assistance. Submit your request with patient details and our team will process it with the respective hospital.',
                          style: GoogleFonts.poppins(
                              color: AppColors.darkTextSecondary,
                              fontSize: 12,
                              height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
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
          if (myMous.isEmpty)
            const SliverFillRemaining(
              child: _EmptyMouState(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => _MouListItem(
                    mou: myMous[i],
                    onViewDetails: () =>
                        _showMouDetail(context, myMous[i]),
                  ),
                  childCount: myMous.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MouListItem extends StatelessWidget {
  final MouModel mou;
  final VoidCallback onViewDetails;

  const _MouListItem({required this.mou, required this.onViewDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(mou.patientName,
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
              ),
              StatusBadge.fromMouStatus(mou.status),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 4,
            children: [
              _MiniInfo(
                  label: 'Age', value: '${mou.patientAge} yrs'),
              _MiniInfo(
                  label: 'Blood Group', value: mou.bloodGroup),
              _MiniInfo(label: 'Disease', value: mou.disease),
            ],
          ),
          const SizedBox(height: 8),
          _MiniInfo(label: 'Hospital', value: mou.hospitalName),
          const SizedBox(height: 4),
          _MiniInfo(label: 'Phone', value: mou.phone),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('dd MMM yyyy')
                    .format(mou.submittedDate),
                style: GoogleFonts.poppins(
                    color: AppColors.darkTextHint, fontSize: 11),
              ),
              GestureDetector(
                onTap: onViewDetails,
                child: Text(
                  'View Full details →',
                  style: GoogleFonts.poppins(
                      color: AppColors.primaryTeal,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniInfo extends StatelessWidget {
  final String label;
  final String value;
  const _MiniInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.poppins(fontSize: 12),
        children: [
          TextSpan(
              text: '$label: ',
              style:
                  const TextStyle(color: AppColors.darkTextHint)),
          TextSpan(
              text: value,
              style: const TextStyle(
                  color: AppColors.darkTextSecondary)),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text('$label:',
                style: GoogleFonts.poppins(
                    color: AppColors.darkTextHint, fontSize: 13)),
          ),
          Expanded(
            child: Text(value,
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}

class _EmptyMouState extends StatelessWidget {
  const _EmptyMouState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.local_hospital_outlined,
              color: AppColors.darkTextHint, size: 56),
          const SizedBox(height: 16),
          Text('No MOU requests yet',
              style: GoogleFonts.poppins(
                  color: AppColors.darkTextSecondary, fontSize: 15)),
          const SizedBox(height: 8),
          Text('Tap "+ Request MOU" to submit a request',
              style: GoogleFonts.poppins(
                  color: AppColors.darkTextHint, fontSize: 13)),
        ],
      ),
    );
  }
}
