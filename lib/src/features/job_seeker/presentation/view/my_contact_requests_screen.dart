import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/services/service_locator/service_locator.dart';
import 'package:m_kemet/src/core/widgets/app_progress_indicator.dart';
import 'package:m_kemet/src/core/widgets/app_scaffold.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_back_button.dart';
import 'package:m_kemet/src/core/widgets/network_error_widget.dart';
import 'package:m_kemet/src/features/job_seeker/data/models/contact_request_model.dart';
import 'package:m_kemet/src/features/job_seeker/domain/usecases/get_my_contact_requests_usecase.dart';

class MyContactRequestsScreen extends StatefulWidget {
  const MyContactRequestsScreen({super.key});

  @override
  State<MyContactRequestsScreen> createState() => _MyContactRequestsScreenState();
}

class _MyContactRequestsScreenState extends State<MyContactRequestsScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<ContactRequestModel> _requests = [];

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await sl<GetMyContactRequestsUseCase>()();
    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
          _errorMessage = failure.serverException.message;
        });
      },
      (data) {
        setState(() {
          _isLoading = false;
          _requests = data;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      safeTop: true,
      safeBottom: true,
      backgroundColor: AppColors.pageBg,
      body: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.pW12,
              vertical: AppPadding.pH12,
            ),
            child: Row(
              children: [
                const CustomBackButton(),
                12.szW,
                Expanded(
                  child: Text(
                    'طلبات التواصل من الشركات',
                    style: getTextStyle().darkNavy.w700.s20,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: AppProgressIndicator());
    }

    if (_errorMessage != null) {
      return NetworkErrorWidget(onRetry: _fetchRequests);
    }

    if (_requests.isEmpty) {
      return RefreshIndicator(
        onRefresh: _fetchRequests,
        color: AppColors.darkNavy,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: SizedBox(
            height: 400.h,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.mark_email_read_outlined,
                    size: 60.sp,
                    color: AppColors.greyColor.withValues(alpha: 0.5),
                  ),
                  16.szH,
                  Text(
                    'لا توجد طلبات تواصل حالياً',
                    style: getTextStyle().darkNavy.w700.s16,
                  ),
                  6.szH,
                  Text(
                    'عندما تطلب شركة التواصل معك ستظهر طلباتهم هنا',
                    style: getTextStyle().greyColor.w400.s13,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchRequests,
      color: AppColors.darkNavy,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.pW12,
          vertical: AppPadding.pH12,
        ),
        itemCount: _requests.length,
        separatorBuilder: (context, index) => 12.szH,
        itemBuilder: (context, index) {
          final item = _requests[index];
          return _buildRequestCard(item);
        },
      ),
    );
  }

  Widget _buildRequestCard(ContactRequestModel item) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderGrey),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: AppColors.softBlueBg,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: item.employerLogo != null && item.employerLogo!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.network(
                          item.employerLogo!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.business_rounded,
                            color: AppColors.darkNavy,
                            size: 22.sp,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.business_rounded,
                        color: AppColors.darkNavy,
                        size: 22.sp,
                      ),
              ),
              12.szW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.employerName ?? 'طلب تواصل من شركة',
                      style: getTextStyle().darkNavy.w700.s16,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.createdAt != null) ...[
                      4.szH,
                      Text(
                        item.createdAt!.split('T').first,
                        style: getTextStyle().greyColor.w400.s12,
                      ),
                    ],
                  ],
                ),
              ),
              _buildStatusBadge(item.status),
            ],
          ),
          if (item.message != null && item.message!.trim().isNotEmpty) ...[
            12.szH,
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: AppColors.pageBg,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                item.message!,
                style: getTextStyle().darkNavy.w400.s13.copyWith(height: 1.4),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String? status) {
    final cleanStatus = (status ?? 'pending').toLowerCase();
    Color bg = AppColors.warningBg;
    Color color = AppColors.warningAmber;
    String label = S.of(context).statusPending;

    if (cleanStatus == 'accepted' || cleanStatus == 'approved') {
      bg = AppColors.successBg;
      color = AppColors.successGreen;
      label = S.of(context).statusApproved;
    } else if (cleanStatus == 'rejected') {
      bg = AppColors.errorBg;
      color = AppColors.errorRed;
      label = S.of(context).statusRejected;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: getTextStyle().w700.s11.copyWith(color: color),
      ),
    );
  }
}
