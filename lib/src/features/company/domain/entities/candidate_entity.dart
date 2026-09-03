import 'package:equatable/equatable.dart';

class CandidateEntity extends Equatable {
  final String id;
  final String name;
  final String profession;
  final String experienceYears;
  final String qualification;
  final String languages;
  final String gender;
  final int age;
  final String currentCountry;
  final String targetCountries;
  final bool isValidPassport;
  final bool isVerified;
  final bool isSaved;
  final bool isContactRequested;
  final String photoUrl;
  final String introVideoUrl;
  final String videoThumbnailUrl;
  final String cvUrl;
  final String expectedSalary;
  final String bio;

  // Fields from api/job-seekers list
  final int? candidateId;
  final int? userId;
  final int? profileId;
  final String verificationBadge;
  final String professionWithExperience;
  final String currentCountryFlag;
  final String passportStatusLabel;
  final List<String> targetCountryNames;
  final String email;
  final String phone;

  const CandidateEntity({
    required this.id,
    required this.name,
    required this.profession,
    this.experienceYears = '',
    this.qualification = '',
    this.languages = '',
    this.gender = '',
    this.age = 0,
    this.currentCountry = '',
    this.targetCountries = '',
    this.isValidPassport = false,
    this.isVerified = false,
    this.isSaved = false,
    this.isContactRequested = false,
    this.photoUrl = '',
    this.introVideoUrl = '',
    this.videoThumbnailUrl = '',
    this.cvUrl = '',
    this.expectedSalary = '',
    this.bio = '',
    this.candidateId,
    this.userId,
    this.profileId,
    this.verificationBadge = '',
    this.professionWithExperience = '',
    this.currentCountryFlag = '',
    this.passportStatusLabel = '',
    this.targetCountryNames = const [],
    this.email = '',
    this.phone = '',
  });

  CandidateEntity copyWith({
    String? id,
    String? name,
    String? profession,
    String? experienceYears,
    String? qualification,
    String? languages,
    String? gender,
    int? age,
    String? currentCountry,
    String? targetCountries,
    bool? isValidPassport,
    bool? isVerified,
    bool? isSaved,
    bool? isContactRequested,
    String? photoUrl,
    String? introVideoUrl,
    String? videoThumbnailUrl,
    String? cvUrl,
    String? expectedSalary,
    String? bio,
    int? candidateId,
    int? userId,
    int? profileId,
    String? verificationBadge,
    String? professionWithExperience,
    String? currentCountryFlag,
    String? passportStatusLabel,
    List<String>? targetCountryNames,
    String? email,
    String? phone,
  }) {
    return CandidateEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      profession: profession ?? this.profession,
      experienceYears: experienceYears ?? this.experienceYears,
      qualification: qualification ?? this.qualification,
      languages: languages ?? this.languages,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      currentCountry: currentCountry ?? this.currentCountry,
      targetCountries: targetCountries ?? this.targetCountries,
      isValidPassport: isValidPassport ?? this.isValidPassport,
      isVerified: isVerified ?? this.isVerified,
      isSaved: isSaved ?? this.isSaved,
      isContactRequested: isContactRequested ?? this.isContactRequested,
      photoUrl: photoUrl ?? this.photoUrl,
      introVideoUrl: introVideoUrl ?? this.introVideoUrl,
      videoThumbnailUrl: videoThumbnailUrl ?? this.videoThumbnailUrl,
      cvUrl: cvUrl ?? this.cvUrl,
      expectedSalary: expectedSalary ?? this.expectedSalary,
      bio: bio ?? this.bio,
      candidateId: candidateId ?? this.candidateId,
      userId: userId ?? this.userId,
      profileId: profileId ?? this.profileId,
      verificationBadge: verificationBadge ?? this.verificationBadge,
      professionWithExperience: professionWithExperience ?? this.professionWithExperience,
      currentCountryFlag: currentCountryFlag ?? this.currentCountryFlag,
      passportStatusLabel: passportStatusLabel ?? this.passportStatusLabel,
      targetCountryNames: targetCountryNames ?? this.targetCountryNames,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        profession,
        experienceYears,
        qualification,
        languages,
        gender,
        age,
        currentCountry,
        targetCountries,
        isValidPassport,
        isVerified,
        isSaved,
        isContactRequested,
        photoUrl,
        introVideoUrl,
        videoThumbnailUrl,
        cvUrl,
        expectedSalary,
        bio,
        candidateId,
        userId,
        profileId,
        verificationBadge,
        professionWithExperience,
        currentCountryFlag,
        passportStatusLabel,
        targetCountryNames,
        email,
        phone,
      ];
}
