import 'package:m_kemet/src/core/error/exceptions.dart';
import 'package:m_kemet/src/core/network/api_endpoints.dart';
import 'package:m_kemet/src/core/network/dio_client.dart';
import 'package:m_kemet/src/features/company/data/models/candidate_model.dart';
import 'package:m_kemet/src/features/company/data/models/company_contact_request_model.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_filter_entity.dart';

abstract class CandidateRemoteDataSource {
  Future<List<CandidateModel>> getCandidates({String? search});
  Future<List<CandidateModel>> filterCandidates(CandidateFilterEntity filter);
  Future<List<CandidateModel>> getSavedCandidates();
  Future<CandidateModel> toggleSaveCandidate(String candidateId);
  Future<CandidateModel> getCandidateDetail(String candidateId);
  Future<Map<String, dynamic>> sendContactRequest(String candidateId);
  Future<List<CompanyContactRequestModel>> getCompanyContactRequests();
}

class CandidateRemoteDataSourceImpl implements CandidateRemoteDataSource {
  final DioClient _dioClient;

  CandidateRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<CandidateModel>> getCandidates({String? search}) async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.jobSeekers,
      queryParameters: search != null && search.trim().isNotEmpty
          ? {'search': search.trim()}
          : null,
    );

    if (response.data is Map<String, dynamic>) {
      final rawData = response.data['data'];
      if (rawData is List) {
        final models = rawData
            .map((item) => CandidateModel.fromJson(item as Map<String, dynamic>))
            .toList();

        // If candidate list response lacks experience_level and has 0 years,
        // enrich from detail endpoint in parallel so list card matches profile exactly
        return await Future.wait(
          models.map((model) async {
            if (model.experienceYears.isEmpty) {
              try {
                final detail = await getCandidateDetail(model.id);
                if (detail.experienceYears.isNotEmpty) {
                  return CandidateModel.fromEntity(
                    model.copyWith(
                      experienceYears: detail.experienceYears,
                      bio: detail.bio.isNotEmpty ? detail.bio : model.bio,
                      currentCountry: detail.currentCountry.isNotEmpty ? detail.currentCountry : model.currentCountry,
                      targetCountries: detail.targetCountries.isNotEmpty ? detail.targetCountries : model.targetCountries,
                      profession: detail.profession.isNotEmpty ? detail.profession : model.profession,
                    ),
                  );
                }
              } catch (_) {}
            }
            return model;
          }),
        );
      }
    }
    throw const ServerException(500, 'Invalid response from server', null);
  }

  @override
  Future<CandidateModel> getCandidateDetail(String candidateId) async {
    final response = await _dioClient.dio.get('${ApiEndpoints.jobSeekers}/$candidateId');
    if (response.data is Map<String, dynamic>) {
      final data = response.data['data'];
      if (data is Map<String, dynamic>) {
        final Map<String, dynamic> candidateJson = data['candidate'] is Map<String, dynamic>
            ? Map<String, dynamic>.from(data['candidate'] as Map)
            : Map<String, dynamic>.from(data);

        // Merge root-level contact request information if present
        for (final key in [
          'contact_request',
          'has_contact_request',
          'is_contact_requested',
          'already_sent',
          'application',
          'can_contact',
          'can_send_contact_request',
          'status',
          'status_label',
          'contact_request_status'
        ]) {
          if (data.containsKey(key) && !candidateJson.containsKey(key)) {
            candidateJson[key] = data[key];
          }
        }
        return CandidateModel.fromJson(candidateJson);
      }
    }
    throw const ServerException(500, 'Invalid response from server', null);
  }

  @override
  Future<List<CandidateModel>> filterCandidates(CandidateFilterEntity filter) async {
    return getCandidates(search: filter.searchQuery);
  }

  @override
  Future<List<CandidateModel>> getSavedCandidates() async {
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
                final detail = await getCandidateDetail(model.id);
                if (detail.experienceYears.isNotEmpty) {
                  return CandidateModel.fromEntity(
                    model.copyWith(
                      experienceYears: detail.experienceYears,
                      bio: detail.bio.isNotEmpty ? detail.bio : model.bio,
                      currentCountry: detail.currentCountry.isNotEmpty ? detail.currentCountry : model.currentCountry,
                      targetCountries: detail.targetCountries.isNotEmpty ? detail.targetCountries : model.targetCountries,
                      profession: detail.profession.isNotEmpty ? detail.profession : model.profession,
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
  Future<CandidateModel> toggleSaveCandidate(String candidateId) async {
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

  @override
  Future<Map<String, dynamic>> sendContactRequest(String candidateId) async {
    final response = await _dioClient.dio.post(
      ApiEndpoints.jobSeekerContactRequest(candidateId),
    );
    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    }
    throw const ServerException(500, 'Invalid response from server', null);
  }

  @override
  Future<List<CompanyContactRequestModel>> getCompanyContactRequests() async {
    final response = await _dioClient.dio.get(ApiEndpoints.myRequests);
    if (response.data is Map<String, dynamic>) {
      final rawData = response.data['data'];
      if (rawData is List) {
        return rawData
            .map((item) => CompanyContactRequestModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    }
    return [];
  }
}
