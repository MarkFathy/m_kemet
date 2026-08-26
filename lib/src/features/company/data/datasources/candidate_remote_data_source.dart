import 'package:m_kemet/src/features/company/data/models/candidate_model.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_filter_entity.dart';

/// Contract for the remote (API) candidate data source.
///
/// Replace [CandidateRemoteDataSourceImpl] with a real implementation
/// once the backend endpoints are ready. The [CandidateRepositoryImpl]
/// will automatically use the remote source without any other changes.
abstract class CandidateRemoteDataSource {
  Future<List<CandidateModel>> getCandidates();
  Future<List<CandidateModel>> filterCandidates(CandidateFilterEntity filter);
  Future<List<CandidateModel>> getSavedCandidates();
  Future<CandidateModel> toggleSaveCandidate(String candidateId);
}

/// Stub implementation — throws [UnimplementedError] on every call.
///
/// TODO: Replace this with the real HTTP implementation using [DioClient]
/// when the backend is ready. Example:
///
/// ```dart
/// class CandidateRemoteDataSourceImpl implements CandidateRemoteDataSource {
///   final DioClient dioClient;
///   CandidateRemoteDataSourceImpl(this.dioClient);
///
///   @override
///   Future<List<CandidateModel>> getCandidates() async {
///     final response = await dioClient.dio.get('/candidates');
///     return (response.data['data'] as List)
///         .map((json) => CandidateModel.fromJson(json as Map<String, dynamic>))
///         .toList();
///   }
///   // ... other methods
/// }
/// ```
class CandidateRemoteDataSourceImpl implements CandidateRemoteDataSource {
  // TODO: Inject DioClient here when backend is ready.
  // final DioClient dioClient;
  // CandidateRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<CandidateModel>> getCandidates() {
    throw UnimplementedError('CandidateRemoteDataSource: backend not wired yet.');
  }

  @override
  Future<List<CandidateModel>> filterCandidates(CandidateFilterEntity filter) {
    throw UnimplementedError('CandidateRemoteDataSource: backend not wired yet.');
  }

  @override
  Future<List<CandidateModel>> getSavedCandidates() {
    throw UnimplementedError('CandidateRemoteDataSource: backend not wired yet.');
  }

  @override
  Future<CandidateModel> toggleSaveCandidate(String candidateId) {
    throw UnimplementedError('CandidateRemoteDataSource: backend not wired yet.');
  }
}
