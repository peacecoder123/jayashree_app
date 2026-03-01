import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme/app_colors.dart';

class SearchFilterBar extends StatelessWidget {
  final TextEditingController? searchController;
  final String searchHint;
  final List<String> filterOptions;
  final String? selectedFilter;
  final ValueChanged<String?>? onFilterChanged;
  final ValueChanged<String>? onSearchChanged;

  const SearchFilterBar({
    super.key,
    this.searchController,
    this.searchHint = 'Search...',
    this.filterOptions = const [],
    this.selectedFilter,
    this.onFilterChanged,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search field
        Expanded(
          child: TextField(
            controller: searchController,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: searchHint,
              hintStyle: GoogleFonts.poppins(
                color: AppColors.darkTextHint,
                fontSize: 13,
              ),
              prefixIcon: const Icon(Icons.search,
                  color: AppColors.darkTextHint, size: 20),
              filled: true,
              fillColor: AppColors.darkCard,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                borderSide:
                    const BorderSide(color: AppColors.primaryTeal, width: 1.5),
              ),
            ),
          ),
        ),

        // Filter dropdown
        if (filterOptions.isNotEmpty) ...[
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.darkDivider),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedFilter,
                dropdownColor: AppColors.darkCard,
                style: GoogleFonts.poppins(
                  color: AppColors.darkTextSecondary,
                  fontSize: 13,
                ),
                icon: const Icon(Icons.keyboard_arrow_down,
                    color: AppColors.darkTextSecondary, size: 18),
                onChanged: onFilterChanged,
                items: filterOptions
                    .map((opt) => DropdownMenuItem(
                          value: opt,
                          child: Text(opt),
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
