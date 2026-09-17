import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';
import 'package:m_kemet/src/core/network/connectivity_cubit.dart';
import 'package:m_kemet/src/core/services/service_locator/service_locator.dart';
import 'package:m_kemet/src/core/services/session_manager.dart';
import 'package:m_kemet/src/core/widgets/app_scaffold.dart';
import 'package:m_kemet/src/core/widgets/floating_bottom_nav_bar.dart';
import 'package:m_kemet/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/cubit/job_seeker_profile_cubit.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/cubit/job_seeker_profile_state.dart';
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

class _JobSeekerMainScreenState extends State<JobSeekerMainScreen>
    with WidgetsBindingObserver {
  late int _currentIndex;
  late final AuthCubit _authCubit;
  late final JobSeekerProfileCubit _profileCubit;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _authCubit = sl<AuthCubit>()..getProfile();
    _profileCubit = sl<JobSeekerProfileCubit>()..loadInitialData();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _authCubit.close();
    _profileCubit.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (lifecycleState == AppLifecycleState.resumed) {
      _profileCubit.refreshProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(
          value: _authCubit,
        ),
        BlocProvider<JobSeekerProfileCubit>.value(
          value: _profileCubit,
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ConnectivityCubit, ConnectivityState>(
            listenWhen: (previous, current) =>
                current.isConnected &&
                (previous.isDisconnected ||
                    previous.status == ConnectivityStatus.unknown ||
                    current.reconnectCounter > previous.reconnectCounter),
            listener: (context, state) {
              _authCubit.getProfile();
              _profileCubit.loadInitialData();
            },
          ),
          BlocListener<JobSeekerProfileCubit, JobSeekerProfileState>(
            listener: (context, state) {
              if (state.profileFetchStatus == LoadingStatus.success) {
                final profile = state.profileDetail;
                if (profile != null && !profile.isFormSubmitted) {
                  SessionManager.setJobSeekerProfileCompleted(false);
                  Go.offAllNamed(NamedRoutes.jobSeekerProfileSetup);
                }
              }
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
            children: const [
              JobSeekerProfileTab(),
              JobSeekerSettingsTab(),
            ],
          ),
          bottomNavigationBar: FloatingBottomNavBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() => _currentIndex = index);
              if (index == 1) {
                // Switching to Settings tab -> immediately refresh profile status!
                _profileCubit.refreshProfile();
              }
            },
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
      ),
    );
  }
}
