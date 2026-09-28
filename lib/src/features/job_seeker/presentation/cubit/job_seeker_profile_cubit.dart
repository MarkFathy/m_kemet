import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/core/services/session_manager.dart';
import 'package:m_kemet/src/features/auth/domain/entities/country_entity.dart';
import 'package:m_kemet/src/features/auth/domain/entities/gender_entity.dart';
import 'package:m_kemet/src/features/job_seeker/data/models/candidate_profile_update_request.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/candidate_profile_detail_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/experience_level_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/profession_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/qualification_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/usecases/get_candidate_profile_usecase.dart';
import 'package:m_kemet/src/features/job_seeker/domain/usecases/get_job_seeker_lookups_usecase.dart';
import 'package:m_kemet/src/features/job_seeker/domain/usecases/update_candidate_profile_usecase.dart';
import 'package:m_kemet/src/features/job_seeker/domain/usecases/upload_candidate_document_usecase.dart';
import 'package:m_kemet/src/features/job_seeker/domain/usecases/upload_candidate_video_usecase.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/cubit/job_seeker_profile_state.dart';

class JobSeekerProfileCubit extends Cubit<JobSeekerProfileState> {
  final GetJobSeekerLookupsUseCase getJobSeekerLookupsUseCase;
  final GetCandidateProfileUseCase getCandidateProfileUseCase;
  final UpdateCandidateProfileUseCase updateCandidateProfileUseCase;
  final UploadCandidateDocumentUseCase uploadCandidateDocumentUseCase;
  final UploadCandidateVideoUseCase uploadCandidateVideoUseCase;

  JobSeekerProfileCubit({
    required this.getJobSeekerLookupsUseCase,
    required this.getCandidateProfileUseCase,
    required this.updateCandidateProfileUseCase,
    required this.uploadCandidateDocumentUseCase,
    required this.uploadCandidateVideoUseCase,
  }) : super(const JobSeekerProfileState());

  Future<void> loadInitialData() async {
    if (isClosed) return;
    emit(state.copyWith(
      lookupsStatus: LoadingStatus.loading,
      profileFetchStatus: LoadingStatus.loading,
    ));

    // 1. Load Lookups
    final lookupsResult = await getJobSeekerLookupsUseCase();
    if (isClosed) return;
    lookupsResult.fold(
      (failure) {
        if (!isClosed) {
          emit(state.copyWith(
            lookupsStatus: LoadingStatus.failure,
            errorMessage: () => failure.serverException.message,
          ));
        }
      },
      (lookups) {
        if (!isClosed) {
          emit(state.copyWith(
            lookupsStatus: LoadingStatus.success,
            professions: lookups.professions,
            experienceLevels: lookups.experienceLevels,
            qualifications: lookups.qualifications,
            countries: lookups.countries,
            genders: lookups.genders,
          ));
        }
      },
    );

    // 2. Load Existing Candidate Profile
    final profileResult = await getCandidateProfileUseCase();
    if (isClosed) return;
    profileResult.fold(
      (failure) {
        // Profile not found (404) is expected for brand-new registrations.
        // Treat it as success with an empty profile so the form is shown.
        // Only a true network/server error on the lookups shows the error screen.
        if (!isClosed) {
          emit(state.copyWith(
            profileFetchStatus: LoadingStatus.success,
            profileDetail: () => null,
          ));
        }
      },
      (profile) {
        _applyProfile(profile);
      },
    );
  }

  /// Fast, dedicated profile refresher that updates the candidate profile status immediately
  /// without re-requesting all static lookups (professions, countries, etc.).
  Future<void> refreshProfile() async {
    if (isClosed) return;
    final profileResult = await getCandidateProfileUseCase();
    if (isClosed) return;
    profileResult.fold(
      (failure) {
        // Keep current state on error
      },
      (profile) {
        _applyProfile(profile);
      },
    );
  }

