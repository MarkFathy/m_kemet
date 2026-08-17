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
  notificationsHistory('/notificationsHistory');

  final String routeName;

  const NamedRoutes(this.routeName);
}
