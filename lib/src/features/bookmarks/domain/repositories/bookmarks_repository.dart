import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';

abstract class BookmarksRepository {
  Future<Either<Failure, List<CandidateEntity>>> getBookmarks();
  Future<Either<Failure, CandidateEntity>> toggleBookmark(String candidateId);
}
