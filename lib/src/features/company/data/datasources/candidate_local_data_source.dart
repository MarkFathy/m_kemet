import 'package:m_kemet/src/core/helpers/cache_service.dart';
import 'package:m_kemet/src/features/company/data/models/candidate_model.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_filter_entity.dart';

abstract class CandidateLocalDataSource {
  Future<List<CandidateModel>> getCandidates();
  Future<List<CandidateModel>> filterCandidates(CandidateFilterEntity filter);
  Future<List<CandidateModel>> getSavedCandidates();
  Future<CandidateModel> toggleSaveCandidate(String candidateId);

  bool isCandidateContactRequested(String identifier);
  String? getCachedContactStatus(String identifier);
  Future<void> cacheCandidateContactRequest(String identifier, String statusLabel);
  Future<void> clearCandidateContactRequestCache(String identifier);
}

class CandidateLocalDataSourceImpl implements CandidateLocalDataSource {
  static const String _requestedCandidatesKey = 'cached_contact_requested_candidate_ids';
  static const String _contactStatusPrefix = 'cached_contact_status_';

  static String _normalizeArabic(String text) {
    return text
        .trim()
        .toLowerCase()
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي')
        .replaceAll('ـ', '')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

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

  @override
  bool isCandidateContactRequested(String identifier) {
    try {
      if (identifier.trim().isEmpty) return false;
      final cached = CacheStorage.read(_requestedCandidatesKey);
      if (cached is List) {
        final clean = _normalizeArabic(identifier);
        return cached.any(
          (e) => _normalizeArabic(e.toString()) == clean || e.toString() == identifier.trim(),
        );
      }
    } catch (_) {}
    return false;
  }

  @override
  String? getCachedContactStatus(String identifier) {
    try {
      if (identifier.trim().isEmpty) return null;
      final val = CacheStorage.read('$_contactStatusPrefix${identifier.trim()}');
      return val?.toString();
    } catch (_) {}
    return null;
  }

  @override
  Future<void> cacheCandidateContactRequest(String identifier, String statusLabel) async {
    try {
      final clean = identifier.trim();
      if (clean.isEmpty) return;
      final cached = CacheStorage.read(_requestedCandidatesKey);
      List<String> list = [];
      if (cached is List) {
        list = cached.map((e) => e.toString()).toList();
      }
      if (!list.contains(clean)) {
        list.add(clean);
        await CacheStorage.write(_requestedCandidatesKey, list);
      }
      await CacheStorage.write('$_contactStatusPrefix$clean', statusLabel);
    } catch (_) {}
  }

  @override
  Future<void> clearCandidateContactRequestCache(String identifier) async {
    try {
      final clean = identifier.trim();
      if (clean.isEmpty) return;
      final cached = CacheStorage.read(_requestedCandidatesKey);
      if (cached is List) {
        final norm = _normalizeArabic(clean);
        final list = cached.map((e) => e.toString()).toList();
        list.removeWhere((e) => _normalizeArabic(e) == norm || e.trim() == clean);
        await CacheStorage.write(_requestedCandidatesKey, list);
      }
      await CacheStorage.delete('$_contactStatusPrefix$clean');
    } catch (_) {}
  }
}
