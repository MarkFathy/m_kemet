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
  final String photoUrl;
  final String introVideoUrl;
  final String cvUrl;
  final String expectedSalary;
  final String bio;

  const CandidateEntity({
    required this.id,
    required this.name,
    required this.profession,
    required this.experienceYears,
    required this.qualification,
    required this.languages,
    required this.gender,
    required this.age,
    required this.currentCountry,
    required this.targetCountries,
    required this.isValidPassport,
    required this.isVerified,
    this.isSaved = false,
    required this.photoUrl,
    required this.introVideoUrl,
    required this.cvUrl,
    required this.expectedSalary,
    required this.bio,
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
    String? photoUrl,
    String? introVideoUrl,
    String? cvUrl,
    String? expectedSalary,
    String? bio,
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
      photoUrl: photoUrl ?? this.photoUrl,
      introVideoUrl: introVideoUrl ?? this.introVideoUrl,
      cvUrl: cvUrl ?? this.cvUrl,
      expectedSalary: expectedSalary ?? this.expectedSalary,
      bio: bio ?? this.bio,
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
        photoUrl,
        introVideoUrl,
        cvUrl,
        expectedSalary,
        bio,
      ];
}
