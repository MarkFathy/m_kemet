import 'package:m_kemet/src/features/job_seeker/domain/entities/profession_entity.dart';

class ProfessionModel extends ProfessionEntity {
  const ProfessionModel({
    required super.id,
    required super.name,
    super.category,
  });

  factory ProfessionModel.fromJson(Map<String, dynamic> json) {
    return ProfessionModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      // API returns "title" field — fall back to "name" for future compatibility
      name: json['title']?.toString() ?? json['name']?.toString() ?? '',
      category: json['category']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': name,
        'category': category,
      };
}
