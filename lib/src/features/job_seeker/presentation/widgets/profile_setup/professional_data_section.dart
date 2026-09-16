import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_button.dart';
import 'package:m_kemet/src/core/widgets/text_fields/default_text_field.dart';
import 'package:m_kemet/src/features/auth/domain/entities/country_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/experience_level_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/profession_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/qualification_entity.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/cubit/job_seeker_profile_cubit.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/cubit/job_seeker_profile_state.dart';

class ProfessionalDataSection extends StatelessWidget {
  final TextEditingController professionController;
  final TextEditingController specializationController;
  final TextEditingController experienceYearsController;
  final TextEditingController qualificationController;
  final TextEditingController languagesController;
  final TextEditingController skillsController;
  final TextEditingController previousExperienceController;
  final TextEditingController expectedSalaryController;
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
    required this.targetCountriesController,
  });

  static const List<String> _expectedSalaryOptions = [
    '1000 - 2000',
    '2000 - 4000',
    '4000 - 7000',
    '7000 - 12000',
    '12000+',
  ];

  void _showProfessionBottomSheet(BuildContext context, List<ProfessionEntity> professions) {
    final cubit = context.read<JobSeekerProfileCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: AppColors.whiteColor,
      builder: (modalCtx) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (builderCtx, setModalState) {
            final filtered = professions
                .where((item) => item.name.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(modalCtx).viewInsets.bottom,
              ),
              child: Container(
                height: MediaQuery.of(modalCtx).size.height * 0.7,
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
                      S.of(modalCtx).professionLabel,
                      style: getTextStyle().darkNavy.w700.s18,
                    ),
                    16.szH,
                    DefaultTextField(
                      hint: S.of(modalCtx).searchProfessionHint,
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
                                S.of(modalCtx).noCountryFound,
                                style: getTextStyle().greyColor.w400.s14,
                              ),
                            )
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final item = filtered[index];
                                final isSelected = professionController.text == item.name;
                                return ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                  title: Text(
                                    item.name,
                                    style: isSelected
                                        ? getTextStyle().darkNavy.w700.s15
                                        : getTextStyle().darkNavy.w500.s15,
                                  ),
                                  trailing: isSelected
                                      ? const Icon(Icons.check_circle_rounded, color: AppColors.darkNavy)
                                      : null,
                                  onTap: () {
                                    professionController.text = item.name;
                                    if (item.id != 0) {
                                      cubit.selectProfession(item);
                                    }
                                    Navigator.pop(modalCtx);
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

  void _showExperienceLevelBottomSheet(BuildContext context, List<ExperienceLevelEntity> levels) {
    final cubit = context.read<JobSeekerProfileCubit>();

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: AppColors.whiteColor,
      builder: (modalCtx) {
        final options = levels.isNotEmpty
            ? levels
            : [
                const ExperienceLevelEntity(id: 1, name: 'أقل من سنة (Less than 1 year)'),
                const ExperienceLevelEntity(id: 2, name: 'من سنة إلى 5 سنوات (1 - 5 years)'),
                const ExperienceLevelEntity(id: 3, name: 'من 5 إلى 8 سنوات (5 - 8 years)'),
                const ExperienceLevelEntity(id: 4, name: 'أكثر من 8 سنوات (8+ years)'),
              ];

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
                S.of(modalCtx).experienceYearsLabel,
                style: getTextStyle().darkNavy.w700.s18,
              ),
              16.szH,
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final item = options[index];
                    final isSelected = experienceYearsController.text == item.name;
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      title: Text(
                        item.name,
                        style: isSelected
                            ? getTextStyle().darkNavy.w700.s15
                            : getTextStyle().darkNavy.w500.s15,
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle_rounded, color: AppColors.darkNavy)
                          : null,
                      onTap: () {
                        experienceYearsController.text = item.name;
                        cubit.selectExperienceLevel(item);
                        Navigator.pop(modalCtx);
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

  void _showQualificationBottomSheet(BuildContext context, List<QualificationEntity> qualifications) {
    final cubit = context.read<JobSeekerProfileCubit>();

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: AppColors.whiteColor,
      builder: (modalCtx) {
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
                S.of(modalCtx).qualificationLabel,
                style: getTextStyle().darkNavy.w700.s18,
              ),
              16.szH,
              Flexible(
                child: qualifications.isEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        child: Center(
                          child: Text(
                            'لا توجد مؤهلات دراسية متاحة حالياً',
                            style: getTextStyle().greyColor.w400.s14,
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: qualifications.length,
                        itemBuilder: (context, index) {
                          final item = qualifications[index];
                          final isSelected = qualificationController.text == item.name;
                          return ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            title: Text(
                              item.name,
                              style: isSelected
                                  ? getTextStyle().darkNavy.w700.s15
                                  : getTextStyle().darkNavy.w500.s15,
                            ),
                            trailing: isSelected
                                ? const Icon(Icons.check_circle_rounded, color: AppColors.darkNavy)
                                : null,
                            onTap: () {
                              qualificationController.text = item.name;
                              cubit.selectQualification(item);
                              Navigator.pop(modalCtx);
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

  void _showSingleSelectionBottomSheet(
    BuildContext context, {
    required String title,
    required List<String> options,
    required TextEditingController controller,
    void Function(String selected)? onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: AppColors.whiteColor,
      builder: (modalCtx) {
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
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final item = options[index];
                    final isSelected = controller.text == item;
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
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
                        controller.text = item;
                        onSelected?.call(item);
                        Navigator.pop(modalCtx);
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

  void _showTargetCountriesBottomSheet(BuildContext context, List<CountryEntity> countries) {
    final cubit = context.read<JobSeekerProfileCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: AppColors.whiteColor,
      builder: (modalCtx) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (builderCtx, setModalState) {
            final selectedCountries = cubit.state.selectedTargetCountries;

            final filtered = countries
                .where((c) => c.name.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(modalCtx).viewInsets.bottom,
              ),
              child: Container(
                height: MediaQuery.of(modalCtx).size.height * 0.75,
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
                      S.of(modalCtx).targetCountriesLabel,
                      style: getTextStyle().darkNavy.w700.s18,
                    ),
                    16.szH,
                    DefaultTextField(
                      hint: S.of(modalCtx).searchCountryHint,
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
                                S.of(modalCtx).noCountryFound,
                                style: getTextStyle().greyColor.w400.s14,
                              ),
                            )
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final item = filtered[index];
                                final isChecked = selectedCountries.any((c) => c.id == item.id);
                                return CheckboxListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0),
                                  activeColor: AppColors.darkNavy,
                                  title: Row(
                                    children: [
                                      if (item.flag != null && item.flag!.isNotEmpty) ...[
                                        Text(item.flag!, style: TextStyle(fontSize: 18.sp)),
                                        8.szW,
                                      ],
                                      Expanded(
                                        child: Text(
                                          item.name,
                                          style: isChecked
                                              ? getTextStyle().darkNavy.w700.s15
                                              : getTextStyle().darkNavy.w500.s15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  value: isChecked,
                                  onChanged: (_) {
                                    cubit.toggleTargetCountry(item);
                                    setModalState(() {});
                                  },
                                );
                              },
                            ),
                    ),
                    12.szH,
                    CustomButton(
                      text: S.of(modalCtx).continueAction,
                      onPressed: () {
                        final updatedSelected = cubit.state.selectedTargetCountries;
                        targetCountriesController.text =
                            updatedSelected.map((c) => c.name).join(', ');
                        Navigator.pop(modalCtx);
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
    return BlocBuilder<JobSeekerProfileCubit, JobSeekerProfileState>(
      builder: (context, state) {
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
                controller: professionController,
                label: S.of(context).professionLabel,
                hint: S.of(context).professionHint,
                readOnly: true,
                onTap: () => _showProfessionBottomSheet(context, state.professions),
                prefixIcon: Icon(Icons.engineering_outlined, color: AppColors.greyColor, size: 20.sp),
                suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.darkNavy, size: 24.sp),
              ),

              16.szH,

              // 2. Specialization
              DefaultTextField(
                controller: specializationController,
                label: S.of(context).specializationLabel,
                hint: S.of(context).specializationHint,
                prefixIcon: Icon(Icons.category_outlined, color: AppColors.greyColor, size: 20.sp),
              ),

              16.szH,

              // 3. Experience Level / Years
              DefaultTextField(
                controller: experienceYearsController,
                label: S.of(context).experienceYearsLabel,
                hint: S.of(context).experienceYearsHint,
                readOnly: true,
                onTap: () => _showExperienceLevelBottomSheet(context, state.experienceLevels),
                prefixIcon: Icon(Icons.history_toggle_off_rounded, color: AppColors.greyColor, size: 20.sp),
                suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.darkNavy, size: 24.sp),
              ),

              16.szH,

              // 4. Qualification
              DefaultTextField(
                controller: qualificationController,
                label: S.of(context).qualificationLabel,
                hint: S.of(context).qualificationHint,
                readOnly: true,
                onTap: () => _showQualificationBottomSheet(context, state.qualifications),
                prefixIcon: Icon(Icons.school_outlined, color: AppColors.greyColor, size: 20.sp),
                suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.darkNavy, size: 24.sp),
              ),

              16.szH,

              // 5. Languages
              DefaultTextField(
                controller: languagesController,
                label: S.of(context).languagesLabel,
                hint: 'مثال: العربية، الإنجليزية',
                prefixIcon: Icon(Icons.translate_rounded, color: AppColors.greyColor, size: 20.sp),
                onChanged: (val) {
                  final cubit = context.read<JobSeekerProfileCubit>();
                  if (val == null || val.trim().isEmpty) {
                    cubit.setLanguages([]);
                  } else {
                    final langs = val
                        .split(RegExp(r'[,،\n]'))
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toSet()
                        .toList();
                    cubit.setLanguages(langs);
                  }
                },
              ),

              16.szH,

              // 6. Skills
              DefaultTextField(
                controller: skillsController,
                label: S.of(context).skillsLabel,
                hint: 'مثال: قيادة، كهرباء، صيانة',
                prefixIcon: Icon(Icons.star_outline_rounded, color: AppColors.greyColor, size: 20.sp),
                onChanged: (val) {
                  final cubit = context.read<JobSeekerProfileCubit>();
                  if (val == null || val.trim().isEmpty) {
                    cubit.setSkills([]);
                  } else {
                    final skills = val
                        .split(RegExp(r'[,،\n]'))
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toSet()
                        .toList();
                    cubit.setSkills(skills);
                  }
                },
              ),

              16.szH,

              // 7. Previous Experience / Summary
              DefaultTextField(
                controller: previousExperienceController,
                label: S.of(context).previousExperienceLabel,
                hint: S.of(context).previousExperienceHint,
                inputType: TextInputType.multiline,
                maxLines: 3,
                prefixIcon: Icon(Icons.description_outlined, color: AppColors.greyColor, size: 20.sp),
              ),

              16.szH,

              // 8. Expected Salary
              DefaultTextField(
                controller: expectedSalaryController,
                label: S.of(context).expectedSalaryLabel,
                hint: S.of(context).expectedSalaryHint,
                readOnly: true,
                onTap: () => _showSingleSelectionBottomSheet(
                  context,
                  title: S.of(context).expectedSalaryLabel,
                  options: _expectedSalaryOptions,
                  controller: expectedSalaryController,
                ),
                prefixIcon: Icon(Icons.attach_money_rounded, color: AppColors.greyColor, size: 20.sp),
                suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.darkNavy, size: 24.sp),
              ),

              16.szH,

              // Target Countries
              DefaultTextField(
                controller: targetCountriesController,
                label: S.of(context).targetCountriesLabel,
                hint: S.of(context).targetCountriesHint,
                readOnly: true,
                onTap: () => _showTargetCountriesBottomSheet(context, state.countries),
                prefixIcon: Icon(Icons.travel_explore_rounded, color: AppColors.greyColor, size: 20.sp),
                suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.darkNavy, size: 24.sp),
              ),
            ],
          ),
        );
      },
    );
  }
}
