import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';

class JobSeekerHeroCard extends StatelessWidget {
  final String name;
  final String? avatar;

  const JobSeekerHeroCard({
    super.key,
    required this.name,
    this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.borderGrey),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 34.r,
            backgroundColor: AppColors.softBlueBg,
            backgroundImage: avatar != null && avatar!.isNotEmpty
                ? NetworkImage(avatar!)
                : null,
            child: (avatar == null || avatar!.isEmpty)
                ? Icon(Icons.person_rounded, color: AppColors.darkNavy, size: 36.sp)
                : null,
          ),
          14.szW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isNotEmpty ? name : '—',
                  style: getTextStyle().darkNavy.w700.s16,
                  overflow: TextOverflow.ellipsis,
                ),
                6.szH,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.softBlueBg,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    'مرشح / باحث عن عمل',
                    style: getTextStyle().darkNavy.w700.s11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