  void _applyProfile(CandidateProfileDetailEntity profile) {
    if (isClosed) return;
    ProfessionEntity? selectedProf;
    if (profile.professionId != null) {
      final matched = state.professions.where((p) => p.id == profile.professionId);
      if (matched.isNotEmpty) selectedProf = matched.first;
    }

    ExperienceLevelEntity? selectedExp;
    if (profile.experienceLevelId != null) {
      final matched = state.experienceLevels.where((e) => e.id == profile.experienceLevelId);
      if (matched.isNotEmpty) selectedExp = matched.first;
    }

    QualificationEntity? selectedQual;
    if (profile.qualificationId != null) {
      final matched = state.qualifications.where((q) => q.id == profile.qualificationId);
      if (matched.isNotEmpty) selectedQual = matched.first;
    } else if (profile.qualification != null) {
      final matched = state.qualifications.where((q) => q.name == profile.qualification);
      if (matched.isNotEmpty) selectedQual = matched.first;
    }

    CountryEntity? selectedCountry;
    if (profile.currentCountryId != null) {
      final matched = state.countries.where((c) => c.id == profile.currentCountryId);
      if (matched.isNotEmpty) selectedCountry = matched.first;
    }

    GenderEntity? selectedGen;
    if (profile.genderId != null) {
      final matched = state.genders.where((g) => g.id == profile.genderId);
      if (matched.isNotEmpty) selectedGen = matched.first;
    }

    final List<CountryEntity> selectedTargets = [];
    for (final targetId in profile.targetCountryIds) {
      final matched = state.countries.where((c) => c.id == targetId);
      if (matched.isNotEmpty) selectedTargets.add(matched.first);
    }

    final personalPhoto = profile.documents.where((d) => d.documentType == 'personal_photo').firstOrNull;
    final nationalId = profile.documents.where((d) => d.documentType == 'national_id').firstOrNull;
    final passport = profile.documents.where((d) => d.documentType == 'passport').firstOrNull;
    final cv = profile.documents.where((d) => d.documentType == 'cv').firstOrNull;

    // Auto-detect choice if user already has uploaded documents from previous session
    IdentityDocumentChoice detectedChoice = state.identityDocumentChoice;
    if (nationalId != null && passport != null) {
      detectedChoice = IdentityDocumentChoice.both;
    } else if (passport != null) {
      detectedChoice = IdentityDocumentChoice.passport;
    } else if (nationalId != null) {
      detectedChoice = IdentityDocumentChoice.nationalId;
    }

    emit(state.copyWith(
      profileFetchStatus: LoadingStatus.success,
      profileDetail: () => profile,
      identityDocumentChoice: detectedChoice,
      selectedProfession: () => selectedProf,
      selectedExperienceLevel: () => selectedExp,
      selectedQualification: () => selectedQual,
      selectedCurrentCountry: () => selectedCountry,
      selectedGender: () => selectedGen,
      selectedTargetCountries: selectedTargets,
      languages: profile.languages,
      skills: profile.skills,
      uploadedPersonalPhoto: () => personalPhoto,
      uploadedNationalId: () => nationalId,
      uploadedPassport: () => passport,
      uploadedCv: () => cv,
    ));
  }

  void selectIdentityDocumentChoice(IdentityDocumentChoice choice) {
    emit(state.copyWith(identityDocumentChoice: choice));
  }

  void selectProfession(ProfessionEntity? profession) {
    emit(state.copyWith(selectedProfession: () => profession));
  }

  void selectExperienceLevel(ExperienceLevelEntity? expLevel) {
    emit(state.copyWith(selectedExperienceLevel: () => expLevel));
  }

  void selectQualification(QualificationEntity? qualification) {
    emit(state.copyWith(selectedQualification: () => qualification));
  }

  void selectCurrentCountry(CountryEntity? country) {
    emit(state.copyWith(selectedCurrentCountry: () => country));
  }

  void selectGender(GenderEntity? gender) {
    emit(state.copyWith(selectedGender: () => gender));
  }

  void toggleTargetCountry(CountryEntity country) {
    final updated = List<CountryEntity>.from(state.selectedTargetCountries);
    if (updated.any((c) => c.id == country.id)) {
      updated.removeWhere((c) => c.id == country.id);
    } else {
      updated.add(country);
    }
    emit(state.copyWith(selectedTargetCountries: updated));
  }

  void setLanguages(List<String> languages) {
    emit(state.copyWith(languages: languages));
  }

  void setSkills(List<String> skills) {
    emit(state.copyWith(skills: skills));
  }

