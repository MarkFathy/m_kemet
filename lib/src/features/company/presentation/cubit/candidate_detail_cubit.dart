import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_kemet/src/features/company/data/datasources/candidate_local_data_source.dart';
import 'package:m_kemet/src/features/company/data/models/company_contact_request_model.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';
import 'package:m_kemet/src/features/company/domain/usecases/get_candidate_detail_usecase.dart';
import 'package:m_kemet/src/features/company/domain/usecases/get_company_contact_requests_usecase.dart';
import 'package:m_kemet/src/features/company/domain/usecases/send_contact_request_usecase.dart';
import 'package:m_kemet/src/features/company/presentation/cubit/candidate_detail_state.dart';
import 'package:m_kemet/src/features/company/presentation/cubit/company_requests_cubit.dart';

class CandidateDetailCubit extends Cubit<CandidateDetailState> {
  final GetCandidateDetailUseCase getCandidateDetailUseCase;
  final SendContactRequestUseCase sendContactRequestUseCase;
  final GetCompanyContactRequestsUseCase getCompanyContactRequestsUseCase;
  final CandidateLocalDataSource localDataSource;
  final CompanyRequestsCubit? companyRequestsCubit;

  CandidateDetailCubit({
    required this.getCandidateDetailUseCase,
    required this.sendContactRequestUseCase,
    required this.getCompanyContactRequestsUseCase,
    required this.localDataSource,
    this.companyRequestsCubit,
    required CandidateEntity initialCandidate,
    bool initialIsBookmarked = false,
  }) : super(CandidateDetailState(
          candidate: initialCandidate.copyWith(isSaved: initialIsBookmarked),
          isContactRequestSent: _checkInitiallyRequested(localDataSource, initialCandidate),
          contactRequestStatusLabel: _getInitialStatusLabel(localDataSource, initialCandidate),
        ));

  static bool _checkInitiallyRequested(
    CandidateLocalDataSource dataSource,
    CandidateEntity candidate,
  ) {
    return dataSource.isCandidateContactRequested(candidate.id) ||
        (candidate.userId != null &&
            dataSource.isCandidateContactRequested('${candidate.userId}')) ||
        dataSource.isCandidateContactRequested(candidate.name) ||
        candidate.isContactRequested;
  }

  static String? _getInitialStatusLabel(
    CandidateLocalDataSource dataSource,
    CandidateEntity candidate,
  ) {
    return dataSource.getCachedContactStatus(candidate.id) ??
        dataSource.getCachedContactStatus(candidate.name) ??
        (candidate.isContactRequested ? candidate.contactRequestStatus : null);
  }

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

  bool _isLocallyRequested(CandidateEntity candidate, CandidateEntity detailedCandidate) {
    return localDataSource.isCandidateContactRequested(candidate.id) ||
        (candidate.userId != null &&
            localDataSource.isCandidateContactRequested('${candidate.userId}')) ||
        localDataSource.isCandidateContactRequested(candidate.name) ||
        localDataSource.isCandidateContactRequested(detailedCandidate.name);
  }

  Future<void> _saveAllCandidateCache(CandidateEntity candidate, String label) async {
    await localDataSource.cacheCandidateContactRequest(candidate.id, label);
    await localDataSource.cacheCandidateContactRequest(state.candidate.name, label);
    await localDataSource.cacheCandidateContactRequest(candidate.name, label);
    if (candidate.userId != null) {
      await localDataSource.cacheCandidateContactRequest('${candidate.userId}', label);
    }
  }

  Future<void> _clearAllCandidateCache(CandidateEntity candidate) async {
    await localDataSource.clearCandidateContactRequestCache(candidate.id);
    await localDataSource.clearCandidateContactRequestCache(state.candidate.name);
    await localDataSource.clearCandidateContactRequestCache(candidate.name);
    if (candidate.userId != null) {
      await localDataSource.clearCandidateContactRequestCache('${candidate.userId}');
    }
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
        final wasLocallyRequested = _isLocallyRequested(state.candidate, detailedCandidate);

        // Check if candidate detail itself contains explicit rejection
        final status = detailedCandidate.contactRequestStatus.toLowerCase();
        final isDetailRejected = status == 'rejected' ||
            status == 'refused' ||
            status == 'declined' ||
            status.contains('مرفوض');

        if (isDetailRejected) {
          await _clearAllCandidateCache(detailedCandidate);
          emit(state.copyWith(
            status: CandidateDetailStatus.success,
            candidate: detailedCandidate.copyWith(isSaved: state.candidate.isSaved),
            isContactRequestSent: false,
            contactRequestStatusLabel: null,
          ));
          return;
        }

        // Check against the actual list of requests from the server via injected usecase
        try {
          final requestsResult = await getCompanyContactRequestsUseCase();
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
                _clearAllCandidateCache(detailedCandidate);
                emit(state.copyWith(
                  status: CandidateDetailStatus.success,
                  candidate: detailedCandidate.copyWith(isSaved: state.candidate.isSaved),
                  isContactRequestSent: false,
                  contactRequestStatusLabel: null,
                ));
              } else {
                final label = matchingReq!.statusLabel.isNotEmpty
                    ? matchingReq!.statusLabel
                    : (detailedCandidate.contactRequestStatus.isNotEmpty
                        ? detailedCandidate.contactRequestStatus
                        : 'طلب تواصل قيد الانتظار');
                _saveAllCandidateCache(detailedCandidate, label);
                emit(state.copyWith(
                  status: CandidateDetailStatus.success,
                  candidate: detailedCandidate.copyWith(isSaved: state.candidate.isSaved),
                  isContactRequestSent: true,
                  contactRequestStatusLabel: label,
                ));
              }
            } else {
              if (wasLocallyRequested) {
                _clearAllCandidateCache(detailedCandidate);
              }
              emit(state.copyWith(
                status: CandidateDetailStatus.success,
                candidate: detailedCandidate.copyWith(isSaved: state.candidate.isSaved),
                isContactRequestSent: false,
                contactRequestStatusLabel: null,
              ));
            }
          });
          return;
        } catch (_) {}

        // Fallback if requests check could not complete (e.g. offline)
        final isRequested = wasLocallyRequested ||
            detailedCandidate.isContactRequested ||
            state.candidate.isContactRequested;
        final label = localDataSource.getCachedContactStatus(state.candidate.id) ??
            localDataSource.getCachedContactStatus(detailedCandidate.id) ??
            (detailedCandidate.contactRequestStatus.isNotEmpty
                ? detailedCandidate.contactRequestStatus
                : state.contactRequestStatusLabel);

        emit(state.copyWith(
          status: CandidateDetailStatus.success,
          candidate: detailedCandidate.copyWith(isSaved: state.candidate.isSaved),
          isContactRequestSent: isRequested,
          contactRequestStatusLabel: isRequested ? label : null,
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
        final message = data['message']?.toString();
        String statusLabel = 'طلب تواصل قيد الانتظار';
        if (data['data'] is Map && data['data']['application'] is Map) {
          final app = data['data']['application'] as Map;
          if (app['status_label'] != null) {
            statusLabel = app['status_label'].toString();
          }
        }

        await _saveAllCandidateCache(state.candidate, statusLabel);

        companyRequestsCubit?.fetchRequests(isRefresh: true);

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
