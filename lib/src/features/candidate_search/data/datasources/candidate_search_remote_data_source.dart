import 'package:dio/dio.dart';
import 'package:m_kemet/src/core/network/api_endpoints.dart';
import 'package:m_kemet/src/core/network/dio_client.dart';
import 'package:m_kemet/src/features/auth/data/models/country_model.dart';
import 'package:m_kemet/src/features/company/data/models/candidate_model.dart';
import 'package:m_kemet/src/features/candidate_search/domain/entities/candidate_search_filter_entity.dart';
import 'package:m_kemet/src/features/job_seeker/data/models/profession_model.dart';

class PaginatedCandidatesModelResult {
  final List<CandidateModel> candidates;
  final int currentPage;
  final int? lastPage;
  final int? total;
  final bool hasMore;

  const PaginatedCandidatesModelResult({
    required this.candidates,
    required this.currentPage,
    this.lastPage,
    this.total,
    required this.hasMore,
  });
}

abstract class CandidateSearchRemoteDataSource {
  Future<PaginatedCandidatesModelResult> getInitialCandidates({int page = 1, int perPage = 10});
  Future<PaginatedCandidatesModelResult> searchCandidates(String query, {int page = 1, int perPage = 10});
  Future<PaginatedCandidatesModelResult> filterCandidates(CandidateSearchFilterEntity filter, {int page = 1, int perPage = 10});
  Future<List<CountryModel>> getTopCountries();
  Future<List<ProfessionModel>> getPopularProfessions();
}

class CandidateSearchRemoteDataSourceImpl implements CandidateSearchRemoteDataSource {
  final DioClient _dioClient;

  CandidateSearchRemoteDataSourceImpl(this._dioClient);

  PaginatedCandidatesModelResult _parsePaginatedCandidates(
    dynamic data,
    int requestedPage,
    int requestedPerPage,
  ) {
    List<CandidateModel> candidates = [];
    int currentPage = requestedPage;
    int? lastPage;
    int? total;
    bool? hasNextPage;

    if (data is Map<String, dynamic>) {
      // 1. Extract candidates list
      if (data['data'] is List) {
        candidates = (data['data'] as List)
            .map((item) => CandidateModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (data['data'] is Map<String, dynamic> && data['data']['data'] is List) {
        candidates = (data['data']['data'] as List)
            .map((item) => CandidateModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (data['candidates'] is List) {
        candidates = (data['candidates'] as List)
            .map((item) => CandidateModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      // 2. Extract pagination metadata
      final meta = data['meta'] is Map<String, dynamic>
          ? data['meta'] as Map<String, dynamic>
          : (data['data'] is Map<String, dynamic> ? data['data'] as Map<String, dynamic> : data);

      currentPage = int.tryParse(meta['current_page']?.toString() ?? '') ?? requestedPage;
      lastPage = int.tryParse(meta['last_page']?.toString() ?? '');
      total = int.tryParse(meta['total']?.toString() ?? '');

      if (data['links'] is Map<String, dynamic>) {
        hasNextPage = (data['links']['next'] != null);
      } else if (meta['next_page_url'] != null) {
        hasNextPage = true;
      }
    } else if (data is List) {
      candidates = data
          .map((item) => CandidateModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    final bool hasMore;
    if (hasNextPage != null) {
      hasMore = hasNextPage;
    } else if (lastPage != null) {
      hasMore = currentPage < lastPage;
    } else {
      hasMore = candidates.isNotEmpty && candidates.length >= requestedPerPage;
    }

    return PaginatedCandidatesModelResult(
      candidates: candidates,
      currentPage: currentPage,
      lastPage: lastPage,
      total: total,
      hasMore: hasMore,
    );
  }

  @override
  Future<PaginatedCandidatesModelResult> getInitialCandidates({int page = 1, int perPage = 10}) async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.jobSeekers,
      queryParameters: {'page': page, 'per_page': perPage},
    );
    return _parsePaginatedCandidates(response.data, page, perPage);
  }

  @override
  Future<PaginatedCandidatesModelResult> searchCandidates(
    String query, {
    int page = 1,
    int perPage = 10,
  }) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return getInitialCandidates(page: page, perPage: perPage);
    }

    try {
      final response = await _dioClient.dio.get(
        ApiEndpoints.jobSeekersSearch,
        queryParameters: {
          'keyword': trimmed,
          'search': trimmed,
          'q': trimmed,
          'page': page,
          'per_page': perPage,
        },
      );
      return _parsePaginatedCandidates(response.data, page, perPage);
    } on DioException catch (e) {
      // If backend search endpoint 404s or fallback is needed, fallback to /api/job-seekers?search=
      if (e.response?.statusCode == 404) {
        final fallbackResponse = await _dioClient.dio.get(
          ApiEndpoints.jobSeekers,
          queryParameters: {'search': trimmed, 'page': page, 'per_page': perPage},
        );
        return _parsePaginatedCandidates(fallbackResponse.data, page, perPage);
      }
      rethrow;
    }
  }

  @override
  Future<PaginatedCandidatesModelResult> filterCandidates(
    CandidateSearchFilterEntity filter, {
    int page = 1,
    int perPage = 10,
  }) async {
    final queryParams = Map<String, dynamic>.from(filter.toFilterQueryParams());
    queryParams['page'] = page;
    queryParams['per_page'] = perPage;

    if (filter.toFilterQueryParams().isEmpty) {
      return getInitialCandidates(page: page, perPage: perPage);
    }

    try {
      final response = await _dioClient.dio.get(
        ApiEndpoints.jobSeekersFilter,
        queryParameters: queryParams,
      );
      return _parsePaginatedCandidates(response.data, page, perPage);
    } on DioException catch (e) {
      // If backend filter endpoint 404s, fallback to /api/job-seekers with query parameters
      if (e.response?.statusCode == 404) {
        final fallbackResponse = await _dioClient.dio.get(
          ApiEndpoints.jobSeekers,
          queryParameters: queryParams,
        );
        return _parsePaginatedCandidates(fallbackResponse.data, page, perPage);
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
