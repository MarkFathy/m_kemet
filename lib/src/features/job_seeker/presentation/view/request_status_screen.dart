import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/widgets/app_scaffold.dart';
import 'package:m_kemet/src/core/widgets/custom_snack_bar.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/request_status/approved_status_card.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/request_status/pending_status_card.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/request_status/rejected_status_card.dart';

enum RequestApprovalStatus { pending, approved, rejected }

class RequestStatusScreen extends StatefulWidget {
  final RequestApprovalStatus initialStatus;
  final bool showTestTabs;

  const RequestStatusScreen({
    super.key,
    this.initialStatus = RequestApprovalStatus.pending,
    this.showTestTabs = false,
  });

  @override
  State<RequestStatusScreen> createState() => _RequestStatusScreenState();
}

class _RequestStatusScreenState extends State<RequestStatusScreen> {
  late RequestApprovalStatus _currentStatus;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.initialStatus;
  }

  void _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });
      CustomSnackBar.showSuccess(
        context,
        message: _currentStatus == RequestApprovalStatus.pending
            ? S.of(context).statusPending
            : _currentStatus == RequestApprovalStatus.approved
                ? S.of(context).statusApproved
                : S.of(context).statusRejected,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Screen Main Title
            Text(
              S.of(context).requestStatusScreenTitle,
              style: getTextStyle().darkNavy.w700.s22,
            ),

            14.szH,

            // Interactive Status Selector Tabs for testing
            if (widget.showTestTabs) ...[
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppColors.borderGrey,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatusTab(
                        status: RequestApprovalStatus.pending,
                        title: S.of(context).statusPending,
                        icon: Icons.hourglass_top_rounded,
                        activeColor: AppColors.warningAmber,
                        activeBgColor: AppColors.warningBg,
                      ),
                    ),
                    Expanded(
                      child: _buildStatusTab(
                        status: RequestApprovalStatus.approved,
                        title: S.of(context).statusApproved,
                        icon: Icons.check_circle_rounded,
                        activeColor: AppColors.successGreen,
                        activeBgColor: AppColors.successBg,
                      ),
                    ),
                    Expanded(
                      child: _buildStatusTab(
                        status: RequestApprovalStatus.rejected,
                        title: S.of(context).statusRejected,
                        icon: Icons.cancel_rounded,
                        activeColor: AppColors.errorRed,
                        activeBgColor: AppColors.errorBg,
                      ),
                    ),
                  ],
                ),
              ),
              20.szH,
            ],

            // Animated Dynamic Status Content Body
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildStatusCardContent(context),
            ),

            20.szH,
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTab({
    required RequestApprovalStatus status,
    required String title,
    required IconData icon,
    required Color activeColor,
    required Color activeBgColor,
  }) {
    final isSelected = _currentStatus == status;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentStatus = status;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.whiteColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 6.r,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: isSelected ? activeColor : AppColors.greyColor,
            ),
            6.szW,
            Text(
              title,
              style: isSelected
                  ? getTextStyle().darkNavy.w700.s13.copyWith(color: activeColor)
                  : getTextStyle().greyColor.w500.s13,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCardContent(BuildContext context) {
    switch (_currentStatus) {
      case RequestApprovalStatus.pending:
        return PendingStatusCard(
          key: const ValueKey('pending_view'),
          isRefreshing: _isRefreshing,
          onRefresh: _onRefresh,
        );
      case RequestApprovalStatus.approved:
        return const ApprovedStatusCard(
          key: ValueKey('approved_view'),
        );
      case RequestApprovalStatus.rejected:
        return const RejectedStatusCard(
          key: ValueKey('rejected_view'),
        );
    }
  }
}
