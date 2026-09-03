import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/core/usecases/usecase.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';
import 'package:m_kemet/src/features/bookmarks/domain/repositories/bookmarks_repository.dart';

class ToggleBookmarkUseCase extends BaseUseCase<CandidateEntity, String> {
  final BookmarksRepository repository;

  ToggleBookmarkUseCase(this.repository);

  @override
  Future<Either<Failure, CandidateEntity>> call(String candidateId) async {
    return await repository.toggleBookmark(candidateId);
  }
}
