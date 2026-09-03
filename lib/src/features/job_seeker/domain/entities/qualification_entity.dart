import 'package:equatable/equatable.dart';

class QualificationEntity extends Equatable {
  final int id;
  final String name;
  final String? code;

  const QualificationEntity({
    required this.id,
    required this.name,
    this.code,
  });

  @override
  List<Object?> get props => [id, name, code];
}
