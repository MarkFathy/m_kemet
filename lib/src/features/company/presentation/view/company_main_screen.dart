import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/core/app_cubit/app_cubit.dart';
import 'package:m_kemet/src/core/app_cubit/app_state.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';
import 'package:m_kemet/src/core/network/connectivity_cubit.dart';
import 'package:m_kemet/src/core/services/service_locator/service_locator.dart';
import 'package:m_kemet/src/core/widgets/app_scaffold.dart';
import 'package:m_kemet/src/core/widgets/floating_bottom_nav_bar.dart';
import 'package:m_kemet/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:m_kemet/src/features/bookmarks/presentation/cubit/bookmarks_cubit.dart';
import 'package:m_kemet/src/features/bookmarks/presentation/cubit/bookmarks_state.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';
import 'package:m_kemet/src/features/candidate_search/presentation/cubit/candidate_search_cubit.dart';
import 'package:m_kemet/src/features/candidate_search/presentation/cubit/candidate_search_state.dart';
import 'package:m_kemet/src/features/candidate_search/presentation/widgets/candidate_search_tab.dart';
import 'package:m_kemet/src/features/company/presentation/widgets/tabs/profile_tab.dart';
import 'package:m_kemet/src/features/company/presentation/widgets/tabs/requests_tab.dart';
import 'package:m_kemet/src/features/company/presentation/widgets/tabs/settings_tab.dart';

class CompanyMainScreen extends StatefulWidget {
  const CompanyMainScreen({super.key});

  @override
  State<CompanyMainScreen> createState() => _CompanyMainScreenState();
}

class _CompanyMainScreenState extends State<CompanyMainScreen> {
  int _currentIndex = 0;
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<CandidateSearchCubit>(
          create: (context) => sl<CandidateSearchCubit>()..fetchCandidates(),
        ),
        // Expose the global BookmarksCubit singleton — same instance reused in all routes
        BlocProvider<BookmarksCubit>.value(
          value: sl<BookmarksCubit>()..fetchBookmarks(),
        ),
        BlocProvider<AuthCubit>(
          create: (context) => sl<AuthCubit>()..getProfile(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<BookmarksCubit, BookmarksState>(
            // Sync CandidateSearchCubit whenever BookmarksCubit changes (rollbacks, confirmations)
            listener: (context, bookmarksState) {
              final searchCubit = context.read<CandidateSearchCubit>();
              for (final candidate in searchCubit.state.candidates) {
                final serverSaved = bookmarksState.bookmarkedIds.contains(candidate.id);
                if (candidate.isSaved != serverSaved) {
                  searchCubit.syncCandidateBookmark(candidate.id, isSaved: serverSaved);
                }
              }
            },
          ),
          BlocListener<AppCubit, AppState>(
            listenWhen: (previous, current) => previous.locale != current.locale,
            listener: (context, state) {
              // Immediately refresh candidates and saved lists when language changes
              context.read<CandidateSearchCubit>().fetchCandidates();
              context.read<BookmarksCubit>().fetchBookmarks();
              context.read<AuthCubit>().getProfile();
            },
          ),
          BlocListener<ConnectivityCubit, ConnectivityState>(
            listenWhen: (previous, current) =>
                current.isConnected &&
                (previous.isDisconnected ||
                    previous.status == ConnectivityStatus.unknown ||
                    current.reconnectCounter > previous.reconnectCounter ||
                    context.read<CandidateSearchCubit>().state.status ==
                        CandidateSearchStatus.failure),
            listener: (context, state) {
              // Automatically reload screen data when internet connection is restored
              context.read<CandidateSearchCubit>().fetchCandidates();
              context.read<BookmarksCubit>().fetchBookmarks();
              context.read<AuthCubit>().getProfile();
            },
          ),
        ],
        child: AppScaffold(
          safeTop: true,
          safeBottom: true,
          extendBody: true,
          backgroundColor: AppColors.pageBg,
          body: IndexedStack(
            index: _currentIndex,
            children: [
              CandidateSearchTab(
                searchController: _searchController,
                onViewCandidateProfile: _onViewCandidateProfile,
              ),
              const RequestsTab(),
              const ProfileTab(),
              const SettingsTab(),
            ],
          ),
          bottomNavigationBar: FloatingBottomNavBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
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
          ),
        ),
      ),
    );
  }
}
