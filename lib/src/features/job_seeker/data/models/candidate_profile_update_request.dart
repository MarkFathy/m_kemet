class CandidateProfileUpdateRequest {
  final String? name;
  final String? birthDate;
  final int? genderId;
  final int? currentCountryId;
  final int? qualificationId;
  final String? qualification;
  final String? subSpecialization;
  final int? experienceYears;
  final int? experienceLevelId;
  final num? expectedSalary;
  final List<String>? languages;
  final List<String>? skills;
  final String? summary;
  final int? professionId;
  final List<int>? targetCountryIds;

  const CandidateProfileUpdateRequest({
    this.name,
    this.birthDate,
    this.genderId,
    this.currentCountryId,
    this.qualificationId,
    this.qualification,
    this.subSpecialization,
    this.experienceYears,
    this.experienceLevelId,
    this.expectedSalary,
    this.languages,
    this.skills,
    this.summary,
    this.professionId,
    this.targetCountryIds,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (name != null && name!.isNotEmpty) data['name'] = name;
    if (birthDate != null && birthDate!.isNotEmpty) data['birth_date'] = birthDate;
    if (genderId != null) data['gender_id'] = genderId;
    if (currentCountryId != null) data['current_country_id'] = currentCountryId;
    if (qualificationId != null) data['qualification_id'] = qualificationId;
    if (qualification != null && qualification!.isNotEmpty) data['qualification'] = qualification;
    if (subSpecialization != null && subSpecialization!.isNotEmpty) data['sub_specialization'] = subSpecialization;
    if (experienceYears != null) data['experience_years'] = experienceYears;
    if (experienceLevelId != null) data['experience_level_id'] = experienceLevelId;
    if (expectedSalary != null) data['expected_salary'] = expectedSalary;
    if (languages != null && languages!.isNotEmpty) data['languages'] = languages;
    if (skills != null && skills!.isNotEmpty) data['skills'] = skills;
    if (summary != null && summary!.isNotEmpty) data['summary'] = summary;
    if (professionId != null) data['profession_id'] = professionId;
    if (targetCountryIds != null && targetCountryIds!.isNotEmpty) data['target_country_ids'] = targetCountryIds;
    return data;
  }
}
