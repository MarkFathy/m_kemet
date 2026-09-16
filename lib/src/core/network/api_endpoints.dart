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
  static const String deleteAccount = '/api/delete-account';

  // Lookup endpoints
  static const String terms = '/api/terms';
  static const String genders = '/api/genders';
  static const String countries = '/api/countries';
  static const String countriesTop6 = '/api/countries/top-6';
  static const String professions = '/api/professions';
  static const String professionsPopular = '/api/professions/popular';
  static const String experienceLevels = '/api/experience-levels';
  static const String qualifications = '/api/qualifications';

  // Candidate endpoints
  static const String candidateMyDocument = '/api/candidate/my-document';
  static const String myRequests = '/api/my-requests';
  static const String candidateUpdateDocument =
      '/api/candidate/update-document';
  static const String candidateDocuments = '/api/candidate/documents';
  static const String candidateVideo = '/api/candidate/video';
  static String candidateDocumentFile(int id) =>
      '/api/candidate/documents/$id/file';

  // Company / Job Seekers endpoints
  static const String jobSeekers = '/api/job-seekers';
  static const String jobSeekersSearch = '/api/job-seekers/search';
  static const String jobSeekersFilter = '/api/job-seekers/filter';
  static const String bookmarks = '/api/bookmarks';
  static String jobSeekerDetail(dynamic id) => '/api/job-seekers/$id';
  static String jobSeekerContactRequest(dynamic id) =>
      '/api/job-seekers/$id/contact-request';
  static String jobSeekerBookmark(dynamic id) =>
      '/api/job-seekers/$id/bookmark';

  // Notifications / FCM endpoints
  static const String fcmToken = '/api/fcm-token';
  static const String fcmTokenUser = '/api/fcm-token-user';
  static const String notificationStatus = '/api/notification/status';
  static const String notificationTurnOn = '/api/notification/turn-on';
  static const String notificationTurnOff = '/api/notification/turn-off';
  static const String notifications = '/api/notifications';
  static const String notificationsReadAll = '/api/notifications/read-all';
  static String notificationRead(dynamic id) => '/api/notifications/$id/read';
  static const String notificationsDeleteAll = '/api/notifications/delete-all';
  static String notificationDelete(dynamic id) => '/api/notifications/$id/delete';
}
