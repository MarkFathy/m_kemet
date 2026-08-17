import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_filter_entity.dart';

class CandidateFilterBottomSheet extends StatefulWidget {
  final CandidateFilterEntity initialFilter;
  final ValueChanged<CandidateFilterEntity> onApplyFilter;

  const CandidateFilterBottomSheet({
    super.key,
    required this.initialFilter,
    required this.onApplyFilter,
  });

  @override
  State<CandidateFilterBottomSheet> createState() => _CandidateFilterBottomSheetState();
}

class _CandidateFilterBottomSheetState extends State<CandidateFilterBottomSheet> {
  late String? _selectedCountry;
  late String? _selectedProfession;
  late String? _selectedGender;
  late bool? _selectedPassportStatus;

  final List<String> _countries = ['الكل', 'مصر', 'السعودية', 'الإمارات', 'المغرب', 'تونس', 'قطر'];
  final List<String> _professions = ['الكل', 'سائق شاحنة نقل ثقيل', 'ممرضة رعاية مركزة', 'مهندس تنفيذ مدني', 'شيف طاهي شرقي وغربي', 'فني كهرباء ومقاولات'];

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.initialFilter.country;
    _selectedProfession = widget.initialFilter.profession;
    _selectedGender = widget.initialFilter.gender;
    _selectedPassportStatus = widget.initialFilter.isValidPassport;
  }

  void _reset() {
    setState(() {
      _selectedCountry = null;
      _selectedProfession = null;
      _selectedGender = null;
      _selectedPassportStatus = null;
    });
  }

  void _apply() {
    final updated = widget.initialFilter.copyWith(
      country: _selectedCountry,
      profession: _selectedProfession,
      gender: _selectedGender,
      isValidPassport: _selectedPassportStatus,
      resetCountry: _selectedCountry == null || _selectedCountry == 'الكل',
      resetProfession: _selectedProfession == null || _selectedProfession == 'الكل',
      resetGender: _selectedGender == null,
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
                Text(
                  S.of(context).filterTitle,
                  style: getTextStyle().darkNavy.w700.s18,
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

            // 1. Current Country Filter
            _buildSectionTitle(S.of(context).countryLabel),
            8.szH,
            _buildChipOptionGroup(
              options: _countries,
              selectedOption: _selectedCountry ?? 'الكل',
              onSelected: (val) {
                setState(() {
                  _selectedCountry = val == 'الكل' ? null : val;
                });
              },
            ),

            16.szH,

            // 2. Profession Filter
            _buildSectionTitle('المهنة'),
            8.szH,
            _buildChipOptionGroup(
              options: _professions,
              selectedOption: _selectedProfession ?? 'الكل',
              onSelected: (val) {
                setState(() {
                  _selectedProfession = val == 'الكل' ? null : val;
                });
              },
            ),

            16.szH,

            // 3. Gender Filter
            _buildSectionTitle(S.of(context).genderLabel),
            8.szH,
            Row(
              children: [
                _buildGenderChip('الكل', _selectedGender == null, () {
                  setState(() => _selectedGender = null);
                }),
                10.szW,
                _buildGenderChip('ذكر', _selectedGender == 'ذكر', () {
                  setState(() => _selectedGender = 'ذكر');
                }),
                10.szW,
                _buildGenderChip('أنثى', _selectedGender == 'أنثى', () {
                  setState(() => _selectedGender = 'أنثى');
                }),
              ],
            ),

            16.szH,

            // 4. Passport Status Filter
            _buildSectionTitle(S.of(context).passportStatusLabel),
            8.szH,
            Row(
              children: [
                _buildGenderChip('الكل', _selectedPassportStatus == null, () {
                  setState(() => _selectedPassportStatus = null);
                }),
                10.szW,
                _buildGenderChip(S.of(context).validPassport, _selectedPassportStatus == true, () {
                  setState(() => _selectedPassportStatus = true);
                }),
                10.szW,
                _buildGenderChip(S.of(context).invalidPassport, _selectedPassportStatus == false, () {
                  setState(() => _selectedPassportStatus = false);
                }),
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

  Widget _buildChipOptionGroup({
    required List<String> options,
    required String selectedOption,
    required ValueChanged<String> onSelected,
  }) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: options.map((option) {
        final isSelected = selectedOption == option;
        return InkWell(
          onTap: () => onSelected(option),
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.darkNavy : AppColors.chipBg,
              borderRadius: BorderRadius.circular(20.r),
              border: isSelected ? null : Border.all(color: AppColors.borderGrey),
            ),
            child: Text(
              option,
              style: getTextStyle().s13.copyWith(
                    color: isSelected ? AppColors.whiteColor : AppColors.darkNavy,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGenderChip(String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.darkNavy : AppColors.chipBg,
            borderRadius: BorderRadius.circular(10.r),
            border: isSelected ? null : Border.all(color: AppColors.borderGrey),
          ),
          child: Text(
            label,
            style: getTextStyle().s13.copyWith(
                  color: isSelected ? AppColors.whiteColor : AppColors.darkNavy,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
          ),
        ),
      ),
    );
  }
}
