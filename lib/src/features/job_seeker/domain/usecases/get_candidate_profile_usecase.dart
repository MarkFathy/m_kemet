import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/candidate_profile_detail_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/repositories/job_seeker_repository.dart';

class GetCandidateProfileUseCase {
  final JobSeekerRepository repository;

  GetCandidateProfileUseCase(this.repository);

  Future<Either<Failure, CandidateProfileDetailEntity>> call() {
    return repository.getCandidateProfile();
  }
}
