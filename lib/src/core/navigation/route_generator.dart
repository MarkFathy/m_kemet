import 'package:m_kemet/src/core/navigation/constants/imports_constants.dart';
import 'package:m_kemet/src/core/navigation/helper/Interfaces/helper_imports.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';
import 'package:m_kemet/src/core/navigation/page_router/imports_page_router_builder.dart';
import 'package:m_kemet/src/features/auth/presentation/view/forgot_password_screen.dart';
import 'package:m_kemet/src/features/auth/presentation/view/login_screen.dart';
import 'package:m_kemet/src/features/auth/presentation/view/otp_verification_screen.dart';
import 'package:m_kemet/src/features/auth/presentation/view/register_screen.dart';
import 'package:m_kemet/src/features/auth/presentation/view/terms_and_conditions_screen.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/view/job_seeker_main_screen.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/view/job_seeker_profile_setup_screen.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/view/my_contact_requests_screen.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/view/request_status_screen.dart';
import 'package:m_kemet/src/features/onboarding/presentation/view/onboarding_screen.dart';
import 'package:m_kemet/src/features/splash/presentation/splash_screen.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';
import 'package:m_kemet/src/features/company/presentation/view/candidate_detail_screen.dart';
import 'package:m_kemet/src/features/company/presentation/view/company_main_screen.dart';
import 'package:m_kemet/src/features/bookmarks/presentation/view/saved_candidates_screen.dart';
import 'package:m_kemet/src/features/notifications/presentation/view/notifications_screen.dart';
import 'package:m_kemet/src/features/user_type_selection/domain/entities/user_type.dart';
import 'package:m_kemet/src/features/user_type_selection/presentation/view/user_type_selection_screen.dart';
import 'package:flutter/material.dart';

class RouterGenerator {
  RouterGenerator._();

  static final PageRouterBuilder _pageRouter = PageRouterBuilder();

  static Route<dynamic> getRoute(RouteSettings settings) {
    var realArguments = settings.arguments;
    TransitionType? transition;
    AnimationOption? options;

    if (settings.arguments is NamedRouteArgs) {
      final args = settings.arguments! as NamedRouteArgs;
      realArguments = args.arguments;
      transition = args.transition;
      options = args.options;
    }

    final actualSettings = RouteSettings(name: settings.name, arguments: realArguments);

    final namedRoute = NamedRoutes.values.cast<NamedRoutes?>().firstWhere(
      (e) => e?.routeName == actualSettings.name,
      orElse: () => null,
    );

    if (namedRoute == null) return undefineRoute();

    return switch (namedRoute) {
      NamedRoutes.splash => _pageRouter.build(
        const SplashScreen(),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),
      NamedRoutes.onboarding => _pageRouter.build(
        const OnboardingScreen(),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),
      NamedRoutes.userTypeSelection => _pageRouter.build(
        const UserTypeSelectionScreen(),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),
      NamedRoutes.login => _pageRouter.build(
        LoginScreen(
          userType: realArguments is UserType ? realArguments : null,
        ),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),
      NamedRoutes.register => _pageRouter.build(
        RegisterScreen(
          userType: realArguments is UserType ? realArguments : null,
        ),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),
      NamedRoutes.forgotPassword => _pageRouter.build(
        ForgotPasswordScreen(
          userType: realArguments is UserType ? realArguments : null,
        ),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),
      NamedRoutes.otpVerification => _pageRouter.build(
        OtpVerificationScreen(
          args: realArguments is OtpScreenArgs ? realArguments : null,
          userType: realArguments is UserType
              ? realArguments
              : (realArguments is OtpScreenArgs ? realArguments.userType : null),
        ),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),
      NamedRoutes.termsAndConditions => _pageRouter.build(
        const TermsAndConditionsScreen(),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),
      NamedRoutes.jobSeekerProfileSetup => _pageRouter.build(
        const JobSeekerProfileSetupScreen(),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),
      NamedRoutes.jobSeekerMain => _pageRouter.build(
        JobSeekerMainScreen(
          initialIndex: realArguments is int ? realArguments : 0,
        ),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),
      NamedRoutes.requestStatus => _pageRouter.build(
        RequestStatusScreen(
          initialStatus: realArguments is RequestApprovalStatus
              ? realArguments
              : RequestApprovalStatus.pending,
        ),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),
      NamedRoutes.companyMain => _pageRouter.build(
        const CompanyMainScreen(),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),
      NamedRoutes.candidateDetail => _pageRouter.build(
        CandidateDetailScreen(
          candidate: realArguments as CandidateEntity,
        ),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),
      NamedRoutes.savedCandidates => _pageRouter.build(
        const SavedCandidatesScreen(),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),
      NamedRoutes.notifications => _pageRouter.build(
        const NotificationsScreen(),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),
      NamedRoutes.myContactRequests => _pageRouter.build(
        const MyContactRequestsScreen(),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),
    };
  }

  static Route<dynamic> undefineRoute() => MaterialPageRoute(
    builder: (_) => const Scaffold(body: Center(child: Text('No route defined'))),
  );
}
