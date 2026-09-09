import 'package:dio/dio.dart';
import 'package:m_kemet/src/core/network/api_endpoints.dart';
import 'package:m_kemet/src/core/network/dio_client.dart';
import 'package:m_kemet/src/features/auth/data/models/country_model.dart';
import 'package:m_kemet/src/features/company/data/models/candidate_model.dart';
import 'package:m_kemet/src/features/candidate_search/domain/entities/candidate_search_filter_entity.dart';
import 'package:m_kemet/src/features/job_seeker/data/models/profession_model.dart';

abstract class CandidateSearchRemoteDataSource {
  Future<List<CandidateModel>> getInitialCandidates();
  Future<List<CandidateModel>> searchCandidates(String query);
  Future<List<CandidateModel>> filterCandidates(CandidateSearchFilterEntity filter);
  Future<List<CountryModel>> getTopCountries();
  Future<List<ProfessionModel>> getPopularProfessions();
}

class CandidateSearchRemoteDataSourceImpl implements CandidateSearchRemoteDataSource {
  final DioClient _dioClient;

  CandidateSearchRemoteDataSourceImpl(this._dioClient);

  List<CandidateModel> _parseCandidates(dynamic data) {
    if (data is Map<String, dynamic> && data['data'] is List) {
      return (data['data'] as List)
          .map((item) => CandidateModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else if (data is List) {
      return data
          .map((item) => CandidateModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<List<CandidateModel>> getInitialCandidates() async {
    final response = await _dioClient.dio.get(ApiEndpoints.jobSeekers);
    return _parseCandidates(response.data);
  }

  @override
  Future<List<CandidateModel>> searchCandidates(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return getInitialCandidates();
    }

    try {
      final response = await _dioClient.dio.get(
        ApiEndpoints.jobSeekersSearch,
        queryParameters: {'keyword': trimmed, 'search': trimmed, 'q': trimmed},
      );
      return _parseCandidates(response.data);
    } on DioException catch (e) {
      // If backend search endpoint 404s or fallback is needed, fallback to /api/job-seekers?search=
      if (e.response?.statusCode == 404) {
        final fallbackResponse = await _dioClient.dio.get(
          ApiEndpoints.jobSeekers,
          queryParameters: {'search': trimmed},
        );
        return _parseCandidates(fallbackResponse.data);
      }
      rethrow;
    }
  }

  @override
  Future<List<CandidateModel>> filterCandidates(CandidateSearchFilterEntity filter) async {
    final queryParams = filter.toFilterQueryParams();
    if (queryParams.isEmpty) {
      return getInitialCandidates();
    }

    try {
      final response = await _dioClient.dio.get(
        ApiEndpoints.jobSeekersFilter,
        queryParameters: queryParams,
      );
      return _parseCandidates(response.data);
    } on DioException catch (e) {
      // If backend filter endpoint 404s, fallback to /api/job-seekers with query parameters
      if (e.response?.statusCode == 404) {
        final fallbackResponse = await _dioClient.dio.get(
          ApiEndpoints.jobSeekers,
          queryParameters: queryParams,
        );
        return _parseCandidates(fallbackResponse.data);
      }
      rethrow;
    }
  }

  @override
  Future<List<CountryModel>> getTopCountries() async {
    try {
      final response = await _dioClient.dio.get(ApiEndpoints.countriesTop6);
      final data = response.data;
      if (data is Map<String, dynamic> && data['data'] is List) {
        return (data['data'] as List)
            .map((item) => CountryModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (data is List) {
        return data
            .map((item) => CountryModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      // Fallback to /api/countries if top-6 is not yet deployed on test environment
      if (e.response?.statusCode == 404) {
        final fallback = await _dioClient.dio.get(ApiEndpoints.countries);
        final data = fallback.data;
        List<CountryModel> list = [];
        if (data is Map<String, dynamic> && data['data'] is List) {
          list = (data['data'] as List)
              .map((item) => CountryModel.fromJson(item as Map<String, dynamic>))
              .toList();
        } else if (data is List) {
          list = data
              .map((item) => CountryModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return list.take(6).toList();
      }
      rethrow;
    }
  }

  @override
  Future<List<ProfessionModel>> getPopularProfessions() async {
    try {
      final response = await _dioClient.dio.get(ApiEndpoints.professionsPopular);
      final data = response.data;
      if (data is Map<String, dynamic> && data['data'] is List) {
        return (data['data'] as List)
            .map((item) => ProfessionModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (data is List) {
        return data
            .map((item) => ProfessionModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      // Fallback to /api/professions if popular endpoint is not yet deployed
      if (e.response?.statusCode == 404) {
        final fallback = await _dioClient.dio.get(ApiEndpoints.professions);
        final data = fallback.data;
        List<ProfessionModel> list = [];
        if (data is Map<String, dynamic> && data['data'] is List) {
          list = (data['data'] as List)
              .map((item) => ProfessionModel.fromJson(item as Map<String, dynamic>))
              .toList();
        } else if (data is List) {
          list = data
              .map((item) => ProfessionModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return list.take(10).toList();
      }
      rethrow;
    }
  }
}
