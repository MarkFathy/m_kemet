import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/exceptions.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/company/data/datasources/candidate_local_data_source.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_filter_entity.dart';
import 'package:m_kemet/src/features/company/domain/repositories/candidate_repository.dart';

class CandidateRepositoryImpl implements CandidateRepository {
  final CandidateLocalDataSource localDataSource;

  CandidateRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<CandidateEntity>>> getCandidates() async {
    try {
      final result = await localDataSource.getCandidates();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, List<CandidateEntity>>> filterCandidates(CandidateFilterEntity filter) async {
    try {
      final result = await localDataSource.filterCandidates(filter);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, List<CandidateEntity>>> getSavedCandidates() async {
    try {
      final result = await localDataSource.getSavedCandidates();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, CandidateEntity>> toggleSaveCandidate(String candidateId) async {
    try {
      final result = await localDataSource.toggleSaveCandidate(candidateId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }
}
