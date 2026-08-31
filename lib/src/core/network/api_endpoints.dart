class ApiEndpoints {
  ApiEndpoints._();

  // Auth endpoints
  static const String registerCandidate = '/api/register/candidate';
  static const String registerCompany = '/api/register/company';
  static const String verifyOtp = '/api/verify-otp';
  static const String resendOtp = '/api/resend-otp';
  static const String login = '/api/login';
  static const String refreshToken = '/api/refresh-token';
  static const String forgotPassword = '/api/forgot-password';
  static const String verifyResetOtp = '/api/verify-reset-otp';
  static const String resetPassword = '/api/reset-password';
  static const String profile = '/api/profile';
  static const String logout = '/api/logout';
  static const String logoutAll = '/api/logout-all';

  // Lookup endpoints
  static const String genders = '/api/genders';
  static const String countries = '/api/countries';
}
