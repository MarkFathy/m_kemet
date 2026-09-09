import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:m_kemet/src/core/error/exceptions.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/auth/domain/entities/country_entity.dart';
import 'package:m_kemet/src/features/candidate_search/data/datasources/candidate_search_remote_data_source.dart';
import 'package:m_kemet/src/features/candidate_search/domain/entities/candidate_search_filter_entity.dart';
import 'package:m_kemet/src/features/candidate_search/domain/repositories/candidate_search_repository.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/profession_entity.dart';

class CandidateSearchRepositoryImpl implements CandidateSearchRepository {
  final CandidateSearchRemoteDataSource remoteDataSource;

  CandidateSearchRepositoryImpl({required this.remoteDataSource});

  Failure _handleDioError(DioException e, String defaultMessage) {
    if (e.response != null && e.response?.data is Map<String, dynamic>) {
      final message = e.response!.data['message']?.toString();
      if (message != null && message.isNotEmpty) {
        return ServerFailure(ServerException(e.response!.statusCode ?? 500, message, null));
      }
    }
    return ServerFailure(ServerException(e.response?.statusCode ?? 500, defaultMessage, null));
  }

  @override
  Future<Either<Failure, List<CandidateEntity>>> getInitialCandidates() async {
    try {
      final result = await remoteDataSource.getInitialCandidates();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } on DioException catch (e) {
      return Left(_handleDioError(e, 'فشل في تحميل المرشحين'));
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, List<CandidateEntity>>> searchCandidates(String query) async {
    try {
      final result = await remoteDataSource.searchCandidates(query);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } on DioException catch (e) {
      return Left(_handleDioError(e, 'فشل في البحث عن المرشحين'));
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, List<CandidateEntity>>> filterCandidates(CandidateSearchFilterEntity filter) async {
    try {
      final result = await remoteDataSource.filterCandidates(filter);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } on DioException catch (e) {
      return Left(_handleDioError(e, 'فشل في تصفية المرشحين'));
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, List<CountryEntity>>> getTopCountries() async {
    try {
      final result = await remoteDataSource.getTopCountries();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } on DioException catch (e) {
      return Left(_handleDioError(e, 'فشل في تحميل قائمة الدول'));
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, List<ProfessionEntity>>> getPopularProfessions() async {
    try {
      final result = await remoteDataSource.getPopularProfessions();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } on DioException catch (e) {
      return Left(_handleDioError(e, 'فشل في تحميل المهن الشائعة'));
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }
}
