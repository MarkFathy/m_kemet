import 'package:m_kemet/src/features/company/data/models/candidate_model.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';

class CompanyContactRequestModel {
  final int id;
  final String? code;
  final String name;
  final String profession;
  final String? requestDate;
  final String? createdAt;
  final String status;
  final String statusLabel;
  final String? notes;
  final CandidateEntity? candidate;

  const CompanyContactRequestModel({
    required this.id,
    this.code,
    required this.name,
    required this.profession,
    this.requestDate,
    this.createdAt,
    required this.status,
    required this.statusLabel,
    this.notes,
    this.candidate,
  });

  factory CompanyContactRequestModel.fromJson(Map<String, dynamic> json) {
    CandidateEntity? candidateEntity;
    if (json['candidate'] is Map<String, dynamic>) {
      candidateEntity = CandidateModel.fromJson(json['candidate'] as Map<String, dynamic>);
    }

    return CompanyContactRequestModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse('${json['id']}') ?? 0,
      code: json['code']?.toString(),
      name: json['name']?.toString() ?? candidateEntity?.name ?? '',
      profession: json['profession']?.toString() ?? candidateEntity?.profession ?? '',
      requestDate: json['request_date']?.toString(),
      createdAt: json['created_at']?.toString(),
      status: json['status']?.toString() ?? 'pending',
      statusLabel: json['status_label']?.toString() ?? 'طلب تواصل قيد الانتظار',
      notes: json['notes']?.toString(),
      candidate: candidateEntity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'profession': profession,
      'request_date': requestDate,
      'created_at': createdAt,
      'status': status,
      'status_label': statusLabel,
      'notes': notes,
    };
  }
}
