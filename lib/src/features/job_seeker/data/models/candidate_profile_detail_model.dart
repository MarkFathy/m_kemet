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
  });

  factory CandidateProfileDetailModel.fromJson(Map<String, dynamic> json) {
    final candidateData = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    final rawDocs = candidateData['documents'];
    final List<CandidateDocumentModel> parsedDocs = [];
    if (rawDocs is List) {
      for (final doc in rawDocs) {
        if (doc is Map<String, dynamic>) {
          parsedDocs.add(CandidateDocumentModel.fromJson(doc));
        }
      }
    }

    final rawLanguages = candidateData['languages'];
    final List<String> languagesList = [];
    if (rawLanguages is List) {
      languagesList.addAll(rawLanguages.map((e) => e.toString()));
    }

    final rawSkills = candidateData['skills'];
    final List<String> skillsList = [];
    if (rawSkills is List) {
      skillsList.addAll(rawSkills.map((e) => e.toString()));
    }

    final rawTargetCountryIds = candidateData['target_country_ids'];
    final List<int> targetCountries = [];
    if (rawTargetCountryIds is List) {
      for (final item in rawTargetCountryIds) {
        if (item is int) {
          targetCountries.add(item);
        } else if (item is Map && item['id'] is int) {
          targetCountries.add(item['id'] as int);
        } else {
          final parsed = int.tryParse(item.toString());
          if (parsed != null) targetCountries.add(parsed);
        }
      }
    }

    return CandidateProfileDetailModel(
      id: candidateData['id'] is int ? candidateData['id'] as int : int.tryParse(candidateData['id']?.toString() ?? ''),
      name: candidateData['name']?.toString() ?? candidateData['full_name']?.toString(),
      email: candidateData['email']?.toString(),
      phone: candidateData['phone']?.toString(),
      birthDate: candidateData['birth_date']?.toString(),
      genderId: candidateData['gender_id'] is int
          ? candidateData['gender_id'] as int
          : int.tryParse(candidateData['gender_id']?.toString() ?? ''),
      currentCountryId: candidateData['current_country_id'] is int
          ? candidateData['current_country_id'] as int
          : int.tryParse(candidateData['current_country_id']?.toString() ?? ''),
      qualificationId: candidateData['qualification_id'] is int
          ? candidateData['qualification_id'] as int
          : int.tryParse(candidateData['qualification_id']?.toString() ?? ''),
      qualification: candidateData['qualification'] is Map
          ? candidateData['qualification']['name']?.toString()
          : candidateData['qualification']?.toString(),
      subSpecialization: candidateData['sub_specialization']?.toString() ?? candidateData['specialization']?.toString(),
      experienceYears: candidateData['experience_years'] is int
          ? candidateData['experience_years'] as int
          : int.tryParse(candidateData['experience_years']?.toString() ?? ''),
      experienceLevelId: candidateData['experience_level_id'] is int
          ? candidateData['experience_level_id'] as int
          : int.tryParse(candidateData['experience_level_id']?.toString() ?? ''),
      expectedSalary: candidateData['expected_salary'] is num
          ? candidateData['expected_salary'] as num
          : num.tryParse(candidateData['expected_salary']?.toString() ?? ''),
      willingToTravel: candidateData['willing_to_travel'] is bool
          ? candidateData['willing_to_travel'] as bool
          : candidateData['willing_to_travel'] == 1 || candidateData['willing_to_travel'] == '1' || candidateData['willing_to_travel'] == 'true',
      languages: languagesList,
      skills: skillsList,
      summary: candidateData['summary']?.toString() ?? candidateData['previous_experience']?.toString(),
      professionId: candidateData['profession_id'] is int
          ? candidateData['profession_id'] as int
          : int.tryParse(candidateData['profession_id']?.toString() ?? ''),
      targetCountryIds: targetCountries,
      documents: parsedDocs,
      videoUrl: candidateData['video_url']?.toString() ?? candidateData['video']?['file_url']?.toString() ?? candidateData['video']?['url']?.toString(),
      completionPercentage: candidateData['completion_percentage'] is num
          ? candidateData['completion_percentage'] as num
          : num.tryParse(candidateData['completion_percentage']?.toString() ?? ''),
    );
  }
}
