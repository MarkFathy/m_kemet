import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/app_cubit/app_cubit.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';
import 'package:m_kemet/src/core/services/service_locater/service_locator.dart';
import 'package:m_kemet/src/core/widgets/app_scaffold.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_button.dart';
import 'package:m_kemet/src/features/user_type_selection/domain/entities/user_type.dart';
import 'package:m_kemet/src/features/user_type_selection/presentation/cubit/user_type_cubit.dart';
import 'package:m_kemet/src/features/user_type_selection/presentation/cubit/user_type_state.dart';
import 'package:m_kemet/src/features/user_type_selection/presentation/widgets/user_type_option_card.dart';

class UserTypeSelectionScreen extends StatelessWidget {
  const UserTypeSelectionScreen({super.key});

  void _navigateToAuth(UserType? selectedType) {
    Go.offAllNamed(NamedRoutes.login, arguments: selectedType);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserTypeCubit>(
      create: (context) => sl<UserTypeCubit>(),
      child: BlocConsumer<UserTypeCubit, UserTypeState>(
        listener: (context, state) {
          if (state.isSaved) {
            _navigateToAuth(state.selectedUserType);
          }
        },
        builder: (context, state) {
          final cubit = context.read<UserTypeCubit>();

          return AppScaffold(
            safeTop: true,
            safeBottom: true,
            backgroundColor: const Color(0xFFF7F9FC),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.pW20,
                vertical: AppPadding.pH12,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: InkWell(
                      onTap: () {
                        context.read<AppCubit>().toggleLanguage();
                      },
                      borderRadius: BorderRadius.circular(8.r),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              context.watch<AppCubit>().state.locale.languageCode == 'ar' ? 'EN' : 'عربي',
                              style: getTextStyle().darkNavy.bold.s16,
                            ),
                            4.szW,
                            Icon(Icons.language_rounded, size: 24.sp, color: AppColors.darkNavy),
                          ],
                        ),
                      ),
                    ),
                  ),

                  4.szH,

                  // Header Titles
                  Text(
                    S.of(context).userTypeTitle,
                    textAlign: TextAlign.center,
                    style: getTextStyle().darkNavy.w700.s24,
                  ),

                  8.szH,

                  Text(
                    S.of(context).userTypeSubtitle,
                    textAlign: TextAlign.center,
                    style: getTextStyle().greyColor.w400.s14.copyWith(
                      height: 1.5,
                    ),
                  ),

                  24.szH,

                  // Card 1: Job Seeker
                  UserTypeOptionCard(
                    isSelected: state.selectedUserType == UserType.jobSeeker,
                    onTap: () => cubit.selectUserType(UserType.jobSeeker),
                    iconContainerColor: const Color(0xFFD0E8FF),
                    iconWidget: Icon(
                      Icons.person_search_rounded,
                      size: 32.sp,
                      color: AppColors.darkNavy,
                    ),
                    title: S.of(context).jobSeekerTitle,
                    description: S.of(context).jobSeekerDesc,
                    features: [
                      S.of(context).jobSeekerFeature1,
                      S.of(context).jobSeekerFeature2,
                    ],
                    featureIcons: const [
                      Icons.search_rounded,
                      Icons.assignment_ind_rounded,
                    ],
                  ),

                  16.szH,

                  // Card 2: Employer / Company
                  UserTypeOptionCard(
                    isSelected: state.selectedUserType == UserType.employer,
                    onTap: () => cubit.selectUserType(UserType.employer),
                    iconContainerColor: const Color(0xFFE2F3EC),
                    iconWidget: Icon(
                      Icons.business_rounded,
                      size: 32.sp,
                      color: const Color(0xFF0F7D59),
                    ),
                    title: S.of(context).employerTitle,
                    description: S.of(context).employerDesc,
                    features: [
                      S.of(context).employerFeature1,
                      S.of(context).employerFeature2,
                    ],
                    featureIcons: const [
                      Icons.post_add_rounded,
                      Icons.groups_rounded,
                    ],
                  ),

                  32.szH,

                  // Bottom Action Button ("المتابعة")
                  CustomButton(
                    text: S.of(context).continueAction,
                    onPressed: state.selectedUserType == null
                        ? null
                        : () {
                            cubit.confirmSelection();
                          },
                    backgroundColor: state.selectedUserType == null
                        ? AppColors.lightGrey
                        : AppColors.darkNavy,
                    textStyle: getTextStyle().whiteColor.w700.s18,
                  ),

                  16.szH,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
