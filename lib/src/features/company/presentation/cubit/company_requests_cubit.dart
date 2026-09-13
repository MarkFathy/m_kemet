import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_kemet/src/features/company/domain/usecases/get_company_contact_requests_usecase.dart';
import 'package:m_kemet/src/features/company/presentation/cubit/company_requests_state.dart';

class CompanyRequestsCubit extends Cubit<CompanyRequestsState> {
  final GetCompanyContactRequestsUseCase getRequestsUseCase;

  CompanyRequestsCubit({required this.getRequestsUseCase})
      : super(const CompanyRequestsState());

  Future<void> fetchRequests({bool isRefresh = false}) async {
    if (!isRefresh && state.requests.isEmpty) {
      emit(state.copyWith(status: CompanyRequestsStatus.loading));
    }
    final result = await getRequestsUseCase();
    result.fold(
      (failure) => emit(state.copyWith(
        status: CompanyRequestsStatus.failure,
        errorMessage: failure.serverException.message,
      )),
      (requests) => emit(state.copyWith(
        status: CompanyRequestsStatus.success,
        requests: requests,
        errorMessage: null,
      )),
    );
  }
}
