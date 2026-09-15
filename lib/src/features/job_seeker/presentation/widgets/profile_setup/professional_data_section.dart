import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/widgets/text_fields/default_text_field.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/cubit/job_seeker_profile_cubit.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/cubit/job_seeker_profile_state.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/profile_setup/sheets/experience_level_selection_sheet.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/profile_setup/sheets/profession_selection_sheet.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/profile_setup/sheets/qualification_selection_sheet.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/profile_setup/sheets/single_selection_sheet.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/profile_setup/sheets/target_countries_selection_sheet.dart';

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
                  Icon(
                    Icons.work_outline_rounded,
                    color: AppColors.darkNavy,
                    size: 22.sp,
                  ),
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
                onTap: () => ProfessionSelectionSheet.show(
                  context,
                  professions: state.professions,
                  controller: professionController,
                ),
                prefixIcon: Icon(
                  Icons.engineering_outlined,
                  color: AppColors.greyColor,
                  size: 20.sp,
                ),
                suffixIcon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.darkNavy,
                  size: 24.sp,
                ),
              ),

              16.szH,

              // 2. Specialization
              DefaultTextField(
                controller: specializationController,
                label: S.of(context).specializationLabel,
                hint: S.of(context).specializationHint,
                prefixIcon: Icon(
                  Icons.category_outlined,
                  color: AppColors.greyColor,
                  size: 20.sp,
                ),
              ),

              16.szH,

              // 3. Experience Level / Years
              DefaultTextField(
                controller: experienceYearsController,
                label: S.of(context).experienceYearsLabel,
                hint: S.of(context).experienceYearsHint,
                readOnly: true,
                onTap: () => ExperienceLevelSelectionSheet.show(
                  context,
                  levels: state.experienceLevels,
                  controller: experienceYearsController,
                ),
                prefixIcon: Icon(
                  Icons.history_toggle_off_rounded,
                  color: AppColors.greyColor,
                  size: 20.sp,
                ),
                suffixIcon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.darkNavy,
                  size: 24.sp,
                ),
              ),

              16.szH,

              // 4. Qualification
              DefaultTextField(
                controller: qualificationController,
                label: S.of(context).qualificationLabel,
                hint: S.of(context).qualificationHint,
                readOnly: true,
                onTap: () => QualificationSelectionSheet.show(
                  context,
                  qualifications: state.qualifications,
                  controller: qualificationController,
                ),
                prefixIcon: Icon(
                  Icons.school_outlined,
                  color: AppColors.greyColor,
                  size: 20.sp,
                ),
                suffixIcon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.darkNavy,
                  size: 24.sp,
                ),
              ),

              16.szH,

              // 5. Languages
              DefaultTextField(
                controller: languagesController,
                label: S.of(context).languagesLabel,
                hint: S.of(context).languagesHint,
                prefixIcon: Icon(
                  Icons.translate_rounded,
                  color: AppColors.greyColor,
                  size: 20.sp,
                ),
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
                hint: S.of(context).skillsHint,
                prefixIcon: Icon(
                  Icons.star_outline_rounded,
                  color: AppColors.greyColor,
                  size: 20.sp,
                ),
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
                prefixIcon: Icon(
                  Icons.description_outlined,
                  color: AppColors.greyColor,
                  size: 20.sp,
                ),
              ),

              16.szH,

              // 8. Expected Salary
              DefaultTextField(
                controller: expectedSalaryController,
                label: S.of(context).expectedSalaryLabel,
                hint: S.of(context).expectedSalaryHint,
                readOnly: true,
                onTap: () => SingleSelectionSheet.show(
                  context,
                  title: S.of(context).expectedSalaryLabel,
                  options: _expectedSalaryOptions,
                  controller: expectedSalaryController,
                ),
                prefixIcon: Icon(
                  Icons.attach_money_rounded,
                  color: AppColors.greyColor,
                  size: 20.sp,
                ),
                suffixIcon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.darkNavy,
                  size: 24.sp,
                ),
              ),

              16.szH,

              // 9. Target Countries
              DefaultTextField(
                controller: targetCountriesController,
                label: S.of(context).targetCountriesLabel,
                hint: S.of(context).targetCountriesHint,
                readOnly: true,
                onTap: () => TargetCountriesSelectionSheet.show(
                  context,
                  countries: state.countries,
                  controller: targetCountriesController,
                ),
                prefixIcon: Icon(
                  Icons.travel_explore_rounded,
                  color: AppColors.greyColor,
                  size: 20.sp,
                ),
                suffixIcon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.darkNavy,
                  size: 24.sp,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
