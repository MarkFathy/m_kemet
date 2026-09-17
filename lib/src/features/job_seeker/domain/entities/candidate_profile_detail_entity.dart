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

  /// True if candidate's application was approved by admin.
  bool get isApproved => status?.toLowerCase().trim() == 'approved';

  /// True if the candidate has actually submitted the profile form request.
  /// When a candidate registers, their DB record has status='pending' but no profession,
  /// salary, specialization, or summary. They only count as submitted once the form
  /// request has actually been sent to the server.
  bool get isFormSubmitted {
    if (isApproved) return true;
    if (isRejected) return true;

    // A candidate has submitted the form ONLY if the complete form request was sent to the server.
    // The form request submits profession, expected salary, summary, and documents together.
    // Simply uploading a document or having an initial registration record does NOT count.
    final hasCompletedForm = professionId != null &&
        expectedSalary != null &&
        (summary != null && summary!.trim().isNotEmpty) &&
        documents.isNotEmpty;

    return hasCompletedForm;
  }

  /// Returns true only if the candidate has actually submitted the form.
  bool get hasCompletedOrSubmittedProfile => isFormSubmitted;

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
