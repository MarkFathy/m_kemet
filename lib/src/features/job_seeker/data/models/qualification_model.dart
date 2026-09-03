import 'package:m_kemet/src/features/job_seeker/domain/entities/qualification_entity.dart';

class QualificationModel extends QualificationEntity {
  const QualificationModel({
    required super.id,
    required super.name,
    super.code,
  });

  factory QualificationModel.fromJson(Map<String, dynamic> json) {
    return QualificationModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? json['title']?.toString() ?? '',
      code: json['code']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
      };
}
