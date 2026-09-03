import 'package:equatable/equatable.dart';

class ProfessionEntity extends Equatable {
  final int id;
  final String name;
  final String? category;

  const ProfessionEntity({
    required this.id,
    required this.name,
    this.category,
  });

  @override
  List<Object?> get props => [id, name, category];
}
