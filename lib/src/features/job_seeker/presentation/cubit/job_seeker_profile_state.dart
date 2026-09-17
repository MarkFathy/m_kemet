import 'package:equatable/equatable.dart';
import 'package:m_kemet/src/features/auth/domain/entities/country_entity.dart';
import 'package:m_kemet/src/features/auth/domain/entities/gender_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/candidate_document_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/candidate_profile_detail_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/experience_level_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/profession_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/qualification_entity.dart';

enum DocumentUploadStatus { initial, uploading, success, failure }
enum SubmissionStatus { initial, loading, success, failure }
enum LoadingStatus { initial, loading, success, failure }
enum IdentityDocumentChoice { nationalId, passport, both }

class JobSeekerProfileState extends Equatable {
  // Page load statuses
  final LoadingStatus lookupsStatus;
  final LoadingStatus profileFetchStatus;
  final SubmissionStatus submitStatus;

  // Identity Document Preference
  final IdentityDocumentChoice identityDocumentChoice;

  // Lookups lists
  final List<ProfessionEntity> professions;
  final List<ExperienceLevelEntity> experienceLevels;
  final List<QualificationEntity> qualifications;
  final List<CountryEntity> countries;
  final List<GenderEntity> genders;

  // Selected values in form
  final ProfessionEntity? selectedProfession;
  final ExperienceLevelEntity? selectedExperienceLevel;
  final QualificationEntity? selectedQualification;
  final CountryEntity? selectedCurrentCountry;
  final GenderEntity? selectedGender;
  final List<CountryEntity> selectedTargetCountries;
  final List<String> languages;
  final List<String> skills;

  // Document Uploads
  final DocumentUploadStatus personalPhotoStatus;
  final DocumentUploadStatus nationalIdStatus;
  final DocumentUploadStatus passportStatus;
  final DocumentUploadStatus cvStatus;
  final DocumentUploadStatus videoStatus;
  final double videoUploadProgress;

  final CandidateDocumentEntity? uploadedPersonalPhoto;
  final CandidateDocumentEntity? uploadedNationalId;
  final CandidateDocumentEntity? uploadedPassport;
  final CandidateDocumentEntity? uploadedCv;
  final CandidateDocumentEntity? uploadedVideo;

  final String? localPersonalPhotoPath;
  final String? localNationalIdPath;
  final String? localPassportPath;
  final String? localCvPath;
  final String? localVideoPath;

  // Fetched profile details
  final CandidateProfileDetailEntity? profileDetail;

  // Feedback / Error
  final String? errorMessage;
  final String? successMessage;

  const JobSeekerProfileState({
    this.lookupsStatus = LoadingStatus.initial,
    this.profileFetchStatus = LoadingStatus.initial,
    this.submitStatus = SubmissionStatus.initial,
    this.identityDocumentChoice = IdentityDocumentChoice.nationalId,
    this.professions = const [],
    this.experienceLevels = const [],
    this.qualifications = const [],
    this.countries = const [],
    this.genders = const [],
    this.selectedProfession,
    this.selectedExperienceLevel,
    this.selectedQualification,
    this.selectedCurrentCountry,
    this.selectedGender,
    this.selectedTargetCountries = const [],
    this.languages = const [],
    this.skills = const [],
    this.personalPhotoStatus = DocumentUploadStatus.initial,
    this.nationalIdStatus = DocumentUploadStatus.initial,
    this.passportStatus = DocumentUploadStatus.initial,
    this.cvStatus = DocumentUploadStatus.initial,
    this.videoStatus = DocumentUploadStatus.initial,
    this.videoUploadProgress = 0.0,
    this.uploadedPersonalPhoto,
    this.uploadedNationalId,
    this.uploadedPassport,
    this.uploadedCv,
    this.uploadedVideo,
    this.localPersonalPhotoPath,
    this.localNationalIdPath,
    this.localPassportPath,
    this.localCvPath,
    this.localVideoPath,
    this.profileDetail,
    this.errorMessage,
    this.successMessage,
  });

  bool get isPersonalPhotoUploaded =>
      uploadedPersonalPhoto != null &&
      personalPhotoStatus != DocumentUploadStatus.uploading &&
      personalPhotoStatus != DocumentUploadStatus.failure;

