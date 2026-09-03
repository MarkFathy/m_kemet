import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/job_seeker/data/models/candidate_profile_update_request.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/candidate_profile_detail_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/repositories/job_seeker_repository.dart';

class UpdateCandidateProfileUseCase {
  final JobSeekerRepository repository;

  UpdateCandidateProfileUseCase(this.repository);

  Future<Either<Failure, CandidateProfileDetailEntity>> call(
    CandidateProfileUpdateRequest request,
  ) {
    return repository.updateCandidateProfile(request);
  }
}
