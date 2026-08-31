import 'package:m_kemet/src/features/auth/domain/entities/gender_entity.dart';

class GenderModel extends GenderEntity {
  const GenderModel({required super.id, required super.name});

  factory GenderModel.fromJson(Map<String, dynamic> json) {
    return GenderModel(
      id: json['id'] as int,
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
