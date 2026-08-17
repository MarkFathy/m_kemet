import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_button.dart';
import 'package:m_kemet/src/core/widgets/text_fields/default_text_field.dart';

class ProfessionalDataSection extends StatefulWidget {
  final TextEditingController professionController;
  final TextEditingController specializationController;
  final TextEditingController experienceYearsController;
  final TextEditingController qualificationController;
  final TextEditingController languagesController;
  final TextEditingController skillsController;
  final TextEditingController previousExperienceController;
  final TextEditingController expectedSalaryController;
  final TextEditingController travelPossibilityController;
  final TextEditingController targetCountriesController;

  const ProfessionalDataSection({
    super.key,
    required this.professionController,
    required this.specializationController,
    required this.experienceYearsController,
    required this.qualificationController,
    required this.languagesController,
    required this.skillsController,
    required this.previousExperienceController,
    required this.expectedSalaryController,
    required this.travelPossibilityController,
    required this.targetCountriesController,
  });

  @override
  State<ProfessionalDataSection> createState() => _ProfessionalDataSectionState();
}

class _ProfessionalDataSectionState extends State<ProfessionalDataSection> {
  final List<String> _professions = [
    'سائق (Driver)',
    'كهربائي (Electrician)',
    'طباخ / شيف (Cook / Chef)',
    'فني تكييف وتبريد (AC Technician)',
    'سباك (Plumber)',
    'نجار (Carpenter)',
    'مهندس مدني / معماري (Civil / Architect Engineer)',
    'ممرض / ممرضة (Nurse)',
    'محاسب (Accountant)',
    'موظف استقبال / فندقة (Receptionist / Hospitality)',
    'خياط (Tailor)',
    'بائع / مبيعات (Sales Executive)',
    'مهنة أخرى (Other)',
  ];

  final List<String> _experienceYearsOptions = [
    'أقل من سنة (Less than 1 year)',
    '1 - 3 سنوات (1 - 3 years)',
    '3 - 5 سنوات (3 - 5 years)',
    '5 - 10 سنوات (5 - 10 years)',
    'أكثر من 10 سنوات (10+ years)',
  ];

  final List<String> _qualificationOptions = [
    'ثانوية عامة / ما يعادلها (High School)',
    'دبلوم فني / متوسط (Diploma)',
    'بكالوريوس / ليسانس (Bachelor Degree)',
    'ماجستير / دكتوراه (Master / PhD)',
    'بدون مؤهل (No Degree)',
  ];

  final List<String> _expectedSalaryOptions = [
    '\$500 - \$1,000 / شهرياً',
    '\$1,000 - \$2,000 / شهرياً',
    '\$2,000 - \$3,500 / شهرياً',
    '\$3,500+ / شهرياً',
  ];

  final List<String> _travelPossibilityOptions = [
    'متاح فوراً للسفر (Available Immediately)',
    'متاح خلال شهر (Available within 1 month)',
    'غير متاح حالياً (Not Available)',
  ];

  final List<String> _allTargetCountries = [
    'المملكة العربية السعودية (Saudi Arabia)',
    'الإمارات العربية المتحدة (UAE)',
    'الكويت (Kuwait)',
    'قطر (Qatar)',
    'سلطنة عمان (Oman)',
    'البحرين (Bahrain)',
    'ألمانيا (Germany)',
    'إيطاليا (Italy)',
    'كندا (Canada)',
    'أي دولة متاحة (Any Country)',
  ];

  final Set<String> _selectedTargetCountries = {};

