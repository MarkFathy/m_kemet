import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/core/usecases/usecase.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';
import 'package:m_kemet/src/features/bookmarks/domain/repositories/bookmarks_repository.dart';

class GetBookmarksUseCase extends BaseUseCase<List<CandidateEntity>, NoParams> {
  final BookmarksRepository repository;

  GetBookmarksUseCase(this.repository);

  @override
  Future<Either<Failure, List<CandidateEntity>>> call(NoParams params) async {
    return await repository.getBookmarks();
  }
}
