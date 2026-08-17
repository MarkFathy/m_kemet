enum NamedRoutes {
  splash('/'),
  onboarding('/onboarding'),
  userTypeSelection('/userTypeSelection'),
  home('/home'),
  login('/login'),
  register('/register'),
  otpVerification('/otpVerification'),
  jobSeekerProfileSetup('/jobSeekerProfileSetup'),
  roomLobby('/roomLobby'),
  countdown('/countdown'),
  gameBoard('/gameBoard'),
  scoring('/scoring'),
  leaderboard('/leaderboard'),
  settings('/settings'),
  profile('/profile'),
  privacyPolicy('/privacyPolicy'),
  aboutGame('/aboutGame'),
  complaints('/complaints'),
  appLock('/appLock'),
  requestStatus('/requestStatus'),
  companyMain('/companyMain'),
  candidateDetail('/candidateDetail'),
  savedCandidates('/savedCandidates'),
  notificationsHistory('/notificationsHistory');
  
  final String routeName;

  const NamedRoutes(this.routeName);
}
