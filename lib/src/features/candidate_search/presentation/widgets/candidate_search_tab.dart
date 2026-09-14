import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/widgets/empty_state.dart';
import 'package:m_kemet/src/core/widgets/shimmer/shimmer.dart';
import 'package:m_kemet/src/features/bookmarks/presentation/cubit/bookmarks_cubit.dart';
import 'package:m_kemet/src/features/candidate_search/presentation/cubit/candidate_search_cubit.dart';
import 'package:m_kemet/src/features/candidate_search/presentation/cubit/candidate_search_state.dart';
import 'package:m_kemet/src/features/candidate_search/presentation/widgets/candidate_active_filters_bar.dart';
import 'package:m_kemet/src/features/candidate_search/presentation/widgets/candidate_card.dart';
import 'package:m_kemet/src/features/candidate_search/presentation/widgets/candidate_search_bar.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';

class CandidateSearchTab extends StatefulWidget {
  final TextEditingController searchController;
  final void Function(CandidateEntity candidate) onViewCandidateProfile;

  const CandidateSearchTab({
    super.key,
    required this.searchController,
    required this.onViewCandidateProfile,
  });

  @override
  State<CandidateSearchTab> createState() => _CandidateSearchTabState();
}

class _CandidateSearchTabState extends State<CandidateSearchTab> {
  late final ScrollController _scrollController;
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<CandidateSearchCubit>().loadMoreCandidates();
    }

    final shouldShow = _scrollController.hasClients && _scrollController.offset > 300;
    if (shouldShow != _showBackToTop) {
      setState(() {
        _showBackToTop = shouldShow;
      });
    }
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 250);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () => context.read<CandidateSearchCubit>().fetchCandidates(isRefresh: true),
          color: AppColors.darkNavy,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
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

                // Search Bar & Filter Button Row
                CandidateSearchBar(controller: widget.searchController),

                // Active Filters indicator chip bar
                const CandidateActiveFiltersBar(),

                20.szH,

                // Dynamic Search Results
                _buildSearchResults(),

                100.szH,
              ],
            ),
          ),
        ),

        // Scroll to Top Floating Action Button
        _buildScrollToTopButton(),
      ],
    );
  }

  Widget _buildSearchResults() {
    return BlocBuilder<CandidateSearchCubit, CandidateSearchState>(
      builder: (context, state) {
        if (state.status == CandidateSearchStatus.loading) {
          return const CandidateListShimmer();
        }

        if (state.status == CandidateSearchStatus.failure) {
          final isNetworkError = state.errorMessage == null ||
              state.errorMessage!.contains('host lookup') ||
              state.errorMessage!.contains('connection') ||
              state.errorMessage!.contains('SocketException') ||
              state.errorMessage!.contains('اتصال') ||
              state.errorMessage!.contains('انترنت') ||
              state.errorMessage!.contains('Internet');

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => context.read<CandidateSearchCubit>().fetchCandidates(),
            child: EmptyState(
              icon: isNetworkError ? Icons.wifi_off_rounded : Icons.error_outline_rounded,
              title: isNetworkError
                  ? S.of(context).noInternetTitle
                  : (state.errorMessage ?? S.of(context).noInternetTitle),
            ),
          );
        }

        if (state.candidates.isEmpty) {
          return EmptyState(
            icon: Icons.search_off_rounded,
            title: S.of(context).noSearchResultsTitle,
            subtitle: S.of(context).noSearchResultsSub,
          );
        }

        return Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.candidates.length,
              separatorBuilder: (context, index) => 14.szH,
              itemBuilder: (context, index) {
                final candidate = state.candidates[index];
                return CandidateCard(
                  candidate: candidate,
                  onViewProfile: () => widget.onViewCandidateProfile(candidate),
                  onToggleSave: () {
                    context.read<BookmarksCubit>().toggleBookmark(candidate);
                    context.read<CandidateSearchCubit>().toggleSaveCandidate(candidate.id);
                  },
                );
              },
            ),
            if (state.isLoadingMore) ...[
              20.szH,
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.darkNavy),
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildScrollToTopButton() {
    return PositionedDirectional(
      bottom: 85.h,
      end: 16.w,
      child: AnimatedScale(
        scale: _showBackToTop ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutBack,
        child: AnimatedOpacity(
          opacity: _showBackToTop ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Material(
            color: AppColors.transparentColor,
            child: InkWell(
              onTap: _showBackToTop ? _scrollToTop : null,
              borderRadius: BorderRadius.circular(24.r),
              child: Container(
                width: 46.w,
                height: 46.w,
                decoration: BoxDecoration(
                  color: AppColors.darkNavy,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.darkNavy.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: AppColors.skyBlue.withValues(alpha: 0.6),
                    width: 1.2,
                  ),
                ),
                child: Icon(
                  Icons.keyboard_arrow_up_rounded,
                  color: AppColors.whiteColor,
                  size: 28.sp,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
