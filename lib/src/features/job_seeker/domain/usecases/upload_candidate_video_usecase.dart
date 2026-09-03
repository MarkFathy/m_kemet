import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/candidate_document_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/repositories/job_seeker_repository.dart';

class UploadCandidateVideoUseCase {
  final JobSeekerRepository repository;

  UploadCandidateVideoUseCase(this.repository);

  Future<Either<Failure, CandidateDocumentEntity>> call({
    required File videoFile,
    int? durationSeconds,
    void Function(int sent, int total)? onSendProgress,
  }) {
    return repository.uploadIntroVideo(
      videoFile: videoFile,
      durationSeconds: durationSeconds,
      onSendProgress: onSendProgress,
    );
  }
}
