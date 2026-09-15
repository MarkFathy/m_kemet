import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/helpers/document_filter_helper.dart';
import 'package:m_kemet/src/core/widgets/crop_image_modal.dart';
import 'package:m_kemet/src/core/widgets/custom_snack_bar.dart';
import 'package:m_kemet/src/core/widgets/image_preview_modal.dart';
import 'package:m_kemet/src/core/widgets/image_source_selection_bottom_sheet.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/cubit/job_seeker_profile_cubit.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/cubit/job_seeker_profile_state.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/profile_setup/widgets/cv_upload_card.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/profile_setup/widgets/document_upload_card.dart';

class DocumentsUploadSection extends StatelessWidget {
  const DocumentsUploadSection({super.key});

  Future<void> _pickAndUploadImage({
    required BuildContext context,
    required Future<void> Function(File file) uploadFn,
    String? title,
    double? initialAspectRatio,
  }) async {
    ImageSourceSelectionBottomSheet.show(
      context,
      title: title ?? S.of(context).cropPhoto,
      cameraLabel: S.of(context).camera,
      galleryLabel: S.of(context).gallery,
      onSourceSelected: (source) async {
        final picker = ImagePicker();
        final picked = await picker.pickImage(
          source: source,
          imageQuality: 90,
        );
        if (picked != null) {
          final originalFile = File(picked.path);
          if (!context.mounted) return;
          File fileToUpload = originalFile;
          try {
            final cropped = await CropImageModal.show(
              context,
              imageFile: originalFile,
              title: title ?? S.of(context).cropPhoto,
              initialAspectRatio: initialAspectRatio,
            );
            if (cropped == null) {
              return;
            }
            fileToUpload = cropped;
          } catch (_) {
            fileToUpload = originalFile;
          }
          await uploadFn(fileToUpload);
        }
      },
    );
  }

  Future<void> _scanAndUploadPassport({
    required BuildContext context,
    required Future<void> Function(File file) uploadFn,
  }) async {
    if (!Platform.isAndroid) {
      await _pickAndUploadImage(
        context: context,
        uploadFn: uploadFn,
        title: S.of(context).cropPhoto,
      );
      return;
    }

    final options = DocumentScannerOptions(
      documentFormats: {DocumentFormat.jpeg},
      mode: ScannerMode.full,
      pageLimit: 1,
      isGalleryImport: false,
    );
    final documentScanner = DocumentScanner(options: options);

    try {
      final result = await documentScanner.scanDocument();
      final images = result.images;
      if (images != null && images.isNotEmpty) {
        final processedPath =
            await DocumentFilterHelper.processCamScannerImage(images.first);
        final file = File(processedPath);
        if (!context.mounted) return;
        await uploadFn(file);
      }
    } catch (e) {
      debugPrint('Error scanning passport: $e');
      if (context.mounted) {
        CustomSnackBar.showError(
          context,
          message: S.of(context).passportScanError,
        );
      }
    } finally {
      documentScanner.close();
    }
  }

