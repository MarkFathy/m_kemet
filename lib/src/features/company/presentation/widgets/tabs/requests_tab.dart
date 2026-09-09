import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/widgets/empty_state.dart';

class RequestsTab extends StatelessWidget {
  const RequestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Dynamic requests list (starts empty until real recruitment requests are dispatched)
    final List<Map<String, dynamic>> requests = [];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.pW12,
        vertical: AppPadding.pH12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).requestsTitle,
            style: getTextStyle().darkNavy.w700.s24,
          ),
          16.szH,
          if (requests.isEmpty)
            Padding(
              padding: EdgeInsets.only(top: 40.h),
              child: EmptyState(
                icon: Icons.assignment_outlined,
                title: S.of(context).noRequestsTitle,
                subtitle: S.of(context).noRequestsSub,
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: requests.length,
              separatorBuilder: (context, index) => 12.szH,
              itemBuilder: (context, index) {
                final req = requests[index];
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(req['ref'] as String? ?? '', style: getTextStyle().greyColor.w600.s12),
                          if (req['status'] != null)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: (req['statusBg'] as Color?) ?? AppColors.softBlueBg,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                req['status'] as String,
                                style: getTextStyle().w700.s11.copyWith(
                                      color: (req['statusColor'] as Color?) ?? AppColors.darkNavy,
                                    ),
                              ),
                            ),
                        ],
                      ),
                      8.szH,
                      Text(req['candidateName'] as String? ?? '', style: getTextStyle().darkNavy.w700.s16),
                      4.szH,
                      Text(req['profession'] as String? ?? '', style: getTextStyle().steelBlue.w500.s13),
                      12.szH,
                      Text(req['date'] as String? ?? '', style: getTextStyle().greyColor.w400.s12),
                    ],
                  ),
                );
              },
            ),
          100.szH,
        ],
      ),
    );
  }
}
