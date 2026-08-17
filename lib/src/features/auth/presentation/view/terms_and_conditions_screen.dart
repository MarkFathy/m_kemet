import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/widgets/app_scaffold.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_back_button.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_button.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = [
      {
        'title': '1. الشروط العامة واستخدام التطبيق',
        'content':
            'تعتبر منصة كيميت وسيطاً تقنياً وتنظيمياً معتمداً لربط الكفاءات والباحثين عن عمل بأصحاب العمل والشركات الدولية. استخدامك للتطبيق يُعد موافقة صريحة على جميع الشروط واللوائح التنظيمية.',
      },
      {
        'title': '2. سياسة الخصوصية وحماية البيانات الشخصية',
        'content':
            'نلتزم بحفظ كافة المستندات الرسمية، الهويات، والسير الذاتية ومقاطع الفيديو التوضيحية وتشفيرها بأعلى معايير الأمان. لن يتم مشاركة هذه البيانات إلا مع الجهات وأصحاب العمل الموثقين فقط.',
      },
      {
        'title': '3. التزامات أصحاب العمل والشركات',
        'content':
            'تتعهد الشركات المسجلة بالجدية التامة في طلبات التواصل والاستقدام، والالتزام بالقوانين المنظمة للعمل في دولة الاستقدام وتوفير بيئة عمل آمنة ومناسبة.',
      },
      {
        'title': '4. حقوق المستخدم والتعديلات',
        'content':
            'يحق للمستخدم تعديل بياناته الشخصية، إيقاف التنبيهات، أو طلب حذف حسابه نهائياً عبر صفحة الإعدادات في أي وقت وفقاً لسياسات التطبيق التنظيمية.',
      },
    ];

    return AppScaffold(
      safeTop: true,
      safeBottom: true,
      backgroundColor: AppColors.pageBg,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.pW12,
          vertical: AppPadding.pH12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar
            Row(
              children: [
                const CustomBackButton(),
                12.szW,
                Expanded(
                  child: Text(
                    S.of(context).termsScreenTitle,
                    style: getTextStyle().darkNavy.w700.s18,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            16.szH,

            // Last updated pill
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.softBlueBg,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.update_rounded, size: 14.sp, color: AppColors.darkNavy),
                  6.szW,
                  Text(
                    S.of(context).termsLastUpdated,
                    style: getTextStyle().darkNavy.w600.s12,
                  ),
                ],
              ),
            ),

            16.szH,

            // Scrollable Content Cards List
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sections.length,
                      separatorBuilder: (context, index) => 12.szH,
                      itemBuilder: (context, index) {
                        final sec = sections[index];
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(color: AppColors.borderGrey),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 8.r,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sec['title']!,
                                style: getTextStyle().darkNavy.w700.s15,
                              ),
                              8.szH,
                              Text(
                                sec['content']!,
                                style: getTextStyle().greyColor.w400.s13.copyWith(height: 1.5),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    20.szH,
                  ],
                ),
              ),
            ),

            12.szH,

            // Accept & Continue Action Button
            CustomButton(
              text: S.of(context).acceptAndContinue,
              onPressed: () {
                Navigator.pop(context, true);
              },
              backgroundColor: AppColors.darkNavy,
              textStyle: getTextStyle().whiteColor.w700.s16,
            ),

            8.szH,
          ],
        ),
      ),
    );
  }
}
