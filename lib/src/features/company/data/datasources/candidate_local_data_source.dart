import 'package:m_kemet/src/features/company/data/models/candidate_model.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_filter_entity.dart';

abstract class CandidateLocalDataSource {
  Future<List<CandidateModel>> getCandidates();
  Future<List<CandidateModel>> filterCandidates(CandidateFilterEntity filter);
  Future<List<CandidateModel>> getSavedCandidates();
  Future<CandidateModel> toggleSaveCandidate(String candidateId);
}

class CandidateLocalDataSourceImpl implements CandidateLocalDataSource {
  @override
  Future<List<CandidateModel>> getCandidates() async => const [];

  @override
  Future<List<CandidateModel>> filterCandidates(CandidateFilterEntity filter) async => const [];

  @override
  Future<List<CandidateModel>> getSavedCandidates() async => const [];

  @override
  Future<CandidateModel> toggleSaveCandidate(String candidateId) async {
    return CandidateModel(
      id: candidateId,
      name: '',
      profession: '',
      isSaved: false,
    );
  }
}
