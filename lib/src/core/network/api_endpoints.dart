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
  static const String professions = '/api/professions';
  static const String experienceLevels = '/api/experience-levels';
  static const String qualifications = '/api/qualifications';

  // Candidate endpoints
  static const String candidateMyDocument = '/api/candidate/my-document';
  static const String candidateUpdateDocument = '/api/candidate/update-document';
  static const String candidateDocuments = '/api/candidate/documents';
  static const String candidateVideo = '/api/candidate/video';
  static String candidateDocumentFile(int id) => '/api/candidate/documents/$id/file';

  // Company / Job Seekers endpoints
  static const String jobSeekers = '/api/job-seekers';
  static const String bookmarks = '/api/bookmarks';
  static String jobSeekerDetail(dynamic id) => '/api/job-seekers/$id';
  static String jobSeekerContactRequest(dynamic id) => '/api/job-seekers/$id/contact-request';
  static String jobSeekerBookmark(dynamic id) => '/api/job-seekers/$id/bookmark';
}
