import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';
import 'package:m_kemet/src/features/company/domain/usecases/get_candidate_detail_usecase.dart';
import 'package:m_kemet/src/features/company/domain/usecases/send_contact_request_usecase.dart';
import 'package:m_kemet/src/features/company/presentation/cubit/candidate_detail_state.dart';

class CandidateDetailCubit extends Cubit<CandidateDetailState> {
  final GetCandidateDetailUseCase getCandidateDetailUseCase;
  final SendContactRequestUseCase sendContactRequestUseCase;

  CandidateDetailCubit({
    required this.getCandidateDetailUseCase,
    required this.sendContactRequestUseCase,
    required CandidateEntity initialCandidate,
    bool initialIsBookmarked = false,
  }) : super(CandidateDetailState(
          candidate: initialCandidate.copyWith(isSaved: initialIsBookmarked),
          isContactRequestSent: initialCandidate.isContactRequested,
        ));

  Future<void> fetchCandidateDetail() async {
    emit(state.copyWith(status: CandidateDetailStatus.loading));
    final result = await getCandidateDetailUseCase(state.candidate.id);
    result.fold(
      (failure) => emit(state.copyWith(
        status: CandidateDetailStatus.failure,
        errorMessage: failure.serverException.message,
      )),
      (detailedCandidate) => emit(state.copyWith(
        status: CandidateDetailStatus.success,
        // Preserve isSaved from BookmarksCubit — don't overwrite from getCandidateDetail
        // because the detail API doesn't reliably return is_bookmarked for companies
        candidate: detailedCandidate.copyWith(isSaved: state.candidate.isSaved),
        isContactRequestSent:
            state.isContactRequestSent || detailedCandidate.isContactRequested,
      )),
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
      (data) {
        final message = data['message']?.toString() ?? 'تم إرسال طلب التواصل بنجاح';
        String statusLabel = 'طلب تواصل قيد الانتظار';
        if (data['data'] is Map && data['data']['application'] is Map) {
          final app = data['data']['application'] as Map;
          if (app['status_label'] != null) {
            statusLabel = app['status_label'].toString();
          }
        }
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