  Future<void> _pickAndUploadPdf({
    required BuildContext context,
    required Future<void> Function(File file) uploadFn,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      await uploadFn(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JobSeekerProfileCubit, JobSeekerProfileState>(
      builder: (context, state) {
        final cubit = context.read<JobSeekerProfileCubit>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).documentsSectionTitle,
              style: getTextStyle().darkNavy.w700.s20,
            ),

            12.szH,

            // Item 1: Personal Photo
            DocumentUploadCard(
              title: S.of(context).personalPhotoTitle,
              subtitle: S.of(context).personalPhotoSubtitle,
              icon: Icons.add_a_photo_outlined,
              iconBgColor: AppColors.softBlueBg,
              isUploaded: state.isPersonalPhotoUploaded,
              isUploading:
                  state.personalPhotoStatus == DocumentUploadStatus.uploading,
              fileName: state.uploadedPersonalPhoto?.originalName ??
                  state.localPersonalPhotoPath
                      ?.split(Platform.pathSeparator)
                      .last,
              onUploadTap: () => _pickAndUploadImage(
                context: context,
                uploadFn: cubit.uploadPersonalPhoto,
                title: S.of(context).personalPhotoTitle,
                initialAspectRatio: 1.0,
              ),
              onPreviewTap: () {
                final file = state.localPersonalPhotoPath != null
                    ? File(state.localPersonalPhotoPath!)
                    : null;
                final url = state.uploadedPersonalPhoto?.fileUrl ??
                    state.uploadedPersonalPhoto?.filePath;
                ImagePreviewModal.show(
                  context,
                  file: file,
                  imageUrl: url,
                  title: S.of(context).personalPhotoTitle,
                  onChange: () => _pickAndUploadImage(
                    context: context,
                    uploadFn: cubit.uploadPersonalPhoto,
                    title: S.of(context).personalPhotoTitle,
                    initialAspectRatio: 1.0,
                  ),
                );
              },
            ),

            12.szH,

            // Item 2: National ID Card
            DocumentUploadCard(
              title: S.of(context).idCardTitle,
              subtitle: S.of(context).nationalIdSubtitle,
              icon: Icons.credit_card_rounded,
              iconBgColor: AppColors.softBlueBg,
              isUploaded: state.isNationalIdUploaded,
              isUploading:
                  state.nationalIdStatus == DocumentUploadStatus.uploading,
              fileName: state.uploadedNationalId?.originalName ??
                  state.localNationalIdPath
                      ?.split(Platform.pathSeparator)
                      .last,
              onUploadTap: () => _pickAndUploadImage(
                context: context,
                uploadFn: cubit.uploadNationalId,
                title: S.of(context).idCardTitle,
                initialAspectRatio: 4 / 3,
              ),
              onPreviewTap: () {
                final file = state.localNationalIdPath != null
                    ? File(state.localNationalIdPath!)
                    : null;
                final url = state.uploadedNationalId?.fileUrl ??
                    state.uploadedNationalId?.filePath;
                ImagePreviewModal.show(
                  context,
                  file: file,
                  imageUrl: url,
                  title: S.of(context).idCardTitle,
                  onChange: () => _pickAndUploadImage(
                    context: context,
                    uploadFn: cubit.uploadNationalId,
                    title: S.of(context).idCardTitle,
                    initialAspectRatio: 4 / 3,
                  ),
                );
              },
            ),

            12.szH,

            // Item 3: Passport Copy Card
            DocumentUploadCard(
              title: S.of(context).passportCopyTitle,
              icon: Icons.badge_outlined,
              iconBgColor: AppColors.softBlueBg,
              isUploaded: state.isPassportUploaded,
              isUploading:
                  state.passportStatus == DocumentUploadStatus.uploading,
              fileName: state.uploadedPassport?.originalName ??
                  state.localPassportPath?.split(Platform.pathSeparator).last,
              onUploadTap: () => _scanAndUploadPassport(
                context: context,
                uploadFn: cubit.uploadPassport,
              ),
              onPreviewTap: () {
                final file = state.localPassportPath != null
                    ? File(state.localPassportPath!)
                    : null;
                final url = state.uploadedPassport?.fileUrl ??
                    state.uploadedPassport?.filePath;
                ImagePreviewModal.show(
                  context,
                  file: file,
                  imageUrl: url,
                  title: S.of(context).passportCopyTitle,
                  onChange: () => _scanAndUploadPassport(
                    context: context,
                    uploadFn: cubit.uploadPassport,
                  ),
                );
              },
            ),

            12.szH,

            // Item 4: CV Upload Dropzone
            CvUploadCard(
              isUploaded: state.isCvUploaded,
              isUploading: state.cvStatus == DocumentUploadStatus.uploading,
              fileName: state.uploadedCv?.originalName ??
                  state.localCvPath?.split(Platform.pathSeparator).last,
              onUploadTap: () => _pickAndUploadPdf(
                context: context,
                uploadFn: cubit.uploadCv,
              ),
            ),
          ],
        );
      },
    );
  }
}
