import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/features/auth/domain/entities/country_entity.dart';
import 'package:m_kemet/src/features/candidate_search/domain/entities/candidate_search_filter_entity.dart';
import 'package:m_kemet/src/features/candidate_search/presentation/widgets/filter_option_chip.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/profession_entity.dart';

class CandidateFilterBottomSheet extends StatefulWidget {
  final CandidateSearchFilterEntity initialFilter;
  final List<CountryEntity> topCountries;
  final List<ProfessionEntity> popularProfessions;
  final bool isLoadingLookups;
  final ValueChanged<CandidateSearchFilterEntity> onApplyFilter;

  const CandidateFilterBottomSheet({
    super.key,
    required this.initialFilter,
    required this.topCountries,
    required this.popularProfessions,
    this.isLoadingLookups = false,
    required this.onApplyFilter,
  });

  @override
  State<CandidateFilterBottomSheet> createState() => _CandidateFilterBottomSheetState();
}

class _CandidateFilterBottomSheetState extends State<CandidateFilterBottomSheet> {
  int? _selectedCountryId;
  String? _selectedCountryName;
  int? _selectedProfessionId;
  String? _selectedProfessionName;
  String? _selectedGender;
  bool? _selectedPassportStatus;

  @override
  void initState() {
    super.initState();
    _selectedCountryId = widget.initialFilter.countryId;
    _selectedCountryName = widget.initialFilter.countryName;
    _selectedProfessionId = widget.initialFilter.professionId;
    _selectedProfessionName = widget.initialFilter.professionName;
    _selectedGender = widget.initialFilter.gender;
    _selectedPassportStatus = widget.initialFilter.isValidPassport;
  }

  void _reset() {
    setState(() {
      _selectedCountryId = null;
      _selectedCountryName = null;
      _selectedProfessionId = null;
      _selectedProfessionName = null;
      _selectedGender = null;
      _selectedPassportStatus = null;
    });
  }

