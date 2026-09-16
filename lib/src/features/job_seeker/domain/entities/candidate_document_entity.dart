import 'package:equatable/equatable.dart';

class CandidateDocumentEntity extends Equatable {
  final int id;
  final String documentType;
  final String? filePath;
  final String? originalName;
  final String? mimeType;
  final int? fileSize;
  final String? fileUrl;
  final bool isApproved;
  final String? rejectionReason;

  const CandidateDocumentEntity({
    required this.id,
    required this.documentType,
    this.filePath,
    this.originalName,
    this.mimeType,
    this.fileSize,
    this.fileUrl,
    this.isApproved = true,
    this.rejectionReason,
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
        isApproved,
        rejectionReason,
      ];
}
