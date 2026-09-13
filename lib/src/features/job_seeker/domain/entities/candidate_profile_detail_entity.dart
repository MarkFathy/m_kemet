import 'package:equatable/equatable.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/candidate_document_entity.dart';

class CandidateProfileDetailEntity extends Equatable {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? birthDate;
  final int? genderId;
  final int? currentCountryId;
  final int? qualificationId;
  final String? qualification;
  final String? subSpecialization;
  final int? experienceYears;
  final int? experienceLevelId;
  final num? expectedSalary;
  final bool? willingToTravel;
  final List<String> languages;
  final List<String> skills;
  final String? summary;
  final int? professionId;
  final List<int> targetCountryIds;
  final List<CandidateDocumentEntity> documents;
  final String? videoUrl;
  final num? completionPercentage;
  final String? status;

  const CandidateProfileDetailEntity({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.birthDate,
    this.genderId,
    this.currentCountryId,
    this.qualificationId,
    this.qualification,
    this.subSpecialization,
    this.experienceYears,
    this.experienceLevelId,
    this.expectedSalary,
    this.willingToTravel,
    this.languages = const [],
    this.skills = const [],
    this.summary,
    this.professionId,
    this.targetCountryIds = const [],
    this.documents = const [],
    this.videoUrl,
    this.completionPercentage,
    this.status,
  });

  /// True if candidate's application was rejected by admin.
  bool get isRejected => status?.toLowerCase().trim() == 'rejected';

  /// Returns true if the candidate has previously filled the form or submitted documents/requests.
  /// NOTE: Rejected candidates are NOT considered completed — they must resubmit.
  bool get hasCompletedOrSubmittedProfile {
    // Rejected users must refill the form
    if (isRejected) return false;
    if (documents.isNotEmpty) return true;
    if (videoUrl != null && videoUrl!.trim().isNotEmpty) return true;
    if (professionId != null || qualificationId != null) return true;
    if (subSpecialization != null && subSpecialization!.trim().isNotEmpty) {
      return true;
    }
    if ((completionPercentage ?? 0) > 0) return true;
    if (status != null &&
        status!.trim().isNotEmpty &&
        status != 'new' &&
        status != 'active' &&
        status != 'inactive' &&
        status != 'unverified') {
      return true;
    }
    return false;
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    birthDate,
    genderId,
    currentCountryId,
    qualificationId,
    qualification,
    subSpecialization,
    experienceYears,
    experienceLevelId,
    expectedSalary,
    willingToTravel,
    languages,
    skills,
    summary,
    professionId,
    targetCountryIds,
    documents,
    videoUrl,
    completionPercentage,
    status,
  ];
}
