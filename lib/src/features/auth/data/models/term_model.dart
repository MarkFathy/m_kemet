import 'package:m_kemet/src/features/auth/domain/entities/term_entity.dart';

class TermModel extends TermEntity {
  const TermModel({
    required super.id,
    required super.slug,
    required super.title,
    required super.desc,
    super.isActive,
    super.sortOrder,
  });

  factory TermModel.fromJson(Map<String, dynamic> json) {
    return TermModel(
      id: json['id'] as int? ?? 0,
      slug: json['slug'] as String? ?? '',
      title: json['title'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'title': title,
      'desc': desc,
      'is_active': isActive,
      'sort_order': sortOrder,
    };
  }
}