  bool get isNationalIdUploaded =>
      uploadedNationalId != null &&
      nationalIdStatus != DocumentUploadStatus.uploading &&
      nationalIdStatus != DocumentUploadStatus.failure;

  bool get isPassportUploaded =>
      uploadedPassport != null &&
      passportStatus != DocumentUploadStatus.uploading &&
      passportStatus != DocumentUploadStatus.failure;

  bool get isCvUploaded =>
      uploadedCv != null &&
      cvStatus != DocumentUploadStatus.uploading &&
      cvStatus != DocumentUploadStatus.failure;

  bool get isVideoUploaded =>
      ((uploadedVideo != null) ||
          (profileDetail?.videoUrl != null && profileDetail!.videoUrl!.isNotEmpty)) &&
      videoStatus != DocumentUploadStatus.uploading &&
      videoStatus != DocumentUploadStatus.failure;

  bool get isIdentityDocumentUploaded =>
      isNationalIdUploaded || isPassportUploaded;

  bool get isAnyDocumentUploading =>
      personalPhotoStatus == DocumentUploadStatus.uploading ||
      nationalIdStatus == DocumentUploadStatus.uploading ||
      passportStatus == DocumentUploadStatus.uploading ||
      cvStatus == DocumentUploadStatus.uploading ||
      videoStatus == DocumentUploadStatus.uploading;

  bool get areAllDocumentsUploaded =>
      isPersonalPhotoUploaded &&
      isIdentityDocumentUploaded &&
      isCvUploaded &&
      isVideoUploaded &&
      !isAnyDocumentUploading;

  double get completionPercentage {
    int totalPoints = 0;
    int earnedPoints = 0;

    // Professional data fields (worth 6 points)
    totalPoints += 6;
    if (selectedProfession != null) earnedPoints++;
    if (selectedExperienceLevel != null) earnedPoints++;
    if (selectedQualification != null) earnedPoints++;
    if (languages.isNotEmpty) earnedPoints++;
    if (skills.isNotEmpty) earnedPoints++;
    if (selectedTargetCountries.isNotEmpty) earnedPoints++;

    // Document uploads (worth 4 points: photo, identity doc, cv, video)
    totalPoints += 4;
    if (isPersonalPhotoUploaded) earnedPoints++;
    if (isIdentityDocumentUploaded) earnedPoints++;
    if (isCvUploaded) earnedPoints++;
    if (isVideoUploaded) earnedPoints++;

    return totalPoints == 0 ? 0.0 : (earnedPoints / totalPoints).clamp(0.0, 1.0);
  }

