import 'package:m_kemet/src/features/job_seeker/domain/entities/experience_level_entity.dart';

class ExperienceLevelModel extends ExperienceLevelEntity {
  const ExperienceLevelModel({
    required super.id,
    required super.name,
  });

  factory ExperienceLevelModel.fromJson(Map<String, dynamic> json) {
    return ExperienceLevelModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
