import 'package:m_kemet/src/features/job_seeker/domain/entities/job_seeker_profile_entity.dart';

/// Defines the contract for job seeker data operations.
/// Implemented in the data layer.
abstract class JobSeekerRepository {
  Future<JobSeekerProfileEntity?> getProfile(String userId);
  Future<void> saveProfile(JobSeekerProfileEntity profile);
  Future<void> submitProfileForReview(String userId);
}
