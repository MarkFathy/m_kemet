import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/auth/domain/entities/country_entity.dart';
import 'package:m_kemet/src/features/auth/domain/entities/gender_entity.dart';
import 'package:m_kemet/src/features/job_seeker/data/models/candidate_profile_update_request.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/candidate_document_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/candidate_profile_detail_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/experience_level_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/profession_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/qualification_entity.dart';

import 'package:m_kemet/src/features/job_seeker/data/models/contact_request_model.dart';

abstract class JobSeekerRepository {
  Future<Either<Failure, List<ProfessionEntity>>> getProfessions();
  Future<Either<Failure, List<ExperienceLevelEntity>>> getExperienceLevels();
  Future<Either<Failure, List<QualificationEntity>>> getQualifications();
  Future<Either<Failure, List<CountryEntity>>> getCountries();
  Future<Either<Failure, List<GenderEntity>>> getGenders();
  Future<Either<Failure, CandidateProfileDetailEntity>> getCandidateProfile();
  Future<Either<Failure, CandidateProfileDetailEntity>> updateCandidateProfile(
    CandidateProfileUpdateRequest request,
  );
  Future<Either<Failure, List<ContactRequestModel>>> getMyContactRequests();
  Future<Either<Failure, CandidateDocumentEntity>> uploadDocument({
    required String documentType,
    required File file,
    void Function(int sent, int total)? onSendProgress,
  });
  Future<Either<Failure, CandidateDocumentEntity>> uploadIntroVideo({
    required File videoFile,
    int? durationSeconds,
    void Function(int sent, int total)? onSendProgress,
  });
}
