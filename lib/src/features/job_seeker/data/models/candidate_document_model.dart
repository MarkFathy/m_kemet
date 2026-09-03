import 'package:m_kemet/src/features/job_seeker/domain/entities/candidate_document_entity.dart';

class CandidateDocumentModel extends CandidateDocumentEntity {
  const CandidateDocumentModel({
    required super.id,
    required super.documentType,
    super.filePath,
    super.originalName,
    super.mimeType,
    super.fileSize,
    super.fileUrl,
  });

  factory CandidateDocumentModel.fromJson(Map<String, dynamic> json) {
    return CandidateDocumentModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      documentType: json['document_type']?.toString() ?? json['type']?.toString() ?? '',
      filePath: json['file_path']?.toString() ?? json['path']?.toString(),
      originalName: json['original_name']?.toString() ?? json['file_name']?.toString(),
      mimeType: json['mime_type']?.toString(),
      fileSize: json['file_size'] is int ? json['file_size'] as int : int.tryParse(json['file_size']?.toString() ?? ''),
      fileUrl: json['file_url']?.toString() ?? json['url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'document_type': documentType,
        'file_path': filePath,
        'original_name': originalName,
        'mime_type': mimeType,
        'file_size': fileSize,
        'file_url': fileUrl,
      };
}