  Future<void> uploadPersonalPhoto(File file) async {
    emit(state.copyWith(
      personalPhotoStatus: DocumentUploadStatus.uploading,
      localPersonalPhotoPath: () => file.path,
    ));

    final result = await uploadCandidateDocumentUseCase(
      documentType: 'personal_photo',
      file: file,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          personalPhotoStatus: DocumentUploadStatus.failure,
          uploadedPersonalPhoto: () => null,
          errorMessage: () => failure.serverException.message,
        ));
      },
      (doc) {
        emit(state.copyWith(
          personalPhotoStatus: DocumentUploadStatus.success,
          uploadedPersonalPhoto: () => doc,
          successMessage: () => S.current.uploadPersonalPhotoSuccess,
        ));
      },
    );
  }

  Future<void> uploadNationalId(File file) async {
    emit(state.copyWith(
      nationalIdStatus: DocumentUploadStatus.uploading,
      localNationalIdPath: () => file.path,
    ));

    final result = await uploadCandidateDocumentUseCase(
      documentType: 'national_id',
      file: file,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          nationalIdStatus: DocumentUploadStatus.failure,
          uploadedNationalId: () => null,
          errorMessage: () => failure.serverException.message,
        ));
      },
      (doc) {
        emit(state.copyWith(
          nationalIdStatus: DocumentUploadStatus.success,
          uploadedNationalId: () => doc,
          successMessage: () => S.current.uploadNationalIdSuccess,
        ));
      },
    );
  }

  void setPassportUploading() {
    emit(state.copyWith(passportStatus: DocumentUploadStatus.uploading));
  }

  void resetPassportStatus() {
    emit(state.copyWith(
      passportStatus: state.uploadedPassport != null
          ? DocumentUploadStatus.success
          : DocumentUploadStatus.initial,
    ));
  }

  Future<void> uploadPassport(File file) async {
    emit(state.copyWith(
      passportStatus: DocumentUploadStatus.uploading,
      localPassportPath: () => file.path,
    ));

    final result = await uploadCandidateDocumentUseCase(
      documentType: 'passport',
      file: file,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          passportStatus: DocumentUploadStatus.failure,
          uploadedPassport: () => null,
          errorMessage: () => failure.serverException.message,
        ));
      },
      (doc) {
        emit(state.copyWith(
          passportStatus: DocumentUploadStatus.success,
          uploadedPassport: () => doc,
          successMessage: () => S.current.uploadPassportSuccess,
        ));
      },
    );
  }

  Future<void> uploadCv(File file) async {
    emit(state.copyWith(
      cvStatus: DocumentUploadStatus.uploading,
      localCvPath: () => file.path,
    ));

    final result = await uploadCandidateDocumentUseCase(
      documentType: 'cv',
      file: file,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          cvStatus: DocumentUploadStatus.failure,
          uploadedCv: () => null,
          errorMessage: () => failure.serverException.message,
        ));
      },
      (doc) {
        emit(state.copyWith(
          cvStatus: DocumentUploadStatus.success,
          uploadedCv: () => doc,
          successMessage: () => S.current.uploadCvSuccess,
        ));
      },
    );
  }

  Future<void> uploadIntroVideo(File file, {int? durationSeconds}) async {
    emit(state.copyWith(
      videoStatus: DocumentUploadStatus.uploading,
      videoUploadProgress: 0.0,
      localVideoPath: () => file.path,
    ));

    final result = await uploadCandidateVideoUseCase(
      videoFile: file,
      durationSeconds: durationSeconds,
      onSendProgress: (sent, total) {
        if (total > 0) {
          emit(state.copyWith(videoUploadProgress: sent / total));
        }
      },
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          videoStatus: DocumentUploadStatus.failure,
          videoUploadProgress: 0.0,
          uploadedVideo: () => null,
          errorMessage: () => failure.serverException.message,
        ));
      },
      (doc) {
        emit(state.copyWith(
          videoStatus: DocumentUploadStatus.success,
          videoUploadProgress: 1.0,
          uploadedVideo: () => doc,
          successMessage: () => S.current.uploadVideoSuccess,
        ));
      },
    );
  }

  Future<void> submitProfile({
    String? name,
    String? birthDate,
    int? qualificationId,
    String? qualification,
    String? subSpecialization,
    int? experienceYears,
    num? expectedSalary,
    String? summary,
  }) async {
    if (state.isAnyDocumentUploading) {
      emit(state.copyWith(
        errorMessage: () => S.current.waitMediaUploadMsg,
      ));
      return;
    }

    emit(state.copyWith(
      submitStatus: SubmissionStatus.loading,
      errorMessage: () => null,
      successMessage: () => null,
    ));

    final request = CandidateProfileUpdateRequest(
      name: name,
      birthDate: birthDate,
      genderId: state.selectedGender?.id,
      currentCountryId: state.selectedCurrentCountry?.id,
      qualificationId: qualificationId ?? state.selectedQualification?.id,
      qualification: qualification ?? state.selectedQualification?.name,
      subSpecialization: subSpecialization,
      experienceYears: experienceYears,
      experienceLevelId: state.selectedExperienceLevel?.id,
      expectedSalary: expectedSalary,
      languages: state.languages.isNotEmpty ? state.languages : null,
      skills: state.skills.isNotEmpty ? state.skills : null,
      summary: summary,
      professionId: state.selectedProfession?.id,
      targetCountryIds: state.selectedTargetCountries.map((c) => c.id).toList(),
    );

    final result = await updateCandidateProfileUseCase(request);

    result.fold(
      (failure) {
        emit(state.copyWith(
          submitStatus: SubmissionStatus.failure,
          errorMessage: () => failure.serverException.message,
        ));
      },
      (profile) async {
        await SessionManager.setJobSeekerProfileCompleted(true);
        emit(state.copyWith(
          submitStatus: SubmissionStatus.success,
          profileDetail: () => profile,
          successMessage: () => S.current.submitProfileSuccessMsg,
        ));
      },
    );
  }
}
