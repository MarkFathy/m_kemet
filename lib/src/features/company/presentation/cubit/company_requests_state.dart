import 'package:equatable/equatable.dart';
import 'package:m_kemet/src/features/company/data/models/company_contact_request_model.dart';

enum CompanyRequestsStatus { initial, loading, success, failure }

class CompanyRequestsState extends Equatable {
  final CompanyRequestsStatus status;
  final List<CompanyContactRequestModel> requests;
  final String? errorMessage;

  const CompanyRequestsState({
    this.status = CompanyRequestsStatus.initial,
    this.requests = const [],
    this.errorMessage,
  });

  CompanyRequestsState copyWith({
    CompanyRequestsStatus? status,
    List<CompanyContactRequestModel>? requests,
    String? errorMessage,
  }) {
    return CompanyRequestsState(
      status: status ?? this.status,
      requests: requests ?? this.requests,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, requests, errorMessage];
}
