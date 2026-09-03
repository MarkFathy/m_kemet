import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/core/services/service_locator/service_locator.dart';
import 'package:m_kemet/src/core/widgets/app_scaffold.dart';
import 'package:m_kemet/src/core/widgets/floating_bottom_nav_bar.dart';
import 'package:m_kemet/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/cubit/job_seeker_profile_cubit.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/tabs/job_seeker_profile_tab.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/tabs/job_seeker_settings_tab.dart';

class JobSeekerMainScreen extends StatefulWidget {
  final int initialIndex;

  const JobSeekerMainScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<JobSeekerMainScreen> createState() => _JobSeekerMainScreenState();
}

class _JobSeekerMainScreenState extends State<JobSeekerMainScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => sl<AuthCubit>()..getProfile(),
        ),
        BlocProvider<JobSeekerProfileCubit>(
          create: (context) => sl<JobSeekerProfileCubit>()..loadInitialData(),
        ),
      ],
      child: AppScaffold(
        safeTop: true,
        safeBottom: true,
        backgroundColor: AppColors.pageBg,
        body: IndexedStack(
          index: _currentIndex,
          children: const [
            JobSeekerProfileTab(),
            JobSeekerSettingsTab(),
          ],
        ),
        bottomNavigationBar: FloatingBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: [
            FloatingNavItem(
              icon: Icons.person_outline_rounded,
              activeIcon: Icons.person_rounded,
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
