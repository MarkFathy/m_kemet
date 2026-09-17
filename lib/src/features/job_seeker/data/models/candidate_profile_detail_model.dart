import 'package:m_kemet/src/features/job_seeker/data/models/candidate_document_model.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/candidate_profile_detail_entity.dart';

class CandidateProfileDetailModel extends CandidateProfileDetailEntity {
  const CandidateProfileDetailModel({
    super.id,
    super.name,
    super.email,
    super.phone,
    super.birthDate,
    super.genderId,
    super.currentCountryId,
    super.qualificationId,
    super.qualification,
    super.subSpecialization,
    super.experienceYears,
    super.experienceLevelId,
    super.expectedSalary,
    super.willingToTravel,
    super.languages,
    super.skills,
    super.summary,
    super.professionId,
    super.targetCountryIds,
    super.documents,
    super.videoUrl,
    super.completionPercentage,
    super.status,
  });

  factory CandidateProfileDetailModel.fromJson(Map<String, dynamic> json) {
    final dataMap = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    final profileMap = (dataMap['profile'] is Map<String, dynamic>)
        ? dataMap['profile'] as Map<String, dynamic>
        : ((json['profile'] is Map<String, dynamic>)
            ? json['profile'] as Map<String, dynamic>
            : dataMap);

    int? parseId(dynamic val) {
      if (val == null) return null;
      if (val is int) return val;
      if (val is Map && val['id'] != null) {
        return int.tryParse(val['id'].toString());
      }
      return int.tryParse(val.toString());
    }

    final rawDocs = profileMap['documents'] ?? dataMap['documents'] ?? json['documents'];
    final List<CandidateDocumentModel> parsedDocs = [];
    if (rawDocs is List) {
      for (final doc in rawDocs) {
        if (doc is Map<String, dynamic>) {
          parsedDocs.add(CandidateDocumentModel.fromJson(doc));
        }
      }
    }

    final rawLanguages = profileMap['languages'] ?? dataMap['languages'];
    final List<String> languagesList = [];
    if (rawLanguages is List) {
      languagesList.addAll(rawLanguages.map((e) => e.toString()));
    }

    final rawSkills = profileMap['skills'] ?? dataMap['skills'];
    final List<String> skillsList = [];
    if (rawSkills is List) {
      skillsList.addAll(rawSkills.map((e) => e.toString()));
    }

    final rawTargetCountryIds = profileMap['target_country_ids'] ??
        profileMap['target_countries'] ??
        dataMap['target_country_ids'] ??
        dataMap['target_countries'];
    final List<int> targetCountries = [];
    if (rawTargetCountryIds is List) {
      for (final item in rawTargetCountryIds) {
        final parsed = parseId(item);
        if (parsed != null) targetCountries.add(parsed);
      }
    }

    String? qualName;
    final rawQual = profileMap['qualification'] ?? dataMap['qualification'];
    if (rawQual is Map) {
      qualName = rawQual['name']?.toString();
    } else if (rawQual != null) {
      qualName = rawQual.toString();
    }

    final rawSalary = profileMap['expected_salary'] ?? dataMap['expected_salary'];
    final num? expectedSalary = rawSalary is num
        ? rawSalary
        : num.tryParse(rawSalary?.toString() ?? '');

    final rawTravel = profileMap['willing_to_travel'] ?? dataMap['willing_to_travel'];
    final bool willingToTravel = rawTravel is bool
        ? rawTravel
        : (rawTravel == 1 || rawTravel == '1' || rawTravel == 'true');

    final rawVideo = profileMap['video'] ?? dataMap['video'];
    String? videoUrl = profileMap['video_url']?.toString() ?? dataMap['video_url']?.toString();
    if (videoUrl == null && rawVideo is Map) {
      videoUrl = rawVideo['file_url']?.toString() ??
          rawVideo['url']?.toString() ??
          rawVideo['path']?.toString();
    } else if (videoUrl == null && rawVideo is String) {
      videoUrl = rawVideo;
    }

    final rawPercentage = profileMap['completion_percentage'] ?? dataMap['completion_percentage'];
    final num? completionPercentage = rawPercentage is num
        ? rawPercentage
        : num.tryParse(rawPercentage?.toString() ?? '');

    // Extract candidate application status (do NOT extract API envelope statuses like 'success', 'ok', 'true')
    final rawCandidateStatus = profileMap['request_status'] ??
        profileMap['approval_status'] ??
        profileMap['status'];

    String? candidateStatus;
    if (rawCandidateStatus is String) {
      final s = rawCandidateStatus.toLowerCase().trim();
      if (s != 'success' && s != 'ok' && s != 'true' && s != 'false' && s != 'error' && s != 'fail') {
        candidateStatus = s;
      }
    }

    return CandidateProfileDetailModel(
      id: parseId(profileMap['id'] ?? dataMap['id'] ?? profileMap['user_id'] ?? dataMap['user_id']),
      name: profileMap['name']?.toString() ??
          profileMap['full_name']?.toString() ??
          dataMap['name']?.toString() ??
          dataMap['full_name']?.toString(),
      email: profileMap['email']?.toString() ?? dataMap['email']?.toString(),
      phone: profileMap['phone']?.toString() ?? dataMap['phone']?.toString(),
      birthDate: profileMap['birth_date']?.toString() ?? dataMap['birth_date']?.toString(),
      genderId: parseId(profileMap['gender_id'] ?? profileMap['gender'] ?? dataMap['gender_id'] ?? dataMap['gender']),
      currentCountryId: parseId(profileMap['current_country_id'] ??
          profileMap['current_country'] ??
          dataMap['current_country_id'] ??
          dataMap['current_country']),
      qualificationId: parseId(profileMap['qualification_id'] ??
          profileMap['qualification'] ??
          dataMap['qualification_id'] ??
          dataMap['qualification']),
      qualification: qualName,
      subSpecialization: profileMap['sub_specialization']?.toString() ??
          profileMap['specialization']?.toString() ??
          dataMap['sub_specialization']?.toString() ??
          dataMap['specialization']?.toString(),
      experienceYears: parseId(profileMap['experience_years'] ?? dataMap['experience_years']),
      experienceLevelId: parseId(profileMap['experience_level_id'] ??
          profileMap['experience_level'] ??
          dataMap['experience_level_id'] ??
          dataMap['experience_level']),
      expectedSalary: expectedSalary,
      willingToTravel: willingToTravel,
      languages: languagesList,
      skills: skillsList,
      summary: profileMap['summary']?.toString() ??
          profileMap['previous_experience']?.toString() ??
          dataMap['summary']?.toString() ??
          dataMap['previous_experience']?.toString(),
      professionId: parseId(profileMap['profession_id'] ??
          profileMap['profession'] ??
          dataMap['profession_id'] ??
          dataMap['profession']),
      targetCountryIds: targetCountries,
      documents: parsedDocs,
      videoUrl: videoUrl,
      completionPercentage: completionPercentage,
      status: candidateStatus,
    );
  }
}