  void _showProfessionBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: AppColors.whiteColor,
      builder: (context) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filtered = _professions
                .where((item) => item.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  children: [
                    Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: AppColors.borderGrey,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    12.szH,
                    Text(
                      S.of(context).professionLabel,
                      style: getTextStyle().darkNavy.w700.s18,
                    ),
                    16.szH,
                    DefaultTextField(
                      hint: S.of(context).searchProfessionHint,
                      prefixIcon: Icon(Icons.search_rounded, color: AppColors.greyColor, size: 20.sp),
                      onChanged: (val) {
                        setModalState(() {
                          searchQuery = val ?? '';
                        });
                      },
                    ),
                    12.szH,
                    Expanded(
                      child: filtered.isEmpty
                          ? Center(
                              child: Text(
                                S.of(context).noCountryFound,
                                style: getTextStyle().greyColor.w400.s14,
                              ),
                            )
                          : ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemCount: filtered.length,
                              separatorBuilder: (context, index) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final item = filtered[index];
                                final isSelected = widget.professionController.text == item;
                                return ListTile(
                                  title: Text(
                                    item,
                                    style: isSelected
                                        ? getTextStyle().darkNavy.w700.s15
                                        : getTextStyle().darkNavy.w500.s15,
                                  ),
                                  trailing: isSelected
                                      ? const Icon(Icons.check_circle_rounded, color: AppColors.darkNavy)
                                      : null,
                                  onTap: () {
                                    setState(() {
                                      widget.professionController.text = item;
                                    });
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSingleSelectionBottomSheet({
    required String title,
    required List<String> options,
    required TextEditingController controller,
  }) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: AppColors.whiteColor,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.borderGrey,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              16.szH,
              Text(
                title,
                style: getTextStyle().darkNavy.w700.s18,
              ),
              16.szH,
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: options.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = options[index];
                    final isSelected = controller.text == item;
                    return ListTile(
                      title: Text(
                        item,
                        style: isSelected
                            ? getTextStyle().darkNavy.w700.s15
                            : getTextStyle().darkNavy.w500.s15,
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle_rounded, color: AppColors.darkNavy)
                          : null,
                      onTap: () {
                        setState(() {
                          controller.text = item;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTargetCountriesBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: AppColors.whiteColor,
      builder: (context) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filtered = _allTargetCountries
                .where((c) => c.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  children: [
                    Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: AppColors.borderGrey,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    12.szH,
                    Text(
                      S.of(context).targetCountriesLabel,
                      style: getTextStyle().darkNavy.w700.s18,
                    ),
                    16.szH,
                    DefaultTextField(
                      hint: S.of(context).searchCountryHint,
                      prefixIcon: Icon(Icons.search_rounded, color: AppColors.greyColor, size: 20.sp),
                      onChanged: (val) {
                        setModalState(() {
                          searchQuery = val ?? '';
                        });
                      },
                    ),
                    12.szH,
                    Expanded(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: filtered.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          final isChecked = _selectedTargetCountries.contains(item);
                          return CheckboxListTile(
                            activeColor: AppColors.darkNavy,
                            title: Text(
                              item,
                              style: isChecked
                                  ? getTextStyle().darkNavy.w700.s15
                                  : getTextStyle().darkNavy.w500.s15,
                            ),
                            value: isChecked,
                            onChanged: (checked) {
                              setModalState(() {
                                if (checked == true) {
                                  _selectedTargetCountries.add(item);
                                } else {
                                  _selectedTargetCountries.remove(item);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                    12.szH,
                    CustomButton(
                      text: S.of(context).continueAction,
                      onPressed: () {
                        setState(() {
                          widget.targetCountriesController.text = _selectedTargetCountries.join(', ');
                        });
                        Navigator.pop(context);
                      },
                      backgroundColor: AppColors.darkNavy,
                      textStyle: getTextStyle().whiteColor.w700.s16,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderGrey),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.work_outline_rounded, color: AppColors.darkNavy, size: 22.sp),
              8.szW,
              Text(
                S.of(context).professionalSectionTitle,
                style: getTextStyle().darkNavy.w700.s18,
              ),
            ],
          ),

          16.szH,

          // 1. Profession
          DefaultTextField(
            controller: widget.professionController,
            label: S.of(context).professionLabel,
            hint: S.of(context).professionHint,
            readOnly: true,
            onTap: _showProfessionBottomSheet,
            prefixIcon: Icon(Icons.engineering_outlined, color: AppColors.greyColor, size: 20.sp),
            suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.darkNavy, size: 24.sp),
          ),

          16.szH,

          // 2. Specialization
          DefaultTextField(
            controller: widget.specializationController,
            label: S.of(context).specializationLabel,
            hint: S.of(context).specializationHint,
            prefixIcon: Icon(Icons.category_outlined, color: AppColors.greyColor, size: 20.sp),
          ),

          16.szH,

          // 3. Experience Years
          DefaultTextField(
            controller: widget.experienceYearsController,
            label: S.of(context).experienceYearsLabel,
            hint: S.of(context).experienceYearsHint,
            readOnly: true,
            onTap: () => _showSingleSelectionBottomSheet(
              title: S.of(context).experienceYearsLabel,
              options: _experienceYearsOptions,
              controller: widget.experienceYearsController,
            ),
            prefixIcon: Icon(Icons.history_toggle_off_rounded, color: AppColors.greyColor, size: 20.sp),
            suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.darkNavy, size: 24.sp),
          ),

          16.szH,

          // 4. Qualification
          DefaultTextField(
            controller: widget.qualificationController,
            label: S.of(context).qualificationLabel,
            hint: S.of(context).qualificationHint,
            readOnly: true,
            onTap: () => _showSingleSelectionBottomSheet(
              title: S.of(context).qualificationLabel,
              options: _qualificationOptions,
              controller: widget.qualificationController,
            ),
            prefixIcon: Icon(Icons.school_outlined, color: AppColors.greyColor, size: 20.sp),
            suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.darkNavy, size: 24.sp),
          ),

          16.szH,

          // 5. Languages
          DefaultTextField(
            controller: widget.languagesController,
            label: S.of(context).languagesLabel,
            hint: S.of(context).languagesHint,
            prefixIcon: Icon(Icons.translate_rounded, color: AppColors.greyColor, size: 20.sp),
          ),

          16.szH,

          // 6. Skills
          DefaultTextField(
            controller: widget.skillsController,
            label: S.of(context).skillsLabel,
            hint: S.of(context).skillsHint,
            prefixIcon: Icon(Icons.star_outline_rounded, color: AppColors.greyColor, size: 20.sp),
          ),

          16.szH,

          // 7. Previous Experience
          DefaultTextField(
            controller: widget.previousExperienceController,
            label: S.of(context).previousExperienceLabel,
            hint: S.of(context).previousExperienceHint,
            inputType: TextInputType.multiline,
            maxLines: 3,
            prefixIcon: Icon(Icons.description_outlined, color: AppColors.greyColor, size: 20.sp),
          ),

          16.szH,

          // 8. Expected Salary
          DefaultTextField(
            controller: widget.expectedSalaryController,
            label: S.of(context).expectedSalaryLabel,
            hint: S.of(context).expectedSalaryHint,
            readOnly: true,
            onTap: () => _showSingleSelectionBottomSheet(
              title: S.of(context).expectedSalaryLabel,
              options: _expectedSalaryOptions,
              controller: widget.expectedSalaryController,
            ),
            prefixIcon: Icon(Icons.attach_money_rounded, color: AppColors.greyColor, size: 20.sp),
            suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.darkNavy, size: 24.sp),
          ),

          16.szH,

          // 9. Willingness to Travel
          DefaultTextField(
            controller: widget.travelPossibilityController,
            label: S.of(context).travelPossibilityLabel,
            hint: S.of(context).travelPossibilityHint,
            readOnly: true,
            onTap: () => _showSingleSelectionBottomSheet(
              title: S.of(context).travelPossibilityLabel,
              options: _travelPossibilityOptions,
              controller: widget.travelPossibilityController,
            ),
            prefixIcon: Icon(Icons.flight_takeoff_rounded, color: AppColors.greyColor, size: 20.sp),
            suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.darkNavy, size: 24.sp),
          ),

          16.szH,

          // 10. Target Countries
          DefaultTextField(
            controller: widget.targetCountriesController,
            label: S.of(context).targetCountriesLabel,
            hint: S.of(context).targetCountriesHint,
            readOnly: true,
            onTap: _showTargetCountriesBottomSheet,
            prefixIcon: Icon(Icons.travel_explore_rounded, color: AppColors.greyColor, size: 20.sp),
            suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.darkNavy, size: 24.sp),
          ),
        ],
      ),
    );
  }
}
