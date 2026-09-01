import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/widgets/app_progress_indicator.dart';
import 'package:m_kemet/src/features/auth/domain/entities/gender_entity.dart';

class GenderSelectionBottomSheet extends StatelessWidget {
  final List<GenderEntity> genders;
  final bool isLoading;
  final int? selectedGenderId;
  final ValueChanged<GenderEntity> onSelect;

  const GenderSelectionBottomSheet({
    super.key,
    required this.genders,
    required this.isLoading,
    this.selectedGenderId,
    required this.onSelect,
  });

  static Future<void> show(
    BuildContext context, {
    required List<GenderEntity> genders,
    required bool isLoading,
    int? selectedGenderId,
    required ValueChanged<GenderEntity> onSelect,
  }) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => GenderSelectionBottomSheet(
        genders: genders,
        isLoading: isLoading,
        selectedGenderId: selectedGenderId,
        onSelect: onSelect,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          16.szH,
          Text(
            S.of(context).genderLabel,
            style: getTextStyle().darkNavy.w700.s18,
          ),
          20.szH,
          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: AppProgressIndicator.centered(),
            )
          else
            Row(
              children: [
                for (int i = 0; i < genders.length; i++) ...[
                  Expanded(
                    child: Builder(
                      builder: (ctx) {
                        final gender = genders[i];
                        final isMale = gender.name.contains('ذكر') || gender.id == 1;
                        final isSelected = selectedGenderId == gender.id;
                        final activeColor = isMale ? AppColors.darkNavy : const Color(0xFFDB2777);
                        final activeBg = isMale ? const Color(0xFFD0E8FF) : const Color(0xFFFCE7F3);

                        return InkWell(
                          onTap: () {
                            onSelect(gender);
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(14.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            decoration: BoxDecoration(
                              color: isSelected ? activeBg : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: isSelected ? activeColor : const Color(0xFFE2E8F0),
                                width: 1.5.w,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isMale ? Icons.male_rounded : Icons.female_rounded,
                                  size: 32.sp,
                                  color: activeColor,
                                ),
                                6.szH,
                                Text(
                                  gender.name,
                                  style: getTextStyle().w700.s16.copyWith(
                                    color: activeColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (i < genders.length - 1) SizedBox(width: 16.w),
                ],
              ],
            ),
          20.szH,
        ],
      ),
    );
  }
}
