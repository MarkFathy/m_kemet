import 'package:m_kemet/src/features/onboarding/data/models/onboarding_model.dart';

/// Contract for the remote (API) onboarding data source.
///
/// Onboarding pages are currently served locally. When the backend
/// is ready, replace [OnboardingRemoteDataSourceImpl] with a real
/// implementation that fetches pages from the API.
abstract class OnboardingRemoteDataSource {
  /// Fetches onboarding pages content from the remote API.
  Future<List<OnboardingModel>> getOnboardingPages();
}

/// Stub implementation — throws [UnimplementedError].
///
/// TODO: Replace with a real HTTP implementation using [DioClient]
/// when the backend exposes an onboarding content endpoint. Example:
///
/// ```dart
/// class OnboardingRemoteDataSourceImpl implements OnboardingRemoteDataSource {
///   final DioClient dioClient;
///   OnboardingRemoteDataSourceImpl(this.dioClient);
///
///   @override
///   Future<List<OnboardingModel>> getOnboardingPages() async {
///     final response = await dioClient.dio.get('/onboarding/pages');
///     return (response.data['data'] as List)
///         .map((json) => OnboardingModel.fromJson(json as Map<String, dynamic>))
///         .toList();
///   }
/// }
/// ```
class OnboardingRemoteDataSourceImpl implements OnboardingRemoteDataSource {
  @override
  Future<List<OnboardingModel>> getOnboardingPages() {
    throw UnimplementedError('OnboardingRemoteDataSource: backend not wired yet.');
  }
}
