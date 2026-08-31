import 'package:equatable/equatable.dart';

class CountryEntity extends Equatable {
  final int id;
  final String name;
  final String? code;
  final String? flag;

  const CountryEntity({
    required this.id,
    required this.name,
    this.code,
    this.flag,
  });

  @override
  List<Object?> get props => [id, name, code, flag];
}
