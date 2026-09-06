import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:m_kemet/src/core/error/exceptions.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/company/data/datasources/candidate_local_data_source.dart';
import 'package:m_kemet/src/features/company/data/datasources/candidate_remote_data_source.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_filter_entity.dart';
import 'package:m_kemet/src/features/company/domain/repositories/candidate_repository.dart';

class CandidateRepositoryImpl implements CandidateRepository {
  final CandidateRemoteDataSource remoteDataSource;
  final CandidateLocalDataSource localDataSource;

  CandidateRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<CandidateEntity>>> getCandidates() async {
    try {
      final result = await remoteDataSource.getCandidates();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } on DioException catch (e) {
      return Left(_handleDioError(e, 'Failed to load job seekers'));
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, List<CandidateEntity>>> filterCandidates(CandidateFilterEntity filter) async {
    try {
      final result = await remoteDataSource.filterCandidates(filter);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } on DioException catch (e) {
      return Left(_handleDioError(e, 'Failed to filter job seekers'));
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, List<CandidateEntity>>> getSavedCandidates() async {
    try {
      final result = await remoteDataSource.getSavedCandidates();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } on DioException catch (e) {
      return Left(_handleDioError(e, 'Failed to load saved candidates'));
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, CandidateEntity>> toggleSaveCandidate(String candidateId) async {
    try {
      final result = await remoteDataSource.toggleSaveCandidate(candidateId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } on DioException catch (e) {
      return Left(_handleDioError(e, 'Failed to update bookmark'));
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, CandidateEntity>> getCandidateDetail(String candidateId) async {
    try {
      final result = await remoteDataSource.getCandidateDetail(candidateId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } on DioException catch (e) {
      return Left(_handleDioError(e, 'Failed to load candidate details'));
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> sendContactRequest(String candidateId) async {
    try {
      final result = await remoteDataSource.sendContactRequest(candidateId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } on DioException catch (e) {
      return Left(_handleDioError(e, 'Failed to send contact request'));
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  ServerFailure _handleDioError(DioException e, String fallbackMessage) {
    if (e.error is ServerException) {
      return ServerFailure(e.error as ServerException);
    }
    final rawMsg = e.response?.data?['message']?.toString() ?? e.message ?? fallbackMessage;
    final lower = rawMsg.toLowerCase();
    final cleanMsg = (lower.contains('failed host lookup') ||
            lower.contains('connection errored') ||
            lower.contains('socketexception') ||
            lower.contains('network is unreachable') ||
            lower.contains('cannot be solved by the library'))
        ? 'لا يوجد اتصال بالإنترنت'
        : rawMsg;
    return ServerFailure(
      ServerException(
        e.response?.statusCode ?? 500,
        cleanMsg,
        null,
      ),
    );
  }
}
