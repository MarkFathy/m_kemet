import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/helpers/document_filter_helper.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/cubit/job_seeker_profile_cubit.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/cubit/job_seeker_profile_state.dart';

import 'package:m_kemet/src/core/widgets/crop_image_modal.dart';
import 'package:m_kemet/src/core/widgets/image_preview_modal.dart';
import 'package:m_kemet/src/core/widgets/image_source_selection_bottom_sheet.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/profile_setup/identity_document_type_selector.dart';

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
      cameraLabel: 'الكاميرا',
      galleryLabel: 'المعرض',
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
    required JobSeekerProfileCubit cubit,
    required Future<void> Function(File file) uploadFn,
  }) async {
    // If not running on Android (e.g. iOS), fallback to regular image picker with crop
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
        cubit.setPassportUploading();
        final processedPath =
            await DocumentFilterHelper.processCamScannerImage(images.first);
        final file = File(processedPath);
        if (!context.mounted) return;
        await uploadFn(file);
      }
    } catch (e) {
      cubit.resetPassportStatus();
      debugPrint('Error scanning passport: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تعذر مسح جواز السفر، يرجى التأكد من صلاحية الكاميرا والمحاولة مرة أخرى',
              style: getTextStyle().white.w500.s14,
            ),
            backgroundColor: AppColors.errorRed,
          ),
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

        final isPersonalPhotoUploaded = state.isPersonalPhotoUploaded;
        final isPersonalPhotoUploading =
            state.personalPhotoStatus == DocumentUploadStatus.uploading;

        final isNationalIdUploaded = state.isNationalIdUploaded;
        final isNationalIdUploading =
            state.nationalIdStatus == DocumentUploadStatus.uploading;

        final isPassportUploaded = state.isPassportUploaded;
        final isPassportUploading =
            state.passportStatus == DocumentUploadStatus.uploading;

        final isCvUploaded = state.isCvUploaded;
        final isCvUploading =
            state.cvStatus == DocumentUploadStatus.uploading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).documentsSectionTitle,
              style: getTextStyle().darkNavy.w700.s20,
            ),

            12.szH,

            // Item 1: Personal Photo
            _buildDocumentCard(
              context: context,
              title: S.of(context).personalPhotoTitle,
              subtitle: 'صورة شخصية حديثة بخلفية بيضاء',
              icon: Icons.add_a_photo_outlined,
              iconBgColor: AppColors.softBlueBg,
              isUploaded: isPersonalPhotoUploaded,
              isUploading: isPersonalPhotoUploading,
              fileName: state.uploadedPersonalPhoto?.originalName ??
                  state.localPersonalPhotoPath?.split(Platform.pathSeparator).last,
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

            // Identity Document Choice Selector
            IdentityDocumentTypeSelector(
              selectedChoice: state.identityDocumentChoice,
              onChoiceChanged: cubit.selectIdentityDocumentChoice,
            ),

            12.szH,

            // Item 2: National ID Card (visible if choice is nationalId or both)
            if (state.identityDocumentChoice == IdentityDocumentChoice.nationalId ||
                state.identityDocumentChoice == IdentityDocumentChoice.both) ...[
              _buildDocumentCard(
                context: context,
                title: S.of(context).idCardTitle,
                subtitle: S.of(context).idCardSubtitle,
                icon: Icons.credit_card_rounded,
                iconBgColor: AppColors.softBlueBg,
                isUploaded: isNationalIdUploaded,
                isUploading: isNationalIdUploading,
                fileName: state.uploadedNationalId?.originalName ??
                    state.localNationalIdPath?.split(Platform.pathSeparator).last,
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
            ],

            // Item 3: Passport Copy Card (visible if choice is passport or both)
            if (state.identityDocumentChoice == IdentityDocumentChoice.passport ||
                state.identityDocumentChoice == IdentityDocumentChoice.both) ...[
              _buildDocumentCard(
                context: context,
                title: S.of(context).passportCopyTitle,
                icon: Icons.badge_outlined,
                iconBgColor: AppColors.softBlueBg,
                isUploaded: isPassportUploaded,
                isUploading: isPassportUploading,
                fileName: state.uploadedPassport?.originalName ??
                    state.localPassportPath?.split(Platform.pathSeparator).last,
                onUploadTap: () => _scanAndUploadPassport(
                  context: context,
                  cubit: cubit,
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
                      cubit: cubit,
                      uploadFn: cubit.uploadPassport,
                    ),
                  );
                },
              ),
              12.szH,
            ],

            // Item 4: CV Upload Dropzone
            _buildCvUploadCard(
              context: context,
              isUploaded: isCvUploaded,
              isUploading: isCvUploading,
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

  Widget _buildDocumentCard({
    required BuildContext context,
    required String title,
    String? subtitle,
    required IconData icon,
    required Color iconBgColor,
    required bool isUploaded,
    required bool isUploading,
    String? fileName,
    required VoidCallback onUploadTap,
    VoidCallback? onPreviewTap,
  }) {
    return InkWell(
      onTap: isUploaded ? onPreviewTap : onUploadTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isUploaded ? AppColors.successGreen : AppColors.borderGrey,
            width: isUploaded ? 1.5.w : 1.w,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22.r,
                  backgroundColor: isUploaded ? AppColors.successBg : iconBgColor,
                  child: Icon(
                    isUploaded ? Icons.check_circle_outline_rounded : icon,
                    color: isUploaded ? AppColors.successGreen : AppColors.darkNavy,
                    size: 20.sp,
                  ),
                ),
                12.szW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: getTextStyle().darkNavy.w700.s16,
                      ),
                      if (subtitle != null && subtitle.isNotEmpty) ...[
                        4.szH,
                        Text(
                          subtitle,
                          style: getTextStyle().greyColor.w400.s12,
                        ),
                      ],
                    ],
                  ),
                ),
                if (isUploading)
                  SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                else if (isUploaded)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onPreviewTap != null)
                        InkWell(
                          onTap: onPreviewTap,
                          borderRadius: BorderRadius.circular(8.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                            decoration: BoxDecoration(
                              color: AppColors.softBlueBg,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: AppColors.darkNavy.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.visibility_outlined, color: AppColors.darkNavy, size: 16.sp),
                                4.szW,
                                Text(
                                  S.of(context).viewPhoto,
                                  style: getTextStyle().darkNavy.w600.s12,
                                ),
                              ],
                            ),
                          ),
                        ),
                      6.szW,
                      InkWell(
                        onTap: onUploadTap,
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.refresh_rounded, color: AppColors.greyColor, size: 16.sp),
                              4.szW,
                              Text(
                                S.of(context).changeMedia,
                                style: getTextStyle().greyColor.w600.s12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  OutlinedButton(
                    onPressed: onUploadTap,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.darkNavy,
                      side: const BorderSide(color: AppColors.darkNavy),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    ),
                    child: Text(
                      S.of(context).uploadAction,
                      style: getTextStyle().darkNavy.w600.s13,
                    ),
                  ),
              ],
            ),
            if (isUploaded && fileName != null) ...[
              8.szH,
              Row(
                children: [
                  Icon(Icons.attachment_rounded, size: 14.sp, color: AppColors.greyColor),
                  4.szW,
                  Expanded(
                    child: Text(
                      fileName,
                      style: getTextStyle().greyColor.w500.s12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCvUploadCard({
    required BuildContext context,
    required bool isUploaded,
    required bool isUploading,
    String? fileName,
    required VoidCallback onUploadTap,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isUploaded ? AppColors.successGreen : AppColors.borderGrey,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: isUploaded ? AppColors.successBg : AppColors.borderGrey,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.description_outlined,
                  color: isUploaded ? AppColors.successGreen : AppColors.darkNavy,
                  size: 22.sp,
                ),
              ),
              12.szW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).cvTitle,
                      style: getTextStyle().darkNavy.w700.s16,
                    ),
                    4.szH,
                    Text(
                      S.of(context).cvDesc,
                      style: getTextStyle().greyColor.w400.s12,
                    ),
                  ],
                ),
              ),
              if (isUploaded)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.successBg,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    S.of(context).uploadedBadge,
                    style: getTextStyle().w600.s11.copyWith(color: AppColors.successGreen),
                  ),
                )
              else
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.errorBg,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    S.of(context).requiredBadge,
                    style: getTextStyle().w600.s11.copyWith(color: AppColors.errorRed),
                  ),
                ),
            ],
          ),

          14.szH,

          if (isUploading)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: const CircularProgressIndicator(),
              ),
            )
          else
            InkWell(
              onTap: onUploadTap,
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 14.w),
                decoration: BoxDecoration(
                  color: isUploaded ? AppColors.successBg.withValues(alpha: 0.3) : AppColors.pageBg,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isUploaded ? AppColors.successGreen : AppColors.darkNavy.withValues(alpha: 0.3),
                    width: 1.5.w,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      isUploaded ? Icons.check_circle_outline_rounded : Icons.cloud_upload_outlined,
                      size: 28.sp,
                      color: isUploaded ? AppColors.successGreen : AppColors.darkNavy,
                    ),
                    8.szH,
                    Text(
                      isUploaded && fileName != null ? fileName : S.of(context).dragAndDropHint,
                      textAlign: TextAlign.center,
                      style: isUploaded
                          ? getTextStyle().darkNavy.w600.s13
                          : getTextStyle().darkNavy.w600.s13,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
