import 'package:equatable/equatable.dart';

class ExperienceLevelEntity extends Equatable {
  final int id;
  final String name;

  const ExperienceLevelEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
