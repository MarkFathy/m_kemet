import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';
import 'package:m_kemet/src/core/services/service_locator/service_locator.dart';
import 'package:m_kemet/src/core/widgets/app_scaffold.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_button.dart';
import 'package:m_kemet/src/features/job_seeker/domain/usecases/get_candidate_profile_usecase.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/request_status/approved_status_card.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/request_status/pending_status_card.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/request_status/rejected_status_card.dart';

enum RequestApprovalStatus { pending, approved, rejected }

class RequestStatusScreen extends StatefulWidget {
  final RequestApprovalStatus initialStatus;

  const RequestStatusScreen({
    super.key,
    this.initialStatus = RequestApprovalStatus.pending,
  });

  @override
  State<RequestStatusScreen> createState() => _RequestStatusScreenState();
}

class _RequestStatusScreenState extends State<RequestStatusScreen> {
  late RequestApprovalStatus _currentStatus;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.initialStatus;
    _fetchProfileStatus();
  }

  Future<void> _fetchProfileStatus() async {
    setState(() {
      _isLoading = true;
    });

    final result = await sl<GetCandidateProfileUseCase>()();
    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
        });
      },
      (profile) {
        final backendStatus = profile.status?.toLowerCase().trim();
        setState(() {
          if (backendStatus == 'approved') {
            _currentStatus = RequestApprovalStatus.approved;
          } else if (backendStatus == 'rejected') {
            _currentStatus = RequestApprovalStatus.rejected;
          } else {
            _currentStatus = RequestApprovalStatus.pending;
          }
          _isLoading = false;
        });
      },
    );
  }

  Future<void> _onRefresh() async {
    await _fetchProfileStatus();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      safeTop: true,
      safeBottom: true,
      backgroundColor: AppColors.pageBg,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.darkNavy,
        backgroundColor: AppColors.whiteColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.pW12,
            vertical: AppPadding.pH12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Screen Title (no back button - this is a terminal screen after submission)
              Text(
                S.of(context).requestStatusScreenTitle,
                style: getTextStyle().darkNavy.w700.s20,
              ),

              20.szH,

              // Status Content Body
              if (_isLoading)
                Container(
                  height: 300.h,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                    color: AppColors.darkNavy,
                  ),
                )
              else
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildStatusCardContent(context),
                ),

              20.szH,

              // Home Action Button (الرئيسية)
              CustomButton(
                text: 'الرئيسية (صفحة البروفايل)',
                onPressed: () {
                  Go.offAllNamed(NamedRoutes.jobSeekerMain);
                },
                backgroundColor: AppColors.darkNavy,
                textStyle: getTextStyle().whiteColor.w700.s16,
              ),

              16.szH,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCardContent(BuildContext context) {
    switch (_currentStatus) {
      case RequestApprovalStatus.pending:
        return const PendingStatusCard(
          key: ValueKey('pending_view'),
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

