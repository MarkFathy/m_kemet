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
import 'package:m_kemet/src/core/widgets/empty_state.dart';
import 'package:m_kemet/src/core/widgets/network_error_widget.dart';
import 'package:m_kemet/src/core/widgets/shimmer/shimmer.dart';
import 'package:m_kemet/src/features/company/presentation/cubit/company_requests_cubit.dart';
import 'package:m_kemet/src/features/company/presentation/cubit/company_requests_state.dart';
import 'package:m_kemet/src/features/company/presentation/widgets/requests/company_contact_request_card.dart';

class RequestsTab extends StatefulWidget {
  const RequestsTab({super.key});

  @override
  State<RequestsTab> createState() => _RequestsTabState();
}

class _RequestsTabState extends State<RequestsTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final cubit = context.read<CompanyRequestsCubit>();
        if (cubit.state.status == CompanyRequestsStatus.initial) {
          cubit.fetchRequests();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompanyRequestsCubit, CompanyRequestsState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () =>
              context.read<CompanyRequestsCubit>().fetchRequests(isRefresh: true),
          color: AppColors.darkNavy,
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
                // Header with Title & Request Count Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).requestsTitle,
                      style: getTextStyle().darkNavy.w700.s24,
                    ),
                    if (state.requests.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.softBlueBg,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          '${state.requests.length} طلبات',
                          style: getTextStyle().darkNavy.w700.s12,
                        ),
                      ),
                  ],
                ),

                16.szH,

                // Content
                _buildBody(context, state),

                100.szH,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, CompanyRequestsState state) {
    if (state.status == CompanyRequestsStatus.loading && state.requests.isEmpty) {
      return const CandidateListShimmer();
    }

    if (state.status == CompanyRequestsStatus.failure && state.requests.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 40.h),
        child: NetworkErrorWidget(
          onRetry: () => context.read<CompanyRequestsCubit>().fetchRequests(),
        ),
      );
    }

    if (state.requests.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 40.h),
        child: EmptyState(
          icon: Icons.assignment_outlined,
          title: S.of(context).noRequestsTitle,
          subtitle: S.of(context).noRequestsSub,
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.requests.length,
      separatorBuilder: (context, index) => 14.szH,
      itemBuilder: (context, index) {
        final request = state.requests[index];
        return CompanyContactRequestCard(
          request: request,
          onViewProfile: request.candidate != null
              ? () {
                  Go.toNamed(
                    NamedRoutes.candidateDetail,
                    arguments: request.candidate,
                  );
                }
              : null,
        );
      },
    );
  }
}
