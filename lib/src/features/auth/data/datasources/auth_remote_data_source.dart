import 'package:m_kemet/src/core/error/exceptions.dart';
import 'package:m_kemet/src/core/network/api_endpoints.dart';
import 'package:m_kemet/src/core/network/dio_client.dart';
import 'package:m_kemet/src/features/auth/data/models/auth_response_model.dart';
import 'package:m_kemet/src/features/auth/data/models/country_model.dart';
import 'package:m_kemet/src/features/auth/data/models/gender_model.dart';
import 'package:m_kemet/src/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> registerCandidate({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
    required int currentCountryId,
    required String birthDate,
    required int genderId,
  });

  Future<AuthResponseModel> registerCompany({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String passwordConfirmation,
  });

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  Future<AuthResponseModel> verifyOtp({
    required String email,
    required String code,
  });

  Future<String> resendOtp({
    required String email,
  });

  Future<String> forgotPassword({
    required String email,
  });

  Future<String> verifyResetOtp({
    required String email,
    required String code,
  });

  Future<String> resetPassword({
    required String email,
    required String code,
    required String password,
    required String passwordConfirmation,
  });

  Future<UserModel> getProfile();

  Future<void> logout();

  Future<void> logoutAll();

  Future<AuthResponseModel> refreshToken({
    required String refreshToken,
  });

  Future<List<GenderModel>> fetchGenders();

  Future<List<CountryModel>> fetchCountries();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<AuthResponseModel> registerCandidate({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
    required int currentCountryId,
    required String birthDate,
    required int genderId,
  }) async {
    final response = await _dioClient.dio.post(
      ApiEndpoints.registerCandidate,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'current_country_id': currentCountryId,
        'birth_date': birthDate,
        'gender_id': genderId,
      },
    );

    if (response.data is Map<String, dynamic>) {
      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw const ServerException(500, 'Invalid response from server', null);
  }

  @override
  Future<AuthResponseModel> registerCompany({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _dioClient.dio.post(
      ApiEndpoints.registerCompany,
      data: {
        'company_name': name,
        'name': name,
        'phone': phone,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );

    if (response.data is Map<String, dynamic>) {
      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw const ServerException(500, 'Invalid response from server', null);
  }

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dioClient.dio.post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    if (response.data is Map<String, dynamic>) {
      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw const ServerException(500, 'Invalid response from server', null);
  }

  @override
  Future<AuthResponseModel> verifyOtp({
    required String email,
    required String code,
  }) async {
    final response = await _dioClient.dio.post(
      ApiEndpoints.verifyOtp,
      data: {
        'email': email,
        'code': code,
      },
    );

    if (response.data is Map<String, dynamic>) {
      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw const ServerException(500, 'Invalid response from server', null);
  }

  @override
  Future<String> resendOtp({
    required String email,
  }) async {
    final response = await _dioClient.dio.post(
      ApiEndpoints.resendOtp,
      data: {
        'email': email,
      },
    );

    if (response.data is Map<String, dynamic>) {
      return response.data['message']?.toString() ?? 'OTP resent successfully';
    }
    return 'OTP resent successfully';
  }

  @override
  Future<String> forgotPassword({
    required String email,
  }) async {
    final response = await _dioClient.dio.post(
      ApiEndpoints.forgotPassword,
      data: {
        'email': email,
      },
    );

    if (response.data is Map<String, dynamic>) {
      return response.data['message']?.toString() ?? 'Reset code sent to email';
    }
    return 'Reset code sent to email';
  }

  @override
  Future<String> verifyResetOtp({
    required String email,
    required String code,
  }) async {
    final response = await _dioClient.dio.post(
      ApiEndpoints.verifyResetOtp,
      data: {
        'email': email,
        'code': code,
      },
    );

    if (response.data is Map<String, dynamic>) {
      return response.data['message']?.toString() ?? 'Code verified successfully';
    }
    return 'Code verified successfully';
  }

  @override
  Future<String> resetPassword({
    required String email,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _dioClient.dio.post(
      ApiEndpoints.resetPassword,
      data: {
        'email': email,
        'code': code,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );

    if (response.data is Map<String, dynamic>) {
      return response.data['message']?.toString() ?? 'Password reset successfully';
    }
    return 'Password reset successfully';
  }

  @override
  Future<UserModel> getProfile() async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.profile,
    );

    if (response.data is Map<String, dynamic>) {
      final map = response.data as Map<String, dynamic>;
      final data = map['data'];
      final Map<String, dynamic> userMap;
      if (data is Map<String, dynamic>) {
        if (data['user'] is Map<String, dynamic>) {
          userMap = data['user'] as Map<String, dynamic>;
        } else {
          userMap = data;
        }
      } else if (map['user'] is Map<String, dynamic>) {
        userMap = map['user'] as Map<String, dynamic>;
      } else {
        userMap = map;
      }
      return UserModel.fromJson(userMap);
    }
    throw const ServerException(500, 'Invalid response from server', null);
  }

  @override
  Future<void> logout() async {
    await _dioClient.dio.post(ApiEndpoints.logout);
  }

  @override
  Future<void> logoutAll() async {
    await _dioClient.dio.post(ApiEndpoints.logoutAll);
  }

  @override
  Future<AuthResponseModel> refreshToken({
    required String refreshToken,
  }) async {
    final response = await _dioClient.dio.post(
      ApiEndpoints.refreshToken,
      data: {
        'refresh_token': refreshToken,
      },
    );

    if (response.data is Map<String, dynamic>) {
      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw const ServerException(500, 'Invalid response from server', null);
  }

  @override
  Future<List<GenderModel>> fetchGenders() async {
    final response = await _dioClient.dio.get(ApiEndpoints.genders);

    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      final list = data['data'] as List<dynamic>? ?? [];
      return list
          .whereType<Map<String, dynamic>>()
          .map(GenderModel.fromJson)
          .toList();
    }
    throw const ServerException(500, 'Invalid genders response', null);
  }

  @override
  Future<List<CountryModel>> fetchCountries() async {
    final response = await _dioClient.dio.get(ApiEndpoints.countries);

    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      final list = data['data'] as List<dynamic>? ?? [];
      return list
          .whereType<Map<String, dynamic>>()
          .map(CountryModel.fromJson)
          .toList();
    }
    throw const ServerException(500, 'Invalid countries response', null);
  }
}
