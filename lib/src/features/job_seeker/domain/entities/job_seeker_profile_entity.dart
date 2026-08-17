/// Represents a job seeker's profile with professional and personal data.
class JobSeekerProfileEntity {
  final String id;
  final String fullName;
  final String profession;
  final String specialization;
  final int experienceYears;
  final String qualification;
  final List<String> languages;
  final List<String> skills;
  final String previousExperience;
  final double expectedSalary;
  final bool canTravel;
  final List<String> targetCountries;

  const JobSeekerProfileEntity({
    required this.id,
    required this.fullName,
    required this.profession,
    required this.specialization,
    required this.experienceYears,
    required this.qualification,
    required this.languages,
    required this.skills,
    required this.previousExperience,
    required this.expectedSalary,
    required this.canTravel,
    required this.targetCountries,
  });
}
