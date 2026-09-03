import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/candidate_document_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/repositories/job_seeker_repository.dart';

class UploadCandidateDocumentUseCase {
  final JobSeekerRepository repository;

  UploadCandidateDocumentUseCase(this.repository);

  Future<Either<Failure, CandidateDocumentEntity>> call({
    required String documentType,
    required File file,
    void Function(int sent, int total)? onSendProgress,
  }) {
    return repository.uploadDocument(
      documentType: documentType,
      file: file,
      onSendProgress: onSendProgress,
    );
  }
}
