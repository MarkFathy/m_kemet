import 'package:equatable/equatable.dart';
import 'package:m_kemet/src/features/auth/domain/entities/auth_entity.dart';
import 'package:m_kemet/src/features/auth/domain/entities/country_entity.dart';
import 'package:m_kemet/src/features/auth/domain/entities/gender_entity.dart';
import 'package:m_kemet/src/features/auth/domain/entities/user_entity.dart';
import 'package:m_kemet/src/features/user_type_selection/domain/entities/user_type.dart';

enum AuthStatus {
  initial,
  loading,
  registerSuccess,
  loginSuccess,
  otpSent,
  otpResent,
  otpVerified,
  resetOtpVerified,
  passwordResetSuccess,
  authenticated,
  unauthenticated,
  error,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthEntity? authEntity;
  final UserEntity? user;
  final String? errorMessage;
  final String? successMessage;
  final String? pendingEmail;
  final UserType? userType;
  final List<GenderEntity> genders;
  final bool gendersLoading;
  final List<CountryEntity> countries;
  final bool countriesLoading;
  final bool resendOtpLoading;

  const AuthState({
    this.status = AuthStatus.initial,
    this.authEntity,
    this.user,
    this.errorMessage,
    this.successMessage,
    this.pendingEmail,
    this.userType,
    this.genders = const [],
    this.gendersLoading = false,
    this.countries = const [],
    this.countriesLoading = false,
    this.resendOtpLoading = false,
  });

  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({
    AuthStatus? status,
    AuthEntity? authEntity,
    UserEntity? user,
    String? errorMessage,
    String? successMessage,
    String? pendingEmail,
    UserType? userType,
    List<GenderEntity>? genders,
    bool? gendersLoading,
    List<CountryEntity>? countries,
    bool? countriesLoading,
    bool? resendOtpLoading,
  }) {
    return AuthState(
      status: status ?? this.status,
      authEntity: authEntity ?? this.authEntity,
      user: user ?? this.user,
      errorMessage: errorMessage,
      successMessage: successMessage,
      pendingEmail: pendingEmail ?? this.pendingEmail,
      userType: userType ?? this.userType,
      genders: genders ?? this.genders,
      gendersLoading: gendersLoading ?? this.gendersLoading,
      countries: countries ?? this.countries,
      countriesLoading: countriesLoading ?? this.countriesLoading,
      resendOtpLoading: resendOtpLoading ?? this.resendOtpLoading,
    );
  }

  @override
  List<Object?> get props => [
        status,
        authEntity,
        user,
        errorMessage,
        successMessage,
        pendingEmail,
        userType,
        genders,
        gendersLoading,
        countries,
        countriesLoading,
        resendOtpLoading,
      ];
}
