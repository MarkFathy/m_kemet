import 'package:m_kemet/src/core/error/exceptions.dart';
import 'package:m_kemet/src/core/network/api_endpoints.dart';
import 'package:m_kemet/src/core/network/dio_client.dart';
import 'package:m_kemet/src/features/company/data/models/candidate_model.dart';

abstract class BookmarksRemoteDataSource {
  Future<List<CandidateModel>> getBookmarks();
  Future<CandidateModel> toggleBookmark(String candidateId);
}

class BookmarksRemoteDataSourceImpl implements BookmarksRemoteDataSource {
  final DioClient _dioClient;

  BookmarksRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<CandidateModel>> getBookmarks() async {
    final response = await _dioClient.dio.get(ApiEndpoints.bookmarks);
    if (response.data is Map<String, dynamic>) {
      final rawData = response.data['data'];
      if (rawData is List) {
        final models = rawData.map((item) {
          final map = Map<String, dynamic>.from(item as Map);
          map['is_bookmarked'] = true;
          return CandidateModel.fromJson(map);
        }).toList();

        return await Future.wait(
          models.map((model) async {
            if (model.experienceYears.isEmpty) {
              try {
                final detail = await _fetchCandidateDetail(model.id);
                if (detail.experienceYears.isNotEmpty) {
                  return CandidateModel.fromEntity(
                    model.copyWith(
                      experienceYears: detail.experienceYears,
                      bio: detail.bio.isNotEmpty ? detail.bio : model.bio,
                      isSaved: true,
                    ),
                  );
                }
              } catch (_) {}
            }
            return CandidateModel.fromEntity(model.copyWith(isSaved: true));
          }),
        );
      }
    }
    throw const ServerException(500, 'Invalid response from server', null);
  }

  @override
  Future<CandidateModel> toggleBookmark(String candidateId) async {
    final response = await _dioClient.dio.post(
      ApiEndpoints.jobSeekerBookmark(candidateId),
    );

    bool isBookmarked = false;
    if (response.data is Map<String, dynamic>) {
      final data = response.data['data'];
      if (data is Map<String, dynamic> && data['is_bookmarked'] is bool) {
        isBookmarked = data['is_bookmarked'] as bool;
      } else if (response.data['message']?.toString().toLowerCase().contains('added') == true) {
        isBookmarked = true;
      }
    }

    return CandidateModel(
      id: candidateId,
      name: '',
      profession: '',
      isSaved: isBookmarked,
    );
  }

  Future<CandidateModel> _fetchCandidateDetail(String candidateId) async {
    final response = await _dioClient.dio.get('${ApiEndpoints.jobSeekers}/$candidateId');
    if (response.data is Map<String, dynamic>) {
      final data = response.data['data'];
      if (data is Map<String, dynamic>) {
        final candidateJson = data['candidate'] is Map<String, dynamic>
            ? data['candidate'] as Map<String, dynamic>
            : data;
        return CandidateModel.fromJson(candidateJson);
      }
    }
    throw const ServerException(500, 'Failed to fetch candidate details', null);
  }
}
