import 'package:equatable/equatable.dart';

class CandidateDocumentEntity extends Equatable {
  final int id;
  final String documentType;
  final String? filePath;
  final String? originalName;
  final String? mimeType;
  final int? fileSize;
  final String? fileUrl;

  const CandidateDocumentEntity({
    required this.id,
    required this.documentType,
    this.filePath,
    this.originalName,
    this.mimeType,
    this.fileSize,
    this.fileUrl,
  });

  @override
  List<Object?> get props => [
        id,
        documentType,
        filePath,
        originalName,
        mimeType,
        fileSize,
        fileUrl,
      ];
}
