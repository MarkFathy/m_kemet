import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/exceptions.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/auth/domain/entities/country_entity.dart';
import 'package:m_kemet/src/features/auth/domain/entities/gender_entity.dart';
import 'package:m_kemet/src/features/job_seeker/data/datasources/job_seeker_remote_data_source.dart';
import 'package:m_kemet/src/features/job_seeker/data/models/candidate_profile_update_request.dart';
import 'package:m_kemet/src/features/job_seeker/data/models/contact_request_model.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/candidate_document_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/candidate_profile_detail_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/experience_level_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/profession_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/qualification_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/repositories/job_seeker_repository.dart';

class JobSeekerRepositoryImpl implements JobSeekerRepository {
  final JobSeekerRemoteDataSource remoteDataSource;

  JobSeekerRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<ProfessionEntity>>> getProfessions() async {
    try {
      final result = await remoteDataSource.fetchProfessions();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, List<ExperienceLevelEntity>>> getExperienceLevels() async {
    try {
      final result = await remoteDataSource.fetchExperienceLevels();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, List<QualificationEntity>>> getQualifications() async {
    try {
      final result = await remoteDataSource.fetchQualifications();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, List<CountryEntity>>> getCountries() async {
    try {
      final result = await remoteDataSource.fetchCountries();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, List<GenderEntity>>> getGenders() async {
    try {
      final result = await remoteDataSource.fetchGenders();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, CandidateProfileDetailEntity>> getCandidateProfile() async {
    try {
      final result = await remoteDataSource.fetchCandidateProfile();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, CandidateProfileDetailEntity>> updateCandidateProfile(
    CandidateProfileUpdateRequest request,
  ) async {
    try {
      final result = await remoteDataSource.updateCandidateProfile(request);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, CandidateDocumentEntity>> uploadDocument({
    required String documentType,
    required File file,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    try {
      final result = await remoteDataSource.uploadDocument(
        documentType: documentType,
        file: file,
        onSendProgress: onSendProgress,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, CandidateDocumentEntity>> uploadIntroVideo({
    required File videoFile,
    int? durationSeconds,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    try {
      final result = await remoteDataSource.uploadIntroVideo(
        videoFile: videoFile,
        durationSeconds: durationSeconds,
        onSendProgress: onSendProgress,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, List<ContactRequestModel>>> getMyContactRequests() async {
    try {
      final result = await remoteDataSource.fetchMyContactRequests();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }
}
