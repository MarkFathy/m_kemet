import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_kemet/src/core/helpers/cache_service.dart';
import 'package:m_kemet/src/core/services/service_locator/service_locator.dart';
import 'package:m_kemet/src/features/company/data/models/company_contact_request_model.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';
import 'package:m_kemet/src/features/company/domain/usecases/get_candidate_detail_usecase.dart';
import 'package:m_kemet/src/features/company/domain/usecases/get_company_contact_requests_usecase.dart';
import 'package:m_kemet/src/features/company/domain/usecases/send_contact_request_usecase.dart';
import 'package:m_kemet/src/features/company/presentation/cubit/candidate_detail_state.dart';
import 'package:m_kemet/src/features/company/presentation/cubit/company_requests_cubit.dart';

class CandidateDetailCubit extends Cubit<CandidateDetailState> {
  static const String _requestedCandidatesKey = 'cached_contact_requested_candidate_ids';
  static const String _contactStatusPrefix = 'cached_contact_status_';

  final GetCandidateDetailUseCase getCandidateDetailUseCase;
  final SendContactRequestUseCase sendContactRequestUseCase;

  CandidateDetailCubit({
    required this.getCandidateDetailUseCase,
    required this.sendContactRequestUseCase,
    required CandidateEntity initialCandidate,
    bool initialIsBookmarked = false,
  }) : super(CandidateDetailState(
          candidate: initialCandidate.copyWith(isSaved: initialIsBookmarked),
          isContactRequestSent: _isPreviouslyRequested(initialCandidate.id) ||
              (initialCandidate.userId != null &&
                  _isPreviouslyRequested('${initialCandidate.userId}')) ||
              _isPreviouslyRequested(initialCandidate.name) ||
              initialCandidate.isContactRequested,
          contactRequestStatusLabel: _getCachedStatusLabel(initialCandidate.id) ??
              _getCachedStatusLabel(initialCandidate.name) ??
              (initialCandidate.isContactRequested ? 'طلب تواصل قيد الانتظار' : null),
        ));

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

  static bool _isPreviouslyRequested(String identifier) {
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

  static String? _getCachedStatusLabel(String identifier) {
    try {
      if (identifier.trim().isEmpty) return null;
      final val = CacheStorage.read('$_contactStatusPrefix${identifier.trim()}');
      return val?.toString();
    } catch (_) {}
    return null;
  }

  static Future<void> _addToRequestedCache(String identifier, String label) async {
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
      await CacheStorage.write('$_contactStatusPrefix$clean', label);
    } catch (_) {}
  }

