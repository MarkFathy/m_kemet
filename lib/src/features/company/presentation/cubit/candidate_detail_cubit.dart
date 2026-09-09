import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_kemet/src/core/helpers/cache_service.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';
import 'package:m_kemet/src/features/company/domain/usecases/get_candidate_detail_usecase.dart';
import 'package:m_kemet/src/features/company/domain/usecases/send_contact_request_usecase.dart';
import 'package:m_kemet/src/features/company/presentation/cubit/candidate_detail_state.dart';

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
              initialCandidate.isContactRequested,
          contactRequestStatusLabel: _getCachedStatusLabel(initialCandidate.id),
        ));

  static bool _isPreviouslyRequested(String candidateId) {
    try {
      final cached = CacheStorage.read(_requestedCandidatesKey);
      if (cached is List) {
        return cached.map((e) => e.toString()).contains(candidateId);
      }
    } catch (_) {}
    return false;
  }

  static String? _getCachedStatusLabel(String candidateId) {
    try {
      final val = CacheStorage.read('$_contactStatusPrefix$candidateId');
      return val?.toString();
    } catch (_) {}
    return null;
  }

  static Future<void> _addToRequestedCache(String candidateId, String label) async {
    try {
      final cached = CacheStorage.read(_requestedCandidatesKey);
      List<String> list = [];
      if (cached is List) {
        list = cached.map((e) => e.toString()).toList();
      }
      if (!list.contains(candidateId)) {
        list.add(candidateId);
        await CacheStorage.write(_requestedCandidatesKey, list);
      }
      await CacheStorage.write('$_contactStatusPrefix$candidateId', label);
    } catch (_) {}
  }

  static Future<void> _removeFromRequestedCache(String candidateId) async {
    try {
      final cached = CacheStorage.read(_requestedCandidatesKey);
      if (cached is List) {
        final list = cached.map((e) => e.toString()).toList();
        list.remove(candidateId);
        await CacheStorage.write(_requestedCandidatesKey, list);
      }
      await CacheStorage.delete('$_contactStatusPrefix$candidateId');
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
      (detailedCandidate) {
        // If the request was explicitly rejected by the candidate / server,
        // allow the employer to send another request!
        final status = detailedCandidate.contactRequestStatus.toLowerCase();
        final isRejected = status == 'rejected' ||
            status == 'refused' ||
            status == 'declined' ||
            status.contains('مرفوض');

        if (isRejected) {
          _removeFromRequestedCache(state.candidate.id);
          emit(state.copyWith(
            status: CandidateDetailStatus.success,
            candidate: detailedCandidate.copyWith(isSaved: state.candidate.isSaved),
            isContactRequestSent: false,
            contactRequestStatusLabel: null,
          ));
          return;
        }

        final isSent = detailedCandidate.isContactRequested ||
            _isPreviouslyRequested(state.candidate.id);

        final label = state.contactRequestStatusLabel ??
            _getCachedStatusLabel(state.candidate.id) ??
            (isSent ? 'طلب تواصل قيد الانتظار' : null);

        emit(state.copyWith(
          status: CandidateDetailStatus.success,
          candidate: detailedCandidate.copyWith(isSaved: state.candidate.isSaved),
          isContactRequestSent: isSent,
          contactRequestStatusLabel: label,
        ));
      },
    );
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

        await _addToRequestedCache(state.candidate.id, statusLabel);

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
  /// The actual API call is made exclusively by BookmarksCubit to avoid
  /// making the same network request twice.
  void toggleBookmarkLocally() {
    final newSaved = !state.candidate.isSaved;
    emit(state.copyWith(
      candidate: state.candidate.copyWith(isSaved: newSaved),
    ));
  }

  /// Called by the UI to sync this cubit's bookmark state from BookmarksCubit
  /// (e.g., after a rollback due to an API failure).
  void syncBookmarkState({required bool isSaved}) {
    if (state.candidate.isSaved != isSaved) {
      emit(state.copyWith(
        candidate: state.candidate.copyWith(isSaved: isSaved),
      ));
    }
  }
}
