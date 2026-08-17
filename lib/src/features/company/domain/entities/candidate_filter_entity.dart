import 'package:equatable/equatable.dart';

class CandidateFilterEntity extends Equatable {
  final String searchQuery;
  final String? country;
  final String? profession;
  final String? experienceYears;
  final String? qualification;
  final String? language;
  final String? gender;
  final int? minAge;
  final int? maxAge;
  final bool? isValidPassport;
  final String? travelAvailability;

  const CandidateFilterEntity({
    this.searchQuery = '',
    this.country,
    this.profession,
    this.experienceYears,
    this.qualification,
    this.language,
    this.gender,
    this.minAge,
    this.maxAge,
    this.isValidPassport,
    this.travelAvailability,
  });

  bool get hasActiveFilters =>
      searchQuery.isNotEmpty ||
      (country != null && country!.isNotEmpty) ||
      (profession != null && profession!.isNotEmpty) ||
      (experienceYears != null && experienceYears!.isNotEmpty) ||
      (qualification != null && qualification!.isNotEmpty) ||
      (language != null && language!.isNotEmpty) ||
      (gender != null && gender!.isNotEmpty) ||
      minAge != null ||
      maxAge != null ||
      isValidPassport != null ||
      (travelAvailability != null && travelAvailability!.isNotEmpty);

  CandidateFilterEntity copyWith({
    String? searchQuery,
    String? country,
    String? profession,
    String? experienceYears,
    String? qualification,
    String? language,
    String? gender,
    int? minAge,
    int? maxAge,
    bool? isValidPassport,
    String? travelAvailability,
    bool resetCountry = false,
    bool resetProfession = false,
    bool resetExperienceYears = false,
    bool resetQualification = false,
    bool resetLanguage = false,
    bool resetGender = false,
    bool resetPassport = false,
  }) {
    return CandidateFilterEntity(
      searchQuery: searchQuery ?? this.searchQuery,
      country: resetCountry ? null : (country ?? this.country),
      profession: resetProfession ? null : (profession ?? this.profession),
      experienceYears: resetExperienceYears ? null : (experienceYears ?? this.experienceYears),
      qualification: resetQualification ? null : (qualification ?? this.qualification),
      language: resetLanguage ? null : (language ?? this.language),
      gender: resetGender ? null : (gender ?? this.gender),
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      isValidPassport: resetPassport ? null : (isValidPassport ?? this.isValidPassport),
      travelAvailability: travelAvailability ?? this.travelAvailability,
    );
  }

  @override
  List<Object?> get props => [
        searchQuery,
        country,
        profession,
        experienceYears,
        qualification,
        language,
        gender,
        minAge,
        maxAge,
        isValidPassport,
        travelAvailability,
      ];
}