  void _apply() {
    final updated = widget.initialFilter.copyWith(
      countryId: _selectedCountryId,
      countryName: _selectedCountryName,
      professionId: _selectedProfessionId,
      professionName: _selectedProfessionName,
      gender: _selectedGender,
      isValidPassport: _selectedPassportStatus,
      resetCountry: _selectedCountryId == null && (_selectedCountryName == null || _selectedCountryName == 'الكل'),
      resetProfession: _selectedProfessionId == null && (_selectedProfessionName == null || _selectedProfessionName == 'الكل'),
      resetGender: _selectedGender == null || _selectedGender == 'الكل',
      resetPassport: _selectedPassportStatus == null,
    );
    widget.onApplyFilter(updated);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 44.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(3.r),
                ),
              ),
            ),

            16.szH,

            // Header Title & Reset Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.tune_rounded, color: AppColors.darkNavy, size: 20.sp),
                    8.szW,
                    Text(
                      S.of(context).filterTitle,
                      style: getTextStyle().darkNavy.w700.s18,
                    ),
                  ],
                ),
                TextButton(
                  onPressed: _reset,
                  child: Text(
                    S.of(context).resetFilters,
                    style: getTextStyle().greyColor.w600.s14,
                  ),
                ),
              ],
            ),

            16.szH,

            // 1. Top Countries Filter
            _buildSectionTitle(S.of(context).topCountriesTitle),
            8.szH,
            _buildCountriesChips(),

            18.szH,

            // 2. Popular Professions Filter
            _buildSectionTitle(S.of(context).popularProfessionsTitle),
            8.szH,
            _buildProfessionsChips(),

            18.szH,

            // 3. Gender Filter
            _buildSectionTitle(S.of(context).genderLabel),
            8.szH,
            Row(
              children: [
                FilterOptionChip(
                  label: S.of(context).allOptions,
                  isExpanded: true,
                  isSelected: _selectedGender == null ||
                      _selectedGender == S.of(context).allOptions ||
                      _selectedGender == 'الكل',
                  onTap: () => setState(() => _selectedGender = null),
                ),
                10.szW,
                FilterOptionChip(
                  label: S.of(context).male,
                  isExpanded: true,
                  isSelected: _selectedGender == 'ذكر' || _selectedGender == 'male',
                  onTap: () => setState(() => _selectedGender = 'ذكر'),
                ),
                10.szW,
                FilterOptionChip(
                  label: S.of(context).female,
                  isExpanded: true,
                  isSelected: _selectedGender == 'أنثى' || _selectedGender == 'female',
                  onTap: () => setState(() => _selectedGender = 'أنثى'),
                ),
              ],
            ),

            18.szH,

            // 4. Passport Status Filter
            _buildSectionTitle(S.of(context).passportStatusLabel),
            8.szH,
            Row(
              children: [
                FilterOptionChip(
                  label: S.of(context).allOptions,
                  isExpanded: true,
                  isSelected: _selectedPassportStatus == null,
                  onTap: () => setState(() => _selectedPassportStatus = null),
                ),
                10.szW,
                FilterOptionChip(
                  label: S.of(context).validPassport,
                  isExpanded: true,
                  isSelected: _selectedPassportStatus == true,
                  onTap: () => setState(() => _selectedPassportStatus = true),
                ),
                10.szW,
                FilterOptionChip(
                  label: S.of(context).invalidPassport,
                  isExpanded: true,
                  isSelected: _selectedPassportStatus == false,
                  onTap: () => setState(() => _selectedPassportStatus = false),
                ),
              ],
            ),

            24.szH,

            // Apply Button
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: _apply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkNavy,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  S.of(context).applyFilters,
                  style: getTextStyle().whiteColor.w700.s16,
                ),
              ),
            ),
            12.szH,
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: getTextStyle().darkNavy.w700.s14,
    );
  }

  Widget _buildCountriesChips() {
    if (widget.isLoadingLookups && widget.topCountries.isEmpty) {
      return SizedBox(
        height: 36.h,
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    final isAllSelected = _selectedCountryId == null && _selectedCountryName == null;

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        FilterOptionChip(
          label: S.of(context).allOptions,
          isSelected: isAllSelected,
          onTap: () {
            setState(() {
              _selectedCountryId = null;
              _selectedCountryName = null;
            });
          },
        ),
        ...widget.topCountries.map((country) {
          final isSelected = _selectedCountryId == country.id ||
              _selectedCountryName == country.name;
          final displayText = country.flag != null && country.flag!.isNotEmpty
              ? '${country.flag} ${country.name}'
              : country.name;

          return FilterOptionChip(
            label: displayText,
            isSelected: isSelected,
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedCountryId = null;
                  _selectedCountryName = null;
                } else {
                  _selectedCountryId = country.id;
                  _selectedCountryName = country.name;
                }
              });
            },
          );
        }),
      ],
    );
  }

  Widget _buildProfessionsChips() {
    if (widget.isLoadingLookups && widget.popularProfessions.isEmpty) {
      return SizedBox(
        height: 36.h,
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    final isAllSelected = _selectedProfessionId == null && _selectedProfessionName == null;

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        FilterOptionChip(
          label: S.of(context).allOptions,
          isSelected: isAllSelected,
          onTap: () {
            setState(() {
              _selectedProfessionId = null;
              _selectedProfessionName = null;
            });
          },
        ),
        ...widget.popularProfessions.map((prof) {
          final isSelected = _selectedProfessionId == prof.id ||
              _selectedProfessionName == prof.name;

          return FilterOptionChip(
            label: prof.name,
            isSelected: isSelected,
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedProfessionId = null;
                  _selectedProfessionName = null;
                } else {
                  _selectedProfessionId = prof.id;
                  _selectedProfessionName = prof.name;
                }
              });
            },
          );
        }),
      ],
    );
  }
}
