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

  /// Returns true if the candidate has previously submitted documents (e.g. CV) or intro video or profession.
  /// NOTE: Rejected candidates are NOT considered completed — they must resubmit.
  /// NOTE: A newly registered user with only basic info (name/phone/email) is NOT completed.
  bool get hasCompletedOrSubmittedProfile {
    if (isRejected) return false;
    final hasDocs = documents.isNotEmpty;
    final hasVideo = videoUrl != null && videoUrl!.trim().isNotEmpty;
    final hasProfession = professionId != null;
    return hasDocs || hasVideo || hasProfession;
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
