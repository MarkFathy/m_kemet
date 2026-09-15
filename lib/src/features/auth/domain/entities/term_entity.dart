import 'package:equatable/equatable.dart';

class TermEntity extends Equatable {
  final int id;
  final String slug;
  final String title;
  final String desc;
  final bool isActive;
  final int sortOrder;

  const TermEntity({
    required this.id,
    required this.slug,
    required this.title,
    required this.desc,
    this.isActive = true,
    this.sortOrder = 0,
  });

  @override
  List<Object?> get props => [id, slug, title, desc, isActive, sortOrder];
}
