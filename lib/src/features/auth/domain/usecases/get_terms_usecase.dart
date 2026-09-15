import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/auth/domain/entities/term_entity.dart';
import 'package:m_kemet/src/features/auth/domain/repositories/auth_repository.dart';

class GetTermsUseCase {
  final AuthRepository repository;

  GetTermsUseCase(this.repository);

  Future<Either<Failure, List<TermEntity>>> call() {
    return repository.fetchTerms();
  }
}
