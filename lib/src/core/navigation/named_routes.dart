enum NamedRoutes {
  splash('/'),
  onboarding('/onboarding'),
  userTypeSelection('/userTypeSelection'),
  login('/login'),
  register('/register'),
  otpVerification('/otpVerification'),
  forgotPassword('/forgotPassword'),
  termsAndConditions('/termsAndConditions'),
  jobSeekerProfileSetup('/jobSeekerProfileSetup'),
  requestStatus('/requestStatus'),
  companyMain('/companyMain'),
  candidateDetail('/candidateDetail'),
  savedCandidates('/savedCandidates'),
  notificationsHistory('/notificationsHistory'),
  appLock('/appLock'),
  complaints('/complaints');

  final String routeName;

  const NamedRoutes(this.routeName);
}
