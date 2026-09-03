import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_filter_entity.dart';

abstract class CandidateRepository {
  Future<Either<Failure, List<CandidateEntity>>> getCandidates();
  Future<Either<Failure, List<CandidateEntity>>> filterCandidates(CandidateFilterEntity filter);
  Future<Either<Failure, List<CandidateEntity>>> getSavedCandidates();
  Future<Either<Failure, CandidateEntity>> toggleSaveCandidate(String candidateId);
  Future<Either<Failure, CandidateEntity>> getCandidateDetail(String candidateId);
  Future<Either<Failure, Map<String, dynamic>>> sendContactRequest(String candidateId);
}
