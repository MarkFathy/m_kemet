import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';
import 'package:m_kemet/src/core/services/service_locater/service_locator.dart';
import 'package:m_kemet/src/core/widgets/app_scaffold.dart';
import 'package:m_kemet/src/core/widgets/floating_bottom_nav_bar.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';
import 'package:m_kemet/src/features/company/presentation/cubit/candidate_search_cubit.dart';
import 'package:m_kemet/src/features/company/presentation/widgets/tabs/profile_tab.dart';
import 'package:m_kemet/src/features/company/presentation/widgets/tabs/requests_tab.dart';
import 'package:m_kemet/src/features/company/presentation/widgets/tabs/search_tab.dart';
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
    return BlocProvider<CandidateSearchCubit>(
      create: (context) => sl<CandidateSearchCubit>()..fetchCandidates(),
      child: AppScaffold(
        safeTop: true,
        safeBottom: true,
        backgroundColor: AppColors.pageBg,
        body: IndexedStack(
          index: _currentIndex,
          children: [
            SearchTab(
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
    );
  }
}
