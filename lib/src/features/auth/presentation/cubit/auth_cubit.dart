import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_kemet/src/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:m_kemet/src/features/auth/domain/usecases/get_countries_usecase.dart';
import 'package:m_kemet/src/features/auth/domain/usecases/get_genders_usecase.dart';
import 'package:m_kemet/src/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:m_kemet/src/features/auth/domain/usecases/login_usecase.dart';
import 'package:m_kemet/src/features/auth/domain/usecases/logout_usecase.dart';
import 'package:m_kemet/src/features/auth/domain/usecases/register_candidate_usecase.dart';
import 'package:m_kemet/src/features/auth/domain/usecases/register_company_usecase.dart';
import 'package:m_kemet/src/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:m_kemet/src/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:m_kemet/src/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:m_kemet/src/features/auth/domain/usecases/verify_reset_otp_usecase.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';
import 'package:m_kemet/src/features/auth/presentation/cubit/auth_state.dart';
import 'package:m_kemet/src/features/user_type_selection/domain/entities/user_type.dart';

class AuthCubit extends Cubit<AuthState> {
  final RegisterCandidateUseCase registerCandidateUseCase;
  final RegisterCompanyUseCase registerCompanyUseCase;
  final LoginUseCase loginUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResendOtpUseCase resendOtpUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final VerifyResetOtpUseCase verifyResetOtpUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final GetProfileUseCase getProfileUseCase;
  final LogoutUseCase logoutUseCase;
  final GetGendersUseCase getGendersUseCase;
  final GetCountriesUseCase getCountriesUseCase;

  AuthCubit({
    required this.registerCandidateUseCase,
    required this.registerCompanyUseCase,
    required this.loginUseCase,
    required this.verifyOtpUseCase,
    required this.resendOtpUseCase,
    required this.forgotPasswordUseCase,
    required this.verifyResetOtpUseCase,
    required this.resetPasswordUseCase,
    required this.getProfileUseCase,
    required this.logoutUseCase,
    required this.getGendersUseCase,
    required this.getCountriesUseCase,
  }) : super(const AuthState());

  S get _l10n {
    final context = Go.navigatorKey.currentContext;
    if (context != null) {
      final s = S.maybeOf(context);
      if (s != null) return s;
    }
    try {
      return S.current;
    } catch (_) {
      return S();
    }
  }

  String _getMismatchErrorMessage(UserType expectedUserType) {
    return expectedUserType == UserType.jobSeeker
        ? _l10n.userTypeMismatchCompanyError
        : _l10n.userTypeMismatchCandidateError;
  }

  void setUserType(UserType userType) {
    emit(state.copyWith(userType: userType));
  }

  void setPendingEmail(String email) {
    emit(state.copyWith(pendingEmail: email));
  }

