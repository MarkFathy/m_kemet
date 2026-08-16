import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';
import 'package:m_kemet/src/core/services/service_locater/service_locator.dart';
import 'package:m_kemet/src/core/widgets/app_scaffold.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_button.dart';
import 'package:m_kemet/src/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:m_kemet/src/features/onboarding/presentation/cubit/onboarding_state.dart';
import 'package:m_kemet/src/features/onboarding/presentation/widgets/onboarding_dots_indicator.dart';
import 'package:m_kemet/src/features/onboarding/presentation/widgets/onboarding_page_item.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToNextScreen() {
    Go.offAllNamed(NamedRoutes.userTypeSelection);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardingCubit>(
      create: (context) => sl<OnboardingCubit>()..loadOnboardingData(),
      child: BlocConsumer<OnboardingCubit, OnboardingState>(
        listener: (context, state) {
          if (state.isCompleted) {
            _navigateToNextScreen();
          }
        },
        builder: (context, state) {
          final cubit = context.read<OnboardingCubit>();

          if (state.pages.isEmpty) {
            return const AppScaffold(
              safeTop: true,
              safeBottom: true,
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return AppScaffold(
            safeTop: true,
            safeBottom: true,
            backgroundColor: AppColors.scaffoldBackgroundColor,
            body: Column(
              children: [
                // Top Bar with "Skip" button on Page 1 & Page 2
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppPadding.pW20,
                    vertical: AppPadding.pH12,
                  ),
                  child: SizedBox(
                    height: 40.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (!state.isLastPage)
                          TextButton(
                            onPressed: () {
                              cubit.finishOnboarding();
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.darkNavy,
                            ),
                            child: Text(
                              S.of(context).skip,
                              style: getTextStyle().darkNavy.w600.s16,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // PageView Body
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: state.pages.length,
                    onPageChanged: cubit.onPageChanged,
                    itemBuilder: (context, index) {
                      return OnboardingPageItem(item: state.pages[index]);
                    },
                  ),
                ),

                // Bottom Section: Dots Indicator & Action Button
                Padding(
                  padding: EdgeInsets.only(
                    left: AppPadding.pW24,
                    right: AppPadding.pW24,
                    bottom: AppPadding.pH32,
                    top: AppPadding.pH16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Dots Indicator
                      OnboardingDotsIndicator(
                        controller: _pageController,
                        count: state.pages.length,
                      ),

                      32.szH,

                      // Action Button ("Next" or "Get Started")
                      if (state.isLastPage)
                        CustomButton(
                          text: S.of(context).getStarted,
                          onPressed: () {
                            cubit.finishOnboarding();
                          },
                          textStyle: getTextStyle().whiteColor.w700.s18,
                          backgroundColor: AppColors.darkNavy,
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            48.szW,
                            InkWell(
                              onTap: () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              },
                              borderRadius: BorderRadius.circular(28.r),
                              child: Container(
                                width: 56.w,
                                height: 56.h,
                                decoration: const BoxDecoration(
                                  color: AppColors.darkNavy,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
