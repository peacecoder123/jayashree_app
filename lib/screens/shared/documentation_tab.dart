import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:jayshree_foundation/config/theme/app_colors.dart';
import 'package:jayshree_foundation/models/document_model.dart';
import 'package:jayshree_foundation/providers/app_data_provider.dart';

class DocumentationTab extends StatefulWidget {
  const DocumentationTab({super.key});

  @override
  State<DocumentationTab> createState() => _DocumentationTabState();
}

class _DocumentationTabState extends State<DocumentationTab> {
  String _search = '';
  final _scrollController = ScrollController();
  final Map<String, GlobalKey> _categoryKeys = {};

  static const _categories = ['LEGAL', 'TAX', 'REPORTS', 'FINANCIAL', 'GOVERNANCE'];

  static const _categoryColors = {
    'LEGAL': AppColors.secondaryBlue,
    'TAX': AppColors.statusApproved,
    'REPORTS': AppColors.secondaryOrange,
    'FINANCIAL': AppColors.secondaryGold,
    'GOVERNANCE': AppColors.secondaryPurple,
  };

  static const _categoryIcons = {
    'LEGAL': Icons.gavel,
    'TAX': Icons.assignment,
    'REPORTS': Icons.pie_chart,
    'FINANCIAL': Icons.account_balance,
    'GOVERNANCE': Icons.description,
  };

  @override
  void initState() {
    super.initState();
    for (final cat in _categories) {
      _categoryKeys[cat] = GlobalKey();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCategory(String category) {
    final key = _categoryKeys[category];
    if (key == null) return;
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 400));
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppDataProvider>();
    final allDocs = data.documents;

    final filtered = _search.isEmpty
        ? allDocs
        : allDocs
            .where((d) => d.name.toLowerCase().contains(_search.toLowerCase()))
            .toList();

    // Group by category
    final grouped = <String, List<DocumentModel>>{};
    for (final cat in _categories) {
      final docs = filtered.where((d) => d.category == cat).toList();
      if (docs.isNotEmpty) grouped[cat] = docs;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Main content ──────────────────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Documentation',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${allDocs.length} documents',
                            style: GoogleFonts.poppins(
                              color: AppColors.darkTextSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Search
                TextField(
                  onChanged: (v) => setState(() => _search = v),
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Search documents...',
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
                const SizedBox(height: 20),

                // Grouped document sections
                if (grouped.isEmpty)
                  Center(
                    child: Text(
                      'No documents found',
                      style: GoogleFonts.poppins(color: AppColors.darkTextSecondary),
                    ),
                  )
                else
                  ...grouped.entries.map(
                    (entry) => _CategorySection(
                      key: _categoryKeys[entry.key],
                      category: entry.key,
                      docs: entry.value,
                      color: _categoryColors[entry.key] ?? AppColors.primaryTeal,
                      icon: _categoryIcons[entry.key] ?? Icons.description,
                    ),
                  ),
              ],
            ),
          ),
        ),

        // ── Quick Access Panel ────────────────────────────────────────────────
        _QuickAccessPanel(
          categories: grouped.keys.toList(),
          categoryColors: _categoryColors,
          onTap: _scrollToCategory,
        ),
      ],
    );
  }
}

// ─── Category Section ─────────────────────────────────────────────────────────

class _CategorySection extends StatelessWidget {
  final String category;
  final List<DocumentModel> docs;
  final Color color;
  final IconData icon;

  const _CategorySection({
    super.key,
    required this.category,
    required this.docs,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category header
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 10),
              Text(
                category,
                style: GoogleFonts.poppins(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${docs.length}',
                  style: GoogleFonts.poppins(color: color, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Documents
          Container(
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.darkDivider),
            ),
            child: Column(
              children: docs
                  .asMap()
                  .entries
                  .map(
                    (e) => _DocumentItem(
                      doc: e.value,
                      color: color,
                      icon: icon,
                      isLast: e.key == docs.length - 1,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentItem extends StatelessWidget {
  final DocumentModel doc;
  final Color color;
  final IconData icon;
  final bool isLast;

  const _DocumentItem({
    required this.doc,
    required this.color,
    required this.icon,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Opening ${doc.name}...'),
                backgroundColor: AppColors.darkSurface,
                duration: const Duration(seconds: 2),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: color.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    doc.name,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(
                  Icons.open_in_new,
                  color: AppColors.darkTextHint,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
        if (!isLast)
          const Divider(
            color: AppColors.darkDivider,
            height: 1,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}

// ─── Quick Access Panel ───────────────────────────────────────────────────────

class _QuickAccessPanel extends StatelessWidget {
  final List<String> categories;
  final Map<String, Color> categoryColors;
  final ValueChanged<String> onTap;

  const _QuickAccessPanel({
    required this.categories,
    required this.categoryColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      margin: const EdgeInsets.fromLTRB(0, 20, 12, 20),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkDivider),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Jump',
              style: GoogleFonts.poppins(
                color: AppColors.darkTextHint,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(color: AppColors.darkDivider, height: 1),
          ...categories.map(
            (cat) => Tooltip(
              message: cat,
              child: InkWell(
                onTap: () => onTap(cat),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: (categoryColors[cat] ?? AppColors.primaryTeal).withAlpha(25),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        cat[0],
                        style: GoogleFonts.poppins(
                          color: categoryColors[cat] ?? AppColors.primaryTeal,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