  Future<void> registerCandidate(RegisterCandidateParams params) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await registerCandidateUseCase(params);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.serverException.message,
        ),
      ),
      (authEntity) => emit(
        state.copyWith(
          status: AuthStatus.registerSuccess,
          authEntity: authEntity,
          user: authEntity.user,
          pendingEmail: params.email,
          userType: UserType.jobSeeker,
          successMessage: authEntity.message ?? _l10n.registrationSuccessMessage,
        ),
      ),
    );
  }

  Future<void> registerCompany(RegisterCompanyParams params) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await registerCompanyUseCase(params);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.serverException.message,
        ),
      ),
      (authEntity) => emit(
        state.copyWith(
          status: AuthStatus.registerSuccess,
          authEntity: authEntity,
          user: authEntity.user,
          pendingEmail: params.email,
          userType: UserType.employer,
          successMessage: authEntity.message ?? _l10n.registrationSuccessMessage,
        ),
      ),
    );
  }

  Future<void> login({
    required String email,
    required String password,
    UserType? fallbackUserType,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final expectedType = fallbackUserType ?? state.userType;
    final result = await loginUseCase(
      LoginParams(
        email: email,
        password: password,
        expectedUserType: expectedType,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.serverException.message,
        ),
      ),
      (authEntity) async {
        final accountType = authEntity.user?.userType;
        if (expectedType != null && accountType != null && accountType != expectedType) {
          await logoutUseCase();
          emit(
            state.copyWith(
              status: AuthStatus.error,
              errorMessage: _getMismatchErrorMessage(expectedType),
            ),
          );
          return;
        }

        final resolvedUserType = accountType ?? expectedType ?? UserType.jobSeeker;
        emit(
          state.copyWith(
            status: AuthStatus.loginSuccess,
            authEntity: authEntity,
            user: authEntity.user,
            userType: resolvedUserType,
            successMessage: authEntity.message ?? _l10n.loginSuccessMessage,
          ),
        );
      },
    );
  }

  Future<void> verifyOtp({
    required String email,
    required String code,
    UserType? userType,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final expectedType = userType ?? state.userType;
    final result = await verifyOtpUseCase(
      VerifyOtpParams(
        email: email,
        code: code,
        expectedUserType: expectedType,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.serverException.message,
        ),
      ),
      (authEntity) async {
        final accountType = authEntity.user?.userType;
        if (expectedType != null && accountType != null && accountType != expectedType) {
          await logoutUseCase();
          emit(
            state.copyWith(
              status: AuthStatus.error,
              errorMessage: _getMismatchErrorMessage(expectedType),
            ),
          );
          return;
        }

        emit(
          state.copyWith(
            status: AuthStatus.otpVerified,
            authEntity: authEntity,
            user: authEntity.user,
            userType: accountType ?? expectedType ?? state.userType,
            successMessage: authEntity.message ?? _l10n.otpVerifiedSuccessMessage,
          ),
        );
      },
    );
  }

  Future<void> resendOtp(String email) async {
    emit(state.copyWith(resendOtpLoading: true));
    final result = await resendOtpUseCase(ResendOtpParams(email: email));
    result.fold(
      (failure) => emit(
        state.copyWith(
          resendOtpLoading: false,
          status: AuthStatus.error,
          errorMessage: failure.serverException.message,
        ),
      ),
      (msg) => emit(
        state.copyWith(
          resendOtpLoading: false,
          status: AuthStatus.otpResent,
          successMessage: msg,
        ),
      ),
    );
  }

  Future<void> forgotPassword(String email) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await forgotPasswordUseCase(ForgotPasswordParams(email: email));
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.serverException.message,
        ),
      ),
      (msg) => emit(
        state.copyWith(
          status: AuthStatus.otpSent,
          pendingEmail: email,
          successMessage: msg,
        ),
      ),
    );
  }

  Future<void> verifyResetOtp({
    required String email,
    required String code,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await verifyResetOtpUseCase(VerifyOtpParams(email: email, code: code));
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.serverException.message,
        ),
      ),
      (msg) => emit(
        state.copyWith(
          status: AuthStatus.resetOtpVerified,
          pendingEmail: email,
          successMessage: msg,
        ),
      ),
    );
  }

  Future<void> resetPassword(ResetPasswordParams params) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await resetPasswordUseCase(params);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.serverException.message,
        ),
      ),
      (msg) => emit(
        state.copyWith(
          status: AuthStatus.passwordResetSuccess,
          successMessage: msg,
        ),
      ),
    );
  }

  Future<void> getProfile() async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await getProfileUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.serverException.message,
        ),
      ),
      (user) => emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          userType: user.userType,
        ),
      ),
    );
  }

  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading));
    await logoutUseCase();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  Future<void> fetchGenders() async {
    emit(state.copyWith(gendersLoading: true));
    final result = await getGendersUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          gendersLoading: false,
          errorMessage: failure.serverException.message,
        ),
      ),
      (genders) => emit(
        state.copyWith(
          gendersLoading: false,
          genders: genders,
        ),
      ),
    );
  }

  Future<void> fetchCountries() async {
    emit(state.copyWith(countriesLoading: true));
    final result = await getCountriesUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          countriesLoading: false,
          errorMessage: failure.serverException.message,
        ),
      ),
      (countries) => emit(
        state.copyWith(
          countriesLoading: false,
          countries: countries,
        ),
      ),
    );
  }
}
