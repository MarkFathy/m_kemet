import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m_kemet/src/core/error/failure.dart';

abstract class BaseUseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

abstract class BaseUseCaseNoParams<T> {
  Future<Either<Failure, T>> call();
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
