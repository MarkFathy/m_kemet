import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/navigation/constants/imports_constants.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';
import 'package:m_kemet/src/core/services/service_locator/service_locator.dart';
import 'package:m_kemet/src/core/widgets/app_scaffold.dart';
import 'package:m_kemet/src/core/widgets/app_upgrade_alert.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_button.dart';
import 'package:m_kemet/src/core/widgets/buttons/language_switcher_button.dart';
import 'package:m_kemet/src/features/user_type_selection/domain/entities/user_type.dart';
import 'package:m_kemet/src/features/user_type_selection/presentation/cubit/user_type_cubit.dart';
import 'package:m_kemet/src/features/user_type_selection/presentation/cubit/user_type_state.dart';
import 'package:m_kemet/src/features/user_type_selection/presentation/widgets/user_type_option_card.dart';

class UserTypeSelectionScreen extends StatelessWidget {
  const UserTypeSelectionScreen({super.key});

  void _navigateToAuth(UserType? selectedType) {
    Go.offAllNamed(NamedRoutes.login, arguments: selectedType,transition: TransitionType.slide);
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

          return AppUpgradeAlert(
            child: AppScaffold(
            safeTop: true,
            safeBottom: true,
            backgroundColor: AppColors.pageBg,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.pW12,
                vertical: AppPadding.pH12,
              ),
              child: Column(
                children: [
                  const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: LanguageSwitcherButton(),
                  ),
                  40.szH,


                  Text(
                    S.of(context).userTypeSubtitle,
                    textAlign: TextAlign.center,
                    style: getTextStyle().steelBlue.w400.s16.copyWith(
                      height: 1.4,
                    ),
                  ),

                  16.szH,

                  // Card 1: Job Seeker
                  UserTypeOptionCard(
                    isSelected: state.selectedUserType == UserType.jobSeeker,
                    onTap: () => cubit.selectUserType(UserType.jobSeeker),
                    iconContainerColor: const Color(0xFFD0E8FF),
                    iconWidget: Icon(
                      Icons.person_search_rounded,
                      size: 24.sp,
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

                  12.szH,

                  // Card 2: Employer / Company
                  UserTypeOptionCard(
                    isSelected: state.selectedUserType == UserType.employer,
                    onTap: () => cubit.selectUserType(UserType.employer),
                    iconContainerColor: const Color(0xFFE2F3EC),
                    iconWidget: Icon(
                      Icons.business_rounded,
                      size: 24.sp,
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

                  20.szH,

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
                    textStyle: getTextStyle().whiteColor.w700.s16,
                  ),

                  12.szH,
                ],
              ),
            ),
            ),
          );
        },
      ),
    );
  }
}
