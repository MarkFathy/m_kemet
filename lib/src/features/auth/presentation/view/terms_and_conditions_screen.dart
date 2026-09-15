import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/services/service_locator/service_locator.dart';
import 'package:m_kemet/src/core/widgets/app_scaffold.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_back_button.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_button.dart';
import 'package:m_kemet/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:m_kemet/src/features/auth/presentation/cubit/auth_state.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => sl<AuthCubit>()..fetchTerms(),
      child: const _TermsAndConditionsView(),
    );
  }
}

class _TermsAndConditionsView extends StatelessWidget {
  const _TermsAndConditionsView();

  @override
  Widget build(BuildContext context) {
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

            // Dynamic API Content
            Expanded(
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state.termsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.darkNavy),
                    );
                  }

                  if (state.errorMessage != null && state.terms.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 48.sp,
                            color: AppColors.errorRed,
                          ),
                          12.szH,
                          Text(
                            state.errorMessage!,
                            style: getTextStyle().darkNavy.w600.s14,
                            textAlign: TextAlign.center,
                          ),
                          16.szH,
                          CustomButton(
                            text: S.of(context).retryAction,
                            onPressed: () => context.read<AuthCubit>().fetchTerms(),
                            backgroundColor: AppColors.darkNavy,
                          ),
                        ],
                      ),
                    );
                  }

                  final activeTerms = state.terms.where((t) => t.isActive).toList()
                    ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

                  if (activeTerms.isEmpty) {
                    return Center(
                      child: Text(
                        S.of(context).noRequestsTitle,
                        style: getTextStyle().greyColor.w500.s14,
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: activeTerms.length,
                          separatorBuilder: (context, index) => 12.szH,
                          itemBuilder: (context, index) {
                            final term = activeTerms[index];
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
                                    term.title,
                                    style: getTextStyle().darkNavy.w700.s15,
                                  ),
                                  8.szH,
                                  Text(
                                    term.desc,
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
                  );
                },
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
