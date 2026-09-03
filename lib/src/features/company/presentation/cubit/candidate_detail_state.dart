import 'package:equatable/equatable.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';

enum CandidateDetailStatus { initial, loading, success, failure }

class CandidateDetailState extends Equatable {
  final CandidateDetailStatus status;
  final CandidateEntity candidate;
  final String? errorMessage;
  final bool isContactRequestSent;
  final bool isSendingContactRequest;
  final String? contactRequestMessage;
  final String? contactRequestStatusLabel;

  const CandidateDetailState({
    this.status = CandidateDetailStatus.initial,
    required this.candidate,
    this.errorMessage,
    this.isContactRequestSent = false,
    this.isSendingContactRequest = false,
    this.contactRequestMessage,
    this.contactRequestStatusLabel,
  });

  CandidateDetailState copyWith({
    CandidateDetailStatus? status,
    CandidateEntity? candidate,
    String? errorMessage,
    bool? isContactRequestSent,
    bool? isSendingContactRequest,
    String? contactRequestMessage,
    String? contactRequestStatusLabel,
  }) {
    return CandidateDetailState(
      status: status ?? this.status,
      candidate: candidate ?? this.candidate,
      errorMessage: errorMessage ?? this.errorMessage,
      isContactRequestSent: isContactRequestSent ?? this.isContactRequestSent,
      isSendingContactRequest: isSendingContactRequest ?? this.isSendingContactRequest,
      contactRequestMessage: contactRequestMessage ?? this.contactRequestMessage,
      contactRequestStatusLabel: contactRequestStatusLabel ?? this.contactRequestStatusLabel,
    );
  }

  @override
  List<Object?> get props => [
        status,
        candidate,
        errorMessage,
        isContactRequestSent,
        isSendingContactRequest,
        contactRequestMessage,
        contactRequestStatusLabel,
      ];
}