  JobSeekerProfileState copyWith({
    LoadingStatus? lookupsStatus,
    LoadingStatus? profileFetchStatus,
    SubmissionStatus? submitStatus,
    IdentityDocumentChoice? identityDocumentChoice,
    List<ProfessionEntity>? professions,
    List<ExperienceLevelEntity>? experienceLevels,
    List<QualificationEntity>? qualifications,
    List<CountryEntity>? countries,
    List<GenderEntity>? genders,
    ProfessionEntity? Function()? selectedProfession,
    ExperienceLevelEntity? Function()? selectedExperienceLevel,
    QualificationEntity? Function()? selectedQualification,
    CountryEntity? Function()? selectedCurrentCountry,
    GenderEntity? Function()? selectedGender,
    List<CountryEntity>? selectedTargetCountries,
    List<String>? languages,
    List<String>? skills,
    DocumentUploadStatus? personalPhotoStatus,
    DocumentUploadStatus? nationalIdStatus,
    DocumentUploadStatus? passportStatus,
    DocumentUploadStatus? cvStatus,
    DocumentUploadStatus? videoStatus,
    double? videoUploadProgress,
    CandidateDocumentEntity? Function()? uploadedPersonalPhoto,
    CandidateDocumentEntity? Function()? uploadedNationalId,
    CandidateDocumentEntity? Function()? uploadedPassport,
    CandidateDocumentEntity? Function()? uploadedCv,
    CandidateDocumentEntity? Function()? uploadedVideo,
    String? Function()? localPersonalPhotoPath,
    String? Function()? localNationalIdPath,
    String? Function()? localPassportPath,
    String? Function()? localCvPath,
    String? Function()? localVideoPath,
    CandidateProfileDetailEntity? Function()? profileDetail,
    String? Function()? errorMessage,
    String? Function()? successMessage,
  }) {
    return JobSeekerProfileState(
      lookupsStatus: lookupsStatus ?? this.lookupsStatus,
      profileFetchStatus: profileFetchStatus ?? this.profileFetchStatus,
      submitStatus: submitStatus ?? this.submitStatus,
      identityDocumentChoice: identityDocumentChoice ?? this.identityDocumentChoice,
      professions: professions ?? this.professions,
      experienceLevels: experienceLevels ?? this.experienceLevels,
      qualifications: qualifications ?? this.qualifications,
      countries: countries ?? this.countries,
      genders: genders ?? this.genders,
      selectedProfession: selectedProfession != null ? selectedProfession() : this.selectedProfession,
      selectedExperienceLevel: selectedExperienceLevel != null ? selectedExperienceLevel() : this.selectedExperienceLevel,
      selectedQualification: selectedQualification != null ? selectedQualification() : this.selectedQualification,
      selectedCurrentCountry: selectedCurrentCountry != null ? selectedCurrentCountry() : this.selectedCurrentCountry,
      selectedGender: selectedGender != null ? selectedGender() : this.selectedGender,
      selectedTargetCountries: selectedTargetCountries ?? this.selectedTargetCountries,
      languages: languages ?? this.languages,
      skills: skills ?? this.skills,
      personalPhotoStatus: personalPhotoStatus ?? this.personalPhotoStatus,
      nationalIdStatus: nationalIdStatus ?? this.nationalIdStatus,
      passportStatus: passportStatus ?? this.passportStatus,
      cvStatus: cvStatus ?? this.cvStatus,
      videoStatus: videoStatus ?? this.videoStatus,
      videoUploadProgress: videoUploadProgress ?? this.videoUploadProgress,
      uploadedPersonalPhoto: uploadedPersonalPhoto != null ? uploadedPersonalPhoto() : this.uploadedPersonalPhoto,
      uploadedNationalId: uploadedNationalId != null ? uploadedNationalId() : this.uploadedNationalId,
      uploadedPassport: uploadedPassport != null ? uploadedPassport() : this.uploadedPassport,
      uploadedCv: uploadedCv != null ? uploadedCv() : this.uploadedCv,
      uploadedVideo: uploadedVideo != null ? uploadedVideo() : this.uploadedVideo,
      localPersonalPhotoPath: localPersonalPhotoPath != null ? localPersonalPhotoPath() : this.localPersonalPhotoPath,
      localNationalIdPath: localNationalIdPath != null ? localNationalIdPath() : this.localNationalIdPath,
      localPassportPath: localPassportPath != null ? localPassportPath() : this.localPassportPath,
      localCvPath: localCvPath != null ? localCvPath() : this.localCvPath,
      localVideoPath: localVideoPath != null ? localVideoPath() : this.localVideoPath,
      profileDetail: profileDetail != null ? profileDetail() : this.profileDetail,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      successMessage: successMessage != null ? successMessage() : this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
        lookupsStatus,
        profileFetchStatus,
        submitStatus,
        identityDocumentChoice,
        professions,
        experienceLevels,
        qualifications,
        countries,
        genders,
        selectedProfession,
        selectedExperienceLevel,
        selectedQualification,
        selectedCurrentCountry,
        selectedGender,
        selectedTargetCountries,
        languages,
        skills,
        personalPhotoStatus,
        nationalIdStatus,
        passportStatus,
        cvStatus,
        videoStatus,
        videoUploadProgress,
        uploadedPersonalPhoto,
        uploadedNationalId,
        uploadedPassport,
        uploadedCv,
        uploadedVideo,
        localPersonalPhotoPath,
        localNationalIdPath,
        localPassportPath,
        localCvPath,
        localVideoPath,
        profileDetail,
        errorMessage,
        successMessage,
      ];
}
