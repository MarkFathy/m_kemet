import 'package:equatable/equatable.dart';

class CandidateSearchFilterEntity extends Equatable {
  final String searchQuery;
  final int? countryId;
  final String? countryName;
  final int? professionId;
  final String? professionName;
  final String? gender;
  final bool? isValidPassport;
  final int? experienceLevelId;
  final String? experienceYears;
  final int? qualificationId;

  const CandidateSearchFilterEntity({
    this.searchQuery = '',
    this.countryId,
    this.countryName,
    this.professionId,
    this.professionName,
    this.gender,
    this.isValidPassport,
    this.experienceLevelId,
    this.experienceYears,
    this.qualificationId,
  });

  bool get hasActiveFilters =>
      searchQuery.trim().isNotEmpty ||
      countryId != null ||
      (countryName != null && countryName!.isNotEmpty && countryName != 'الكل') ||
      professionId != null ||
      (professionName != null && professionName!.isNotEmpty && professionName != 'الكل') ||
      (gender != null && gender!.isNotEmpty && gender != 'الكل') ||
      isValidPassport != null ||
      experienceLevelId != null ||
      (experienceYears != null && experienceYears!.isNotEmpty) ||
      qualificationId != null;

  int get activeFilterCount {
    int count = 0;
    if (countryId != null || (countryName != null && countryName!.isNotEmpty && countryName != 'الكل')) count++;
    if (professionId != null || (professionName != null && professionName!.isNotEmpty && professionName != 'الكل')) count++;
    if (gender != null && gender!.isNotEmpty && gender != 'الكل') count++;
    if (isValidPassport != null) count++;
    if (experienceLevelId != null || (experienceYears != null && experienceYears!.isNotEmpty)) count++;
    if (qualificationId != null) count++;
    return count;
  }

  CandidateSearchFilterEntity copyWith({
    String? searchQuery,
    int? countryId,
    String? countryName,
    int? professionId,
    String? professionName,
    String? gender,
    bool? isValidPassport,
    int? experienceLevelId,
    String? experienceYears,
    int? qualificationId,
    bool resetCountry = false,
    bool resetProfession = false,
    bool resetGender = false,
    bool resetPassport = false,
    bool resetExperience = false,
    bool resetQualification = false,
  }) {
    return CandidateSearchFilterEntity(
      searchQuery: searchQuery ?? this.searchQuery,
      countryId: resetCountry ? null : (countryId ?? this.countryId),
      countryName: resetCountry ? null : (countryName ?? this.countryName),
      professionId: resetProfession ? null : (professionId ?? this.professionId),
      professionName: resetProfession ? null : (professionName ?? this.professionName),
      gender: resetGender ? null : (gender ?? this.gender),
      isValidPassport: resetPassport ? null : (isValidPassport ?? this.isValidPassport),
      experienceLevelId: resetExperience ? null : (experienceLevelId ?? this.experienceLevelId),
      experienceYears: resetExperience ? null : (experienceYears ?? this.experienceYears),
      qualificationId: resetQualification ? null : (qualificationId ?? this.qualificationId),
    );
  }

  Map<String, dynamic> toFilterQueryParams() {
    final params = <String, dynamic>{};
    if (searchQuery.trim().isNotEmpty) {
      params['keyword'] = searchQuery.trim();
      params['search'] = searchQuery.trim();
      params['q'] = searchQuery.trim();
    }
    if (countryId != null) {
      params['country_id'] = countryId;
    }
    if (countryName != null && countryName!.isNotEmpty && countryName != 'الكل') {
      params['country'] = countryName;
    }
    if (professionId != null) {
      params['profession_id'] = professionId;
    }
    if (professionName != null && professionName!.isNotEmpty && professionName != 'الكل') {
      params['profession'] = professionName;
    }
    if (gender != null && gender!.isNotEmpty && gender != 'الكل') {
      params['gender'] = gender;
      if (gender == 'ذكر' || gender == 'male') {
        params['gender_id'] = 1;
      } else if (gender == 'أنثى' || gender == 'female') {
        params['gender_id'] = 2;
      }
    }
    if (isValidPassport != null) {
      params['passport_status'] = isValidPassport! ? 1 : 0;
      params['is_valid_passport'] = isValidPassport! ? 1 : 0;
      params['has_passport'] = isValidPassport! ? 1 : 0;
    }
    if (experienceLevelId != null) {
      params['experience_level_id'] = experienceLevelId;
    }
    if (qualificationId != null) {
      params['qualification_id'] = qualificationId;
    }
    return params;
  }

  @override
  List<Object?> get props => [
        searchQuery,
        countryId,
        countryName,
        professionId,
        professionName,
        gender,
        isValidPassport,
        experienceLevelId,
        experienceYears,
        qualificationId,
      ];
}
