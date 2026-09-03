import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:m_kemet/src/core/error/exceptions.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/bookmarks/data/datasources/bookmarks_local_data_source.dart';
import 'package:m_kemet/src/features/bookmarks/data/datasources/bookmarks_remote_data_source.dart';
import 'package:m_kemet/src/features/bookmarks/domain/repositories/bookmarks_repository.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';

class BookmarksRepositoryImpl implements BookmarksRepository {
  final BookmarksRemoteDataSource remoteDataSource;
  final BookmarksLocalDataSource localDataSource;

  BookmarksRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<CandidateEntity>>> getBookmarks() async {
    try {
      final remoteResult = await remoteDataSource.getBookmarks();
      await localDataSource.saveBookmarks(remoteResult);
      return Right(remoteResult);
    } on ServerException catch (e) {
      try {
        final localResult = await localDataSource.getBookmarks();
        if (localResult.isNotEmpty) return Right(localResult);
      } catch (_) {}
      return Left(ServerFailure(e));
    } on DioException catch (e) {
      try {
        final localResult = await localDataSource.getBookmarks();
        if (localResult.isNotEmpty) return Right(localResult);
      } catch (_) {}
      return Left(
        ServerFailure(
          ServerException(
            e.response?.statusCode ?? 500,
            e.response?.data?['message']?.toString() ?? e.message ?? 'Failed to load bookmarks',
            null,
          ),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, CandidateEntity>> toggleBookmark(String candidateId) async {
    try {
      final result = await remoteDataSource.toggleBookmark(candidateId);
      await localDataSource.toggleBookmark(candidateId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          ServerException(
            e.response?.statusCode ?? 500,
            e.response?.data?['message']?.toString() ?? e.message ?? 'Failed to update bookmark',
            null,
          ),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }
}
