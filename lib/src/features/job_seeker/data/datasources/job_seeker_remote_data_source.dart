import 'dart:io';
import 'package:dio/dio.dart';
import 'package:m_kemet/src/core/error/exceptions.dart';
import 'package:m_kemet/src/core/network/api_endpoints.dart';
import 'package:m_kemet/src/core/network/dio_client.dart';
import 'package:m_kemet/src/features/auth/data/models/country_model.dart';
import 'package:m_kemet/src/features/auth/data/models/gender_model.dart';
import 'package:m_kemet/src/features/job_seeker/data/models/candidate_document_model.dart';
import 'package:m_kemet/src/features/job_seeker/data/models/candidate_profile_detail_model.dart';
import 'package:m_kemet/src/features/job_seeker/data/models/candidate_profile_update_request.dart';
import 'package:m_kemet/src/features/job_seeker/data/models/contact_request_model.dart';
import 'package:m_kemet/src/features/job_seeker/data/models/experience_level_model.dart';
import 'package:m_kemet/src/features/job_seeker/data/models/profession_model.dart';
import 'package:m_kemet/src/features/job_seeker/data/models/qualification_model.dart';

abstract class JobSeekerRemoteDataSource {
  Future<List<ProfessionModel>> fetchProfessions();
  Future<List<ExperienceLevelModel>> fetchExperienceLevels();
  Future<List<QualificationModel>> fetchQualifications();
  Future<List<CountryModel>> fetchCountries();
  Future<List<GenderModel>> fetchGenders();
  Future<CandidateProfileDetailModel> fetchCandidateProfile();
  Future<CandidateProfileDetailModel> updateCandidateProfile(CandidateProfileUpdateRequest request);
  Future<List<ContactRequestModel>> fetchMyContactRequests();
  Future<CandidateDocumentModel> uploadDocument({
    required String documentType,
    required File file,
    void Function(int sent, int total)? onSendProgress,
  });
  Future<CandidateDocumentModel> uploadIntroVideo({
    required File videoFile,
    int? durationSeconds,
    void Function(int sent, int total)? onSendProgress,
  });
}

class JobSeekerRemoteDataSourceImpl implements JobSeekerRemoteDataSource {
  final DioClient _dioClient;

  JobSeekerRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<ProfessionModel>> fetchProfessions() async {
    final response = await _dioClient.dio.get(ApiEndpoints.professions);
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
  }

  @override
  Future<List<ExperienceLevelModel>> fetchExperienceLevels() async {
    final response = await _dioClient.dio.get(ApiEndpoints.experienceLevels);
    final data = response.data;
    if (data is Map<String, dynamic> && data['data'] is List) {
      return (data['data'] as List)
          .map((item) => ExperienceLevelModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else if (data is List) {
      return data
          .map((item) => ExperienceLevelModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<List<QualificationModel>> fetchQualifications() async {
    final response = await _dioClient.dio.get(ApiEndpoints.qualifications);
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final innerData = data['data'];
      if (innerData is Map<String, dynamic> && innerData['qualifications'] is List) {
        return (innerData['qualifications'] as List)
            .map((item) => QualificationModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (innerData is List) {
        return innerData
            .map((item) => QualificationModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (data['qualifications'] is List) {
        return (data['qualifications'] as List)
            .map((item) => QualificationModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } else if (data is List) {
      return data
          .map((item) => QualificationModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<List<CountryModel>> fetchCountries() async {
    final response = await _dioClient.dio.get(ApiEndpoints.countries);
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
  }

  @override
  Future<List<GenderModel>> fetchGenders() async {
    final response = await _dioClient.dio.get(ApiEndpoints.genders);
    final data = response.data;
    if (data is Map<String, dynamic> && data['data'] is List) {
      return (data['data'] as List)
          .map((item) => GenderModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else if (data is List) {
      return data
          .map((item) => GenderModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<CandidateProfileDetailModel> fetchCandidateProfile() async {
    final response = await _dioClient.dio.get(ApiEndpoints.candidateMyDocument);
    if (response.data is Map<String, dynamic>) {
      return CandidateProfileDetailModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw const ServerException(500, 'Invalid response from server', null);
  }

  @override
  Future<CandidateProfileDetailModel> updateCandidateProfile(CandidateProfileUpdateRequest request) async {
    final response = await _dioClient.dio.put(
      ApiEndpoints.candidateUpdateDocument,
      data: request.toJson(),
    );
    if (response.data is Map<String, dynamic>) {
      return CandidateProfileDetailModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw const ServerException(500, 'Invalid response from server', null);
  }

  @override
  Future<CandidateDocumentModel> uploadDocument({
    required String documentType,
    required File file,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    final fileName = file.path.split(Platform.pathSeparator).last;
    final formData = FormData.fromMap({
      'document_type': documentType,
      'file': await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });

    final response = await _dioClient.dio.post(
      ApiEndpoints.candidateDocuments,
      data: formData,
      options: Options(
        sendTimeout: const Duration(minutes: 5),
        receiveTimeout: const Duration(minutes: 5),
      ),
      onSendProgress: onSendProgress,
    );

    if (response.data is Map<String, dynamic>) {
      final map = response.data as Map<String, dynamic>;
      final docData = map['data'] is Map<String, dynamic> ? map['data'] as Map<String, dynamic> : map;
      return CandidateDocumentModel.fromJson(docData);
    }
    throw const ServerException(500, 'Failed to upload document', null);
  }

  @override
  Future<CandidateDocumentModel> uploadIntroVideo({
    required File videoFile,
    int? durationSeconds,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    final fileName = videoFile.path.split(Platform.pathSeparator).last;
    final mapData = <String, dynamic>{
      'video': await MultipartFile.fromFile(
        videoFile.path,
        filename: fileName,
      ),
    };
    if (durationSeconds != null) {
      mapData['duration_seconds'] = durationSeconds;
    }

    final formData = FormData.fromMap(mapData);

    final response = await _dioClient.dio.post(
      ApiEndpoints.candidateVideo,
      data: formData,
      options: Options(
        sendTimeout: const Duration(minutes: 10),
        receiveTimeout: const Duration(minutes: 10),
      ),
      onSendProgress: onSendProgress,
    );

    if (response.data is Map<String, dynamic>) {
      final map = response.data as Map<String, dynamic>;
      final videoData = map['data'] is Map<String, dynamic> ? map['data'] as Map<String, dynamic> : map;
      return CandidateDocumentModel.fromJson(videoData);
    }
    throw const ServerException(500, 'Failed to upload video', null);
  }

  @override
  Future<List<ContactRequestModel>> fetchMyContactRequests() async {
    final response = await _dioClient.dio.get(ApiEndpoints.myRequests);
    final data = response.data;
    if (data is Map<String, dynamic> && data['data'] is List) {
      return (data['data'] as List)
          .map((item) => ContactRequestModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
