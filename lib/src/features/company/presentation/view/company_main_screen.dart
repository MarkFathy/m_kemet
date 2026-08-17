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
import 'package:m_kemet/src/core/widgets/buttons/language_switcher_button.dart';
import 'package:m_kemet/src/core/widgets/custom_snack_bar.dart';
import 'package:m_kemet/src/core/widgets/floating_bottom_nav_bar.dart';
import 'package:m_kemet/src/core/widgets/text_fields/default_text_field.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';
import 'package:m_kemet/src/features/company/presentation/cubit/candidate_search_cubit.dart';
import 'package:m_kemet/src/features/company/presentation/cubit/candidate_search_state.dart';
import 'package:m_kemet/src/features/company/presentation/widgets/candidate_card.dart';
import 'package:m_kemet/src/features/company/presentation/widgets/candidate_filter_bottom_sheet.dart';

class CompanyMainScreen extends StatefulWidget {
  const CompanyMainScreen({super.key});

  @override
  State<CompanyMainScreen> createState() => _CompanyMainScreenState();
}

class _CompanyMainScreenState extends State<CompanyMainScreen> {
  int _currentIndex = 0;
  bool _notificationsEnabled = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onViewCandidateProfile(CandidateEntity candidate) {
    Go.toNamed(NamedRoutes.candidateDetail, arguments: candidate);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CandidateSearchCubit>(
      create: (context) => sl<CandidateSearchCubit>()..fetchCandidates(),
      child: AppScaffold(
        safeTop: true,
        safeBottom: true,
        backgroundColor: AppColors.pageBg,
        body: IndexedStack(
          index: _currentIndex,
          children: [
            _buildCandidateSearchTab(context),
            _buildRequestsTab(context),
            _buildCompanyProfileTab(context),
            _buildSettingsTab(context),
          ],
        ),
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  // TAB 1: Candidate Search Engine & Cards
  Widget _buildCandidateSearchTab(BuildContext context) {
    return Builder(
      builder: (context) {
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
                S.of(context).employerSearchTitle,
                style: getTextStyle().darkNavy.w700.s24,
              ),

              14.szH,

              // Search Bar & Filter Action Button Row
              Row(
                children: [
                  Expanded(
                    child: DefaultTextField(
                      controller: _searchController,
                      hint: S.of(context).searchCandidateHint,
                      prefixIcon: Icon(Icons.search_rounded, color: AppColors.greyColor, size: 20.sp),
                      onChanged: (val) {
                        context.read<CandidateSearchCubit>().updateSearchQuery(val ?? '');
                      },
                    ),
                  ),
                  10.szW,
                  InkWell(
                    onTap: () {
                      final cubit = context.read<CandidateSearchCubit>();
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: AppColors.transparentColor,
                        builder: (_) => CandidateFilterBottomSheet(
                          initialFilter: cubit.state.activeFilter,
                          onApplyFilter: (newFilter) {
                            cubit.applyFilter(newFilter);
                          },
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: AppColors.darkNavy,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        color: AppColors.whiteColor,
                        size: 22.sp,
                      ),
                    ),
                  ),
                ],
              ),

              20.szH,

              // Dynamic Search Results Candidates List
              BlocBuilder<CandidateSearchCubit, CandidateSearchState>(
                builder: (context, state) {
                  if (state.status == CandidateSearchStatus.loading) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: const Center(
                        child: CircularProgressIndicator(color: AppColors.darkNavy),
                      ),
                    );
                  }

                  if (state.candidates.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.search_off_rounded, size: 54.sp, color: AppColors.greyColor),
                            12.szH,
                            Text(
                              S.of(context).noSearchResultsTitle,
                              style: getTextStyle().darkNavy.w700.s16,
                            ),
                            6.szH,
                            Text(
                              S.of(context).noSearchResultsSub,
                              style: getTextStyle().greyColor.w400.s13,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.candidates.length,
                    separatorBuilder: (context, index) => 14.szH,
                    itemBuilder: (context, index) {
                      final candidate = state.candidates[index];
                      return CandidateCard(
                        candidate: candidate,
                        onViewProfile: () => _onViewCandidateProfile(candidate),
                        onToggleSave: () {
                          context.read<CandidateSearchCubit>().toggleSaveCandidate(candidate.id);
                        },
                      );
                    },
                  );
                },
              ),

              20.szH,
            ],
          ),
        );
      },
    );
  }

  // TAB 2: Recruitment & Contact Requests
  Widget _buildRequestsTab(BuildContext context) {
    final mockRequests = [
      {
        'candidateName': 'سارة خالد البقمي',
        'profession': 'ممرضة رعاية مركزة',
        'date': '17 أغسطس 2026',
        'ref': '#REQ-8041',
        'status': S.of(context).statusApproved,
        'statusColor': AppColors.successGreen,
        'statusBg': AppColors.successBg,
        'canConnect': true,
      },
      {
        'candidateName': 'أحمد محمود حسن',
        'profession': 'سائق شاحنة نقل ثقيل',
        'date': '16 أغسطس 2026',
        'ref': '#REQ-8038',
        'status': S.of(context).statusPending,
        'statusColor': AppColors.warningAmber,
        'statusBg': AppColors.warningBg,
        'canConnect': false,
      },
      {
        'candidateName': 'خالد يوسف العمراني',
        'profession': 'فني كهرباء ومقاولات',
        'date': '12 أغسطس 2026',
        'ref': '#REQ-7910',
        'status': S.of(context).statusCompleted,
        'statusColor': AppColors.darkNavy,
        'statusBg': AppColors.softBlueBg,
        'canConnect': true,
      },
    ];

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
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mockRequests.length,
            separatorBuilder: (context, index) => 12.szH,
            itemBuilder: (context, index) {
              final req = mockRequests[index];
              final canConnect = req['canConnect'] as bool;

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
                        Text(
                          req['ref'] as String,
                          style: getTextStyle().greyColor.w600.s12,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: req['statusBg'] as Color,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            req['status'] as String,
                            style: getTextStyle().w700.s11.copyWith(
                                  color: req['statusColor'] as Color,
                                ),
                          ),
                        ),
                      ],
                    ),
                    8.szH,
                    Text(
                      req['candidateName'] as String,
                      style: getTextStyle().darkNavy.w700.s16,
                    ),
                    4.szH,
                    Text(
                      req['profession'] as String,
                      style: getTextStyle().steelBlue.w500.s13,
                    ),
                    12.szH,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          req['date'] as String,
                          style: getTextStyle().greyColor.w400.s12,
                        ),
                        if (canConnect)
                          ElevatedButton.icon(
                            onPressed: () {
                              CustomSnackBar.showSuccess(
                                context,
                                message: 'فتح قنوات التواصل والربط المباشر مع المرشح...',
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.darkNavy,
                              foregroundColor: AppColors.whiteColor,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            icon: Icon(Icons.chat_bubble_outline_rounded, size: 14.sp),
                            label: Text(
                              'بدء التواصل',
                              style: getTextStyle().whiteColor.w700.s12,
                            ),
                          ),
                      ],
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
  }

  // TAB 3: Company Profile
  Widget _buildCompanyProfileTab(BuildContext context) {
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
            S.of(context).employerProfileTitle,
            style: getTextStyle().darkNavy.w700.s24,
          ),
          20.szH,
          Container(
            padding: EdgeInsets.all(16.w),
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
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30.r,
                  backgroundColor: AppColors.steelBlue,
                  child: Icon(Icons.business_rounded, color: AppColors.whiteColor, size: 28.sp),
                ),
                14.szW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.of(context).companyProfileHeader, style: getTextStyle().darkNavy.w700.s16),
                      4.szH,
                      Text(S.of(context).companyProfileSub, style: getTextStyle().greyColor.w500.s13),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 4: Settings
  Widget _buildSettingsTab(BuildContext context) {
    return Builder(
      builder: (context) {
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
                S.of(context).navSettings,
                style: getTextStyle().darkNavy.w700.s24,
              ),

              20.szH,

              // 1. Notification Toggle Control Card
              Container(
                padding: EdgeInsets.all(16.w),
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
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: AppColors.softBlueBg,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.notifications_active_outlined,
                        color: AppColors.darkNavy,
                        size: 24.sp,
                      ),
                    ),
                    12.szW,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).notificationsToggleTitle,
                            style: getTextStyle().darkNavy.w700.s15,
                          ),
                          4.szH,
                          Text(
                            S.of(context).notificationsToggleSub,
                            style: getTextStyle().greyColor.w400.s12,
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _notificationsEnabled,
                      activeTrackColor: AppColors.switchActiveTrack,
                      activeThumbColor: AppColors.darkNavy,
                      inactiveTrackColor: AppColors.switchInactiveTrack,
                      inactiveThumbColor: AppColors.switchInactiveThumb,
                      onChanged: (val) {
                        setState(() {
                          _notificationsEnabled = val;
                        });
                        CustomSnackBar.showSuccess(
                          context,
                          message: val
                              ? S.of(context).notificationsEnabledMsg
                              : S.of(context).notificationsDisabledMsg,
                        );
                      },
                    ),
                  ],
                ),
              ),

              14.szH,

              // 2. Saved Candidates Tile Card
              _buildSettingActionTile(
                icon: Icons.bookmark_border_rounded,
                iconBgColor: AppColors.warningBg,
                iconColor: AppColors.warningAmber,
                title: S.of(context).savedCandidatesTitle,
                subtitle: S.of(context).savedCandidatesSub,
                onTap: () => Go.toNamed(NamedRoutes.savedCandidates),
              ),

              14.szH,

              // 3. Notifications History Tile Card
              _buildSettingActionTile(
                icon: Icons.notifications_none_rounded,
                iconBgColor: AppColors.successBg,
                iconColor: AppColors.successGreen,
                title: S.of(context).notificationsHistoryTitle,
                subtitle: S.of(context).notificationsHistorySub,
                onTap: () => Go.toNamed(NamedRoutes.notificationsHistory),
              ),

              14.szH,

              // 4. Language Switcher Card
              Container(
                padding: EdgeInsets.all(16.w),
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
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: AppColors.chipBg,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.language_rounded,
                        color: AppColors.darkNavy,
                        size: 24.sp,
                      ),
                    ),
                    12.szW,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).appLanguageTitle,
                            style: getTextStyle().darkNavy.w700.s15,
                          ),
                          4.szH,
                          Text(
                            S.of(context).appLanguageSub,
                            style: getTextStyle().greyColor.w400.s12,
                          ),
                        ],
                      ),
                    ),
                    const LanguageSwitcherButton(),
                  ],
                ),
              ),

              14.szH,

              // 5. Logout Tile Card
              _buildSettingActionTile(
                icon: Icons.logout_rounded,
                iconBgColor: AppColors.softBlueBg,
                iconColor: AppColors.darkNavy,
                title: S.of(context).logout,
                subtitle: S.of(context).logoutSub,
                onTap: () => _showLogoutWarningSheet(context),
              ),

              14.szH,

              // 6. Delete Account Tile Card
              _buildSettingActionTile(
                icon: Icons.delete_outline_rounded,
                iconBgColor: AppColors.errorBg,
                iconColor: AppColors.errorRed,
                title: S.of(context).deleteAccount,
                subtitle: S.of(context).deleteAccountSub,
                onTap: () => _showDeleteAccountWarningSheet(context),
              ),

              20.szH,
            ],
          ),
        );
      },
    );
  }

  void _showLogoutWarningSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              16.szH,
              Container(
                padding: EdgeInsets.all(14.w),
                decoration: const BoxDecoration(
                  color: AppColors.softBlueBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.logout_rounded, color: AppColors.darkNavy, size: 32.sp),
              ),
              14.szH,
              Text(
                S.of(context).logoutConfirmTitle,
                style: getTextStyle().darkNavy.w700.s18,
              ),
              8.szH,
              Text(
                S.of(context).logoutConfirmMsg,
                textAlign: TextAlign.center,
                style: getTextStyle().greyColor.w400.s14.copyWith(height: 1.5),
              ),
              24.szH,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.borderGrey),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        S.of(context).cancel,
                        style: getTextStyle().darkNavy.w700.s14,
                      ),
                    ),
                  ),
                  12.szW,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Go.offAllNamed(NamedRoutes.userTypeSelection);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkNavy,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        S.of(context).logout,
                        style: getTextStyle().whiteColor.w700.s14,
                      ),
                    ),
                  ),
                ],
              ),
              10.szH,
            ],
          ),
        );
      },
    );
  }

  void _showDeleteAccountWarningSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              16.szH,
              Container(
                padding: EdgeInsets.all(14.w),
                decoration: const BoxDecoration(
                  color: AppColors.errorBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.warning_amber_rounded, color: AppColors.errorRed, size: 32.sp),
              ),
              14.szH,
              Text(
                S.of(context).deleteAccountConfirmTitle,
                style: getTextStyle().darkNavy.w700.s18,
              ),
              8.szH,
              Text(
                S.of(context).deleteAccountConfirmMsg,
                textAlign: TextAlign.center,
                style: getTextStyle().greyColor.w400.s13.copyWith(height: 1.5),
              ),
              24.szH,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.borderGrey),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        S.of(context).cancel,
                        style: getTextStyle().darkNavy.w700.s14,
                      ),
                    ),
                  ),
                  12.szW,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Go.offAllNamed(NamedRoutes.userTypeSelection);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.errorRed,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        S.of(context).confirmDeleteAction,
                        style: getTextStyle().whiteColor.w700.s13,
                      ),
                    ),
                  ),
                ],
              ),
              10.szH,
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingActionTile({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
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
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24.sp,
              ),
            ),
            12.szW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: getTextStyle().darkNavy.w700.s15,
                  ),
                  4.szH,
                  Text(
                    subtitle,
                    style: getTextStyle().greyColor.w400.s12,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.sp,
              color: AppColors.greyColor,
            ),
          ],
        ),
      ),
    );
  }

  // Floating Bottom Navigation Bar
  Widget _buildBottomNavBar() {
    return FloatingBottomNavBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: [
        FloatingNavItem(
          icon: Icons.person_search_outlined,
          activeIcon: Icons.person_search_rounded,
          label: S.of(context).navSearchCandidates,
        ),
        FloatingNavItem(
          icon: Icons.assignment_outlined,
          activeIcon: Icons.assignment_rounded,
          label: S.of(context).navRequests,
        ),
        FloatingNavItem(
          icon: Icons.business_outlined,
          activeIcon: Icons.business_rounded,
          label: S.of(context).navProfile,
        ),
        FloatingNavItem(
          icon: Icons.settings_outlined,
          activeIcon: Icons.settings_rounded,
          label: S.of(context).navSettings,
        ),
      ],
    );
  }
}