  static Future<void> _removeFromRequestedCache(String identifier) async {
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

  Future<void> fetchCandidateDetail() async {
    emit(state.copyWith(status: CandidateDetailStatus.loading));

    final result = await getCandidateDetailUseCase(state.candidate.id);
    result.fold(
      (failure) => emit(state.copyWith(
        status: CandidateDetailStatus.failure,
        errorMessage: failure.serverException.message,
      )),
      (detailedCandidate) async {
        final wasLocallyRequested = _isPreviouslyRequested(state.candidate.id) ||
            (state.candidate.userId != null &&
                _isPreviouslyRequested('${state.candidate.userId}')) ||
            _isPreviouslyRequested(state.candidate.name) ||
            _isPreviouslyRequested(detailedCandidate.name);

        // Check if candidate detail itself contains explicit rejection
        final status = detailedCandidate.contactRequestStatus.toLowerCase();
        final isExplicitlyRejected = status == 'rejected' ||
            status == 'refused' ||
            status == 'declined' ||
            status.contains('مرفوض');

        if (isExplicitlyRejected) {
          await _clearAllCandidateCache(detailedCandidate);
          emit(state.copyWith(
            status: CandidateDetailStatus.success,
            candidate: detailedCandidate.copyWith(isSaved: state.candidate.isSaved),
            isContactRequestSent: false,
            contactRequestStatusLabel: null,
          ));
          return;
        }

        // Check against the actual list of requests from the server (/api/my-requests)
        try {
          final requestsResult = await sl<GetCompanyContactRequestsUseCase>()();
          CompanyContactRequestModel? matchingReq;

          requestsResult.fold((_) {}, (requests) {
            for (final r in requests) {
              if (r.candidate != null && r.candidate!.id == state.candidate.id) {
                matchingReq = r;
                break;
              }
              if (r.candidate != null &&
                  state.candidate.userId != null &&
                  r.candidate!.userId == state.candidate.userId) {
                matchingReq = r;
                break;
              }
              if ('${r.id}' == state.candidate.id) {
                matchingReq = r;
                break;
              }
              if (_normalizeArabic(r.name) == _normalizeArabic(detailedCandidate.name) ||
                  _normalizeArabic(r.name) == _normalizeArabic(state.candidate.name)) {
                matchingReq = r;
                break;
              }
            }

            if (matchingReq != null) {
              final reqStatus = matchingReq!.status.toLowerCase();
              final isReqRejected = reqStatus == 'rejected' ||
                  reqStatus == 'refused' ||
                  reqStatus == 'declined' ||
                  reqStatus.contains('مرفوض');

              if (isReqRejected) {
                // Admin or candidate rejected -> unlock button!
                _clearAllCandidateCache(detailedCandidate);
                emit(state.copyWith(
                  status: CandidateDetailStatus.success,
                  candidate: detailedCandidate.copyWith(isSaved: state.candidate.isSaved),
                  isContactRequestSent: false,
                  contactRequestStatusLabel: null,
                ));
              } else {
                // Request is ACTIVE on the server (pending, approved, etc.) -> keep locked!
                final label = matchingReq!.statusLabel.isNotEmpty
                    ? matchingReq!.statusLabel
                    : 'طلب تواصل قيد الانتظار';
                _saveAllCandidateCache(detailedCandidate, label);
                emit(state.copyWith(
                  status: CandidateDetailStatus.success,
                  candidate: detailedCandidate.copyWith(isSaved: state.candidate.isSaved),
                  isContactRequestSent: true,
                  contactRequestStatusLabel: label,
                ));
              }
            } else {
              // Not in /api/my-requests:
              // If it was previously requested by user, this means the admin DELETED it from the server!
              if (wasLocallyRequested) {
                _clearAllCandidateCache(detailedCandidate);
                emit(state.copyWith(
                  status: CandidateDetailStatus.success,
                  candidate: detailedCandidate.copyWith(isSaved: state.candidate.isSaved),
                  isContactRequestSent: false,
                  contactRequestStatusLabel: null,
                ));
              } else {
                // Never requested
                emit(state.copyWith(
                  status: CandidateDetailStatus.success,
                  candidate: detailedCandidate.copyWith(isSaved: state.candidate.isSaved),
                  isContactRequestSent: false,
                  contactRequestStatusLabel: null,
                ));
              }
            }
          });
          return;
        } catch (_) {}

        // Fallback if requests check could not complete (e.g. offline):
        // Keep the local state so the user cannot duplicate requests
        final isSent = wasLocallyRequested || detailedCandidate.isContactRequested;
        final label = state.contactRequestStatusLabel ??
            _getCachedStatusLabel(state.candidate.id) ??
            _getCachedStatusLabel(state.candidate.name) ??
            'طلب تواصل قيد الانتظار';

        emit(state.copyWith(
          status: CandidateDetailStatus.success,
          candidate: detailedCandidate.copyWith(isSaved: state.candidate.isSaved),
          isContactRequestSent: isSent,
          contactRequestStatusLabel: isSent ? label : null,
        ));
      },
    );
  }

  Future<void> _saveAllCandidateCache(CandidateEntity candidate, String label) async {
    await _addToRequestedCache(state.candidate.id, label);
    await _addToRequestedCache(candidate.id, label);
    await _addToRequestedCache(state.candidate.name, label);
    await _addToRequestedCache(candidate.name, label);
    if (candidate.userId != null) {
      await _addToRequestedCache('${candidate.userId}', label);
    }
  }

  Future<void> _clearAllCandidateCache(CandidateEntity candidate) async {
    await _removeFromRequestedCache(state.candidate.id);
    await _removeFromRequestedCache(candidate.id);
    await _removeFromRequestedCache(state.candidate.name);
    await _removeFromRequestedCache(candidate.name);
    if (candidate.userId != null) {
      await _removeFromRequestedCache('${candidate.userId}');
    }
  }

  Future<void> sendContactRequest() async {
    if (state.isSendingContactRequest || state.isContactRequestSent) return;

    emit(state.copyWith(isSendingContactRequest: true));

    final result = await sendContactRequestUseCase(state.candidate.id);

    result.fold(
      (failure) {
        emit(state.copyWith(
          isSendingContactRequest: false,
          errorMessage: failure.serverException.message,
        ));
      },
      (data) async {
        final message = data['message']?.toString() ?? 'تم إرسال طلب التواصل بنجاح';
        String statusLabel = 'طلب تواصل قيد الانتظار';
        if (data['data'] is Map && data['data']['application'] is Map) {
          final app = data['data']['application'] as Map;
          if (app['status_label'] != null) {
            statusLabel = app['status_label'].toString();
          }
        }

        await _saveAllCandidateCache(state.candidate, statusLabel);

        try {
          sl<CompanyRequestsCubit>().fetchRequests(isRefresh: true);
        } catch (_) {}

        emit(state.copyWith(
          isSendingContactRequest: false,
          isContactRequestSent: true,
          contactRequestMessage: message,
          contactRequestStatusLabel: statusLabel,
        ));
      },
    );
  }

  /// Called by the UI to do a local-only optimistic toggle.
  void toggleBookmarkLocally() {
    final newSaved = !state.candidate.isSaved;
    emit(state.copyWith(
      candidate: state.candidate.copyWith(isSaved: newSaved),
    ));
  }

  /// Called by the UI to sync this cubit's bookmark state from BookmarksCubit.
  void syncBookmarkState({required bool isSaved}) {
    if (state.candidate.isSaved != isSaved) {
      emit(state.copyWith(
        candidate: state.candidate.copyWith(isSaved: isSaved),
      ));
    }
  }
}
