import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/experience_level_entity.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/cubit/job_seeker_profile_cubit.dart';

class ExperienceLevelSelectionSheet extends StatelessWidget {
  final List<ExperienceLevelEntity> levels;
  final TextEditingController controller;

  const ExperienceLevelSelectionSheet({
    super.key,
    required this.levels,
    required this.controller,
  });

  static Future<void> show(
    BuildContext context, {
    required List<ExperienceLevelEntity> levels,
    required TextEditingController controller,
  }) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: AppColors.whiteColor,
      builder: (modalCtx) => ExperienceLevelSelectionSheet(
        levels: levels,
        controller: controller,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<JobSeekerProfileCubit>();

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
            S.of(context).experienceYearsLabel,
            style: getTextStyle().darkNavy.w700.s18,
          ),
          16.szH,
          Flexible(
            child: levels.isEmpty
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    child: Center(
                      child: Text(
                        S.of(context).noExperienceLevelsAvailable,
                        style: getTextStyle().greyColor.w400.s14,
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: levels.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = levels[index];
                      final isSelected = controller.text == item.name;
                      return ListTile(
                        title: Text(
                          item.name,
                          style: isSelected
                              ? getTextStyle().darkNavy.w700.s15
                              : getTextStyle().darkNavy.w500.s15,
                        ),
                        trailing: isSelected
                            ? const Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.darkNavy,
                              )
                            : null,
                        onTap: () {
                          controller.text = item.name;
                          cubit.selectExperienceLevel(item);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
